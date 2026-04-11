import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/config/app_config.dart';
import '../database/app_database.dart';
import '../database/schema.dart';

typedef BackupDirectoryProvider = Future<Directory> Function();

class BackupPayload {
  const BackupPayload({
    required this.schemaVersion,
    required this.createdAt,
    required this.appVersion,
    required this.dependants,
    required this.notes,
    required this.schedulers,
  });

  final int schemaVersion;
  final DateTime createdAt;
  final String appVersion;
  final List<Map<String, dynamic>> dependants;
  final List<Map<String, dynamic>> notes;
  final List<Map<String, dynamic>> schedulers;

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'createdAt': createdAt.toIso8601String(),
      'appVersion': appVersion,
      'dependants': dependants,
      'notes': notes,
      'schedulers': schedulers,
    };
  }

  factory BackupPayload.fromJson(Map<String, dynamic> json) {
    final schemaVersion = json['schemaVersion'];
    if (schemaVersion is! int || schemaVersion <= 0) {
      throw const FormatException('Virheellinen varmuuskopion versio.');
    }

    final createdAtRaw = json['createdAt'] as String?;
    if (createdAtRaw == null || createdAtRaw.isEmpty) {
      throw const FormatException('Varmuuskopion aikaleima puuttuu.');
    }

    return BackupPayload(
      schemaVersion: schemaVersion,
      createdAt: DateTime.parse(createdAtRaw),
      appVersion: json['appVersion'] as String? ?? 'unknown',
      dependants: _parseRows(json['dependants'], 'dependants'),
      notes: _parseRows(json['notes'], 'notes'),
      schedulers: _parseRows(json['schedulers'], 'schedulers'),
    );
  }

  static List<Map<String, dynamic>> _parseRows(Object? value, String field) {
    if (value is! List) {
      throw FormatException('Varmuuskopion kenttä "$field" puuttuu.');
    }

    return value
        .map((item) {
          if (item is! Map) {
            throw FormatException(
              'Varmuuskopion kenttä "$field" on virheellinen.',
            );
          }
          return Map<String, dynamic>.from(item.cast<String, dynamic>());
        })
        .toList(growable: false);
  }
}

class AppBackupService {
  AppBackupService({
    required AppDatabase database,
    BackupDirectoryProvider? automaticBackupDirectoryProvider,
    BackupDirectoryProvider? exportDirectoryProvider,
    DateTime Function()? nowProvider,
    this.automaticBackupDelay = const Duration(seconds: 15),
  }) : _database = database,
       _automaticBackupDirectoryProvider =
           automaticBackupDirectoryProvider ?? getApplicationDocumentsDirectory,
       _exportDirectoryProvider =
           exportDirectoryProvider ?? getTemporaryDirectory,
       _nowProvider = nowProvider ?? DateTime.now;

  static const backupSchemaVersion = 1;
  static const _automaticBackupFolderName = 'backups';
  static const _automaticBackupLatestFileName = 'huoltokirja-auto-latest.json';
  static const _automaticBackupPrefix = 'huoltokirja-auto';
  static const _manualBackupPrefix = 'huoltokirja-backup';
  static const _maxAutomaticHistoryFiles = 10;

  final AppDatabase _database;
  final BackupDirectoryProvider _automaticBackupDirectoryProvider;
  final BackupDirectoryProvider _exportDirectoryProvider;
  final DateTime Function() _nowProvider;
  final Duration automaticBackupDelay;

  Timer? _automaticBackupTimer;

  Future<BackupPayload> createBackupPayload() async {
    final dependants = await _database.raw.query(
      dependantTable,
      orderBy: 'id ASC',
    );
    final notes = await _database.raw.query(notesTable, orderBy: 'id ASC');
    final schedulers = await _database.raw.query(
      schedulersTable,
      orderBy: 'id ASC',
    );

    return BackupPayload(
      schemaVersion: backupSchemaVersion,
      createdAt: _nowProvider().toUtc(),
      appVersion: AppConfig.appVersion,
      dependants: dependants.map(_normalizeRow).toList(growable: false),
      notes: notes.map(_normalizeRow).toList(growable: false),
      schedulers: schedulers.map(_normalizeRow).toList(growable: false),
    );
  }

