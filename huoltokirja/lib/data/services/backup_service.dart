import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/config/app_config.dart';
import '../database/app_database.dart';
import '../database/schema.dart';

typedef BackupDirectoryProvider = Future<Directory> Function();

enum BackupSource { device, cloud }

class BackupVersion {
  const BackupVersion({
    required this.file,
    required this.source,
    required this.modifiedAt,
  });

  final File file;
  final BackupSource source;
  final DateTime modifiedAt;

  String get fileName => p.basename(file.path);
}

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
  static const _cloudBackupPrefix = 'huoltokirja-cloud';
  static const _manualBackupPrefix = 'huoltokirja-backup';
  static const _maxAutomaticHistoryFiles = 10;
  static const _maxCloudHistoryFiles = 30;

  final AppDatabase _database;
  final BackupDirectoryProvider _automaticBackupDirectoryProvider;
  final BackupDirectoryProvider _exportDirectoryProvider;
  final DateTime Function() _nowProvider;
  final Duration automaticBackupDelay;

  Timer? _automaticBackupTimer;
  Future<File>? _automaticBackupInFlight;

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

  String buildManualBackupFileName() {
    return '$_manualBackupPrefix-${_timestamp(_nowProvider())}.json';
  }

  Future<File> exportBackupArchive() async {
    final directory = await _exportDirectoryProvider();
    final filePath = p.join(directory.path, buildManualBackupFileName());
    return exportBackupArchiveToPath(filePath);
  }

  Future<File> exportBackupArchiveToPath(String filePath) async {
    final payload = await createBackupPayload();
    final file = File(filePath);
    await file.parent.create(recursive: true);
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
    final inFlight = _automaticBackupInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final operation = _createAutomaticBackupInternal();
    _automaticBackupInFlight = operation;

    try {
      return await operation;
    } finally {
      _automaticBackupInFlight = null;
    }
  }

  Future<File?> getLatestAutomaticBackupFile() async {
    final rootDirectory = await _automaticBackupDirectoryProvider();
    final latestFile = File(
      p.join(
        rootDirectory.path,
        _automaticBackupFolderName,
        _automaticBackupLatestFileName,
      ),
    );

    if (await latestFile.exists()) {
      return latestFile;
    }

    return null;
  }

  Future<File?> syncLatestBackupToCloud({
    required bool enabled,
    required String? cloudDirectoryPath,
  }) async {
    if (!enabled || cloudDirectoryPath == null || cloudDirectoryPath.isEmpty) {
      return null;
    }

    final latest = await getLatestAutomaticBackupFile();
    if (latest == null) {
      return null;
    }

    final cloudDirectory = Directory(cloudDirectoryPath);
    await cloudDirectory.create(recursive: true);

    final cloudFile = File(
      p.join(
        cloudDirectory.path,
        '$_cloudBackupPrefix-${_timestamp(_nowProvider())}.json',
      ),
    );
    await latest.copy(cloudFile.path);

    await _trimBackupHistory(
      cloudDirectory,
      prefix: _cloudBackupPrefix,
      maxFiles: _maxCloudHistoryFiles,
    );

    return cloudFile;
  }

  Future<List<BackupVersion>> listRestorableBackups({
    String? cloudDirectoryPath,
  }) async {
    final versions = <BackupVersion>[];

    final rootDirectory = await _automaticBackupDirectoryProvider();
    final localDirectory = Directory(
      p.join(rootDirectory.path, _automaticBackupFolderName),
    );
    if (await localDirectory.exists()) {
      final localFiles = await _listVersionFiles(
        localDirectory,
        prefix: _automaticBackupPrefix,
      );
      for (final file in localFiles) {
        final stat = await file.stat();
        versions.add(
          BackupVersion(
            file: file,
            source: BackupSource.device,
            modifiedAt: stat.modified,
          ),
        );
      }
    }

    if (cloudDirectoryPath != null && cloudDirectoryPath.isNotEmpty) {
      final cloudDirectory = Directory(cloudDirectoryPath);
      if (await cloudDirectory.exists()) {
        final cloudFiles = await _listVersionFiles(
          cloudDirectory,
          prefix: _cloudBackupPrefix,
        );
        for (final file in cloudFiles) {
          final stat = await file.stat();
          versions.add(
            BackupVersion(
              file: file,
              source: BackupSource.cloud,
              modifiedAt: stat.modified,
            ),
          );
        }
      }
    }

    versions.sort((a, b) {
      final compareDate = b.modifiedAt.compareTo(a.modifiedAt);
      if (compareDate != 0) {
        return compareDate;
      }
      if (a.source != b.source) {
        return a.source == BackupSource.cloud ? -1 : 1;
      }
      return b.file.path.compareTo(a.file.path);
    });

    return versions;
  }

  Future<List<BackupVersion>> listCloudBackups({
    required String cloudDirectoryPath,
  }) async {
    final cloudDirectory = Directory(cloudDirectoryPath);
    if (!await cloudDirectory.exists()) {
      return const [];
    }

    final files = await _listVersionFiles(
      cloudDirectory,
      prefix: _cloudBackupPrefix,
    );
    final versions = <BackupVersion>[];
    for (final file in files) {
      final stat = await file.stat();
      versions.add(
        BackupVersion(
          file: file,
          source: BackupSource.cloud,
          modifiedAt: stat.modified,
        ),
      );
    }

    versions.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
    return versions;
  }

  Future<File> _createAutomaticBackupInternal() async {
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

    await _trimBackupHistory(
      backupDirectory,
      prefix: _automaticBackupPrefix,
      maxFiles: _maxAutomaticHistoryFiles,
    );
    return latestFile;
  }

  Future<List<File>> _listVersionFiles(
    Directory directory, {
    required String prefix,
  }) async {
    final files = await directory
        .list()
        .where((entity) => entity is File)
        .cast<File>()
        .where((file) => p.basename(file.path).startsWith('$prefix-'))
        .toList();

    files.sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  Future<void> restoreFromJsonString(String jsonString) async {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Varmuuskopion sisältö on virheellinen.');
    }

    final payload = BackupPayload.fromJson(decoded);

    await _database.raw.transaction((txn) async {
      final dependantColumns = await _readTableColumns(txn, dependantTable);
      final noteColumns = await _readTableColumns(txn, notesTable);
      final schedulerColumns = await _readTableColumns(txn, schedulersTable);

      await txn.delete(notesTable);
      await txn.delete(schedulersTable);
      await txn.delete(dependantTable);

      for (final row in payload.dependants) {
        await txn.insert(
          dependantTable,
          _sanitizeRowForInsert(
            row,
            allowedColumns: dependantColumns,
            tableName: dependantTable,
          ),
        );
      }
      for (final row in payload.notes) {
        await txn.insert(
          notesTable,
          _sanitizeRowForInsert(
            row,
            allowedColumns: noteColumns,
            tableName: notesTable,
          ),
        );
      }
      for (final row in payload.schedulers) {
        await txn.insert(
          schedulersTable,
          _sanitizeRowForInsert(
            row,
            allowedColumns: schedulerColumns,
            tableName: schedulersTable,
          ),
        );
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

  Future<Set<String>> _readTableColumns(dynamic txn, String table) async {
    final rows = await txn.rawQuery('PRAGMA table_info($table)');
    return rows
        .map((row) => row['name'])
        .whereType<String>()
        .toSet();
  }

  Map<String, Object?> _sanitizeRowForInsert(
    Map<String, dynamic> row, {
    required Set<String> allowedColumns,
    required String tableName,
  }) {
    final sanitized = <String, Object?>{};

    for (final entry in row.entries) {
      if (!allowedColumns.contains(entry.key)) {
        continue;
      }
      sanitized[entry.key] = _normalizeInsertValue(entry.value);
    }

    if (sanitized.isEmpty) {
      throw FormatException(
        'Varmuuskopion taulurivi "$tableName" ei sisällä tuettuja kenttiä.',
      );
    }

    return sanitized;
  }

  Object? _normalizeInsertValue(Object? value) {
    if (value == null || value is String || value is num) {
      return value;
    }

    if (value is bool) {
      return value ? 1 : 0;
    }

    throw FormatException('Varmuuskopio sisältää tukemattoman arvotyypin.');
  }

  Future<void> _trimBackupHistory(
    Directory directory, {
    required String prefix,
    required int maxFiles,
  }) async {
    final files = await _listVersionFiles(directory, prefix: prefix);
    for (final staleFile in files.skip(maxFiles)) {
      await staleFile.delete();
    }
  }

  String _timestamp(DateTime dateTime) {
    final value = dateTime.toUtc();

    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)}T${twoDigits(value.hour)}-${twoDigits(value.minute)}-${twoDigits(value.second)}Z';
  }
}