  String encodeBackupPayload(BackupPayload payload) {
    return const JsonEncoder.withIndent('  ').convert(payload.toJson());
  }

  Future<File> exportBackupArchive() async {
    final payload = await createBackupPayload();
    final directory = await _exportDirectoryProvider();
    await directory.create(recursive: true);

    final file = File(
      p.join(
        directory.path,
        '$_manualBackupPrefix-${_timestamp(_nowProvider())}.json',
      ),
    );
    await file.writeAsString(encodeBackupPayload(payload), flush: true);
    return file;
  }

  void scheduleAutomaticBackup() {
    _automaticBackupTimer?.cancel();
    _automaticBackupTimer = Timer(automaticBackupDelay, () {
      unawaited(createAutomaticBackup());
    });
  }

  Future<File?> flushPendingAutomaticBackup() async {
    final hadPendingBackup = _automaticBackupTimer != null;
    _automaticBackupTimer?.cancel();
    _automaticBackupTimer = null;

    if (!hadPendingBackup) {
      return null;
    }

    return createAutomaticBackup();
  }

  Future<File> createAutomaticBackup() async {
    final payload = await createBackupPayload();
    final rootDirectory = await _automaticBackupDirectoryProvider();
    final backupDirectory = Directory(
      p.join(rootDirectory.path, _automaticBackupFolderName),
    );
    await backupDirectory.create(recursive: true);

    final contents = encodeBackupPayload(payload);
    final latestFile = File(
      p.join(backupDirectory.path, _automaticBackupLatestFileName),
    );
    await latestFile.writeAsString(contents, flush: true);

    final historyFile = File(
      p.join(
        backupDirectory.path,
        '$_automaticBackupPrefix-${_timestamp(_nowProvider())}.json',
      ),
    );
    await historyFile.writeAsString(contents, flush: true);

    await _trimAutomaticBackupHistory(backupDirectory);
    return latestFile;
  }

  Future<void> restoreFromJsonString(String jsonString) async {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Varmuuskopion sisältö on virheellinen.');
    }

    final payload = BackupPayload.fromJson(decoded);

    await _database.raw.transaction((txn) async {
      await txn.delete(notesTable);
      await txn.delete(schedulersTable);
      await txn.delete(dependantTable);

      for (final row in payload.dependants) {
        await txn.insert(dependantTable, row);
      }
      for (final row in payload.notes) {
        await txn.insert(notesTable, row);
      }
      for (final row in payload.schedulers) {
        await txn.insert(schedulersTable, row);
      }
    });
  }

  Future<void> restoreFromFile(File file) async {
    final contents = await file.readAsString();
    await restoreFromJsonString(contents);
  }

  Map<String, dynamic> _normalizeRow(Map<String, Object?> row) {
    return row.map((key, value) => MapEntry(key, value));
  }

  Future<void> _trimAutomaticBackupHistory(Directory directory) async {
    final files = await directory
        .list()
        .where((entity) => entity is File)
        .cast<File>()
        .where(
          (file) =>
              p.basename(file.path).startsWith('$_automaticBackupPrefix-') &&
              p.basename(file.path) != _automaticBackupLatestFileName,
        )
        .toList();

    files.sort((a, b) => b.path.compareTo(a.path));

    for (final staleFile in files.skip(_maxAutomaticHistoryFiles)) {
      await staleFile.delete();
    }
  }

  String _timestamp(DateTime dateTime) {
    final value = dateTime.toUtc();

    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)}T${twoDigits(value.hour)}-${twoDigits(value.minute)}-${twoDigits(value.second)}Z';
  }
}
