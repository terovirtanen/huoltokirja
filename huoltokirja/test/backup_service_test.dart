import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja/data/database/app_database.dart';
import 'package:huoltokirja/data/mappers/dependant_mapper.dart';
import 'package:huoltokirja/data/mappers/note_mapper.dart';
import 'package:huoltokirja/data/mappers/scheduler_mapper.dart';
import 'package:huoltokirja/data/repositories/sqflite_dependant_repository.dart';
import 'package:huoltokirja/data/repositories/sqflite_note_repository.dart';
import 'package:huoltokirja/data/repositories/sqflite_scheduler_repository.dart';
import 'package:huoltokirja/data/services/backup_service.dart';
import 'package:huoltokirja/domain/models/dependant.dart';
import 'package:huoltokirja/domain/models/note.dart';
import 'package:huoltokirja/domain/models/scheduler.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late AppDatabase db;
  late SqfliteDependantRepository dependantRepo;
  late SqfliteNoteRepository noteRepo;
  late SqfliteSchedulerRepository schedulerRepo;
  late Directory tempDir;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await AppDatabase.openInMemory();
    dependantRepo = SqfliteDependantRepository(db, const DependantMapper());
    noteRepo = SqfliteNoteRepository(db, const NoteMapper());
    schedulerRepo = SqfliteSchedulerRepository(db, const SchedulerMapper());
    tempDir = await Directory.systemTemp.createTemp('huoltokirja-backup-test');
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  AppBackupService buildService() {
    return AppBackupService(
      database: db,
      automaticBackupDirectoryProvider: () async => tempDir,
      exportDirectoryProvider: () async => tempDir,
      nowProvider: () => DateTime(2026, 4, 11, 10, 30),
      automaticBackupDelay: const Duration(milliseconds: 1),
    );
  }

  test('backup payload contains dependants, notes and schedulers', () async {
    final dependant = await dependantRepo.create(
      Dependant(
        name: 'Toyota Corolla',
        dependantGroup: DependantGroup.vehicle,
        tag: 'autot',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await noteRepo.create(
      ServiceNote(
        dependantId: dependant.id!,
        title: 'Öljynvaihto',
        body: 'vaihdettu',
        serviceDate: DateTime(2026, 4, 10),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await schedulerRepo.create(
      Scheduler(
        dependantId: dependant.id!,
        label: 'Vuosihuolto',
        noteType: NoteType.service,
        startDate: DateTime(2026, 4, 10),
        calendarIntervalMonths: 12,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final service = buildService();
    final payload = await service.createBackupPayload();
    final json = service.encodeBackupPayload(payload);

    expect(payload.dependants, hasLength(1));
    expect(payload.notes, hasLength(1));
    expect(payload.schedulers, hasLength(1));
    expect(json, contains('Toyota Corolla'));
    expect(json, contains('Öljynvaihto'));
    expect(json, contains('Vuosihuolto'));
  });

  test('restore from backup replaces existing database contents', () async {
    final sourceService = buildService();
    final sourceDependant = await dependantRepo.create(
      Dependant(
        name: 'Musti',
        dependantGroup: DependantGroup.animal,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    await noteRepo.create(
      PlainNote(
        dependantId: sourceDependant.id!,
        title: 'Rokotus',
        body: 'vuosihuolto tehty',
        noteDate: DateTime(2026, 4, 11),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final json = sourceService.encodeBackupPayload(
      await sourceService.createBackupPayload(),
    );

    await dependantRepo.delete(sourceDependant.id!);
    await dependantRepo.create(
      Dependant(
        name: 'Vanha kohde',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await sourceService.restoreFromJsonString(json);

    final restoredDependants = await dependantRepo.getAll();
    final restoredNotes = await noteRepo.listAll();

    expect(restoredDependants.map((item) => item.name), ['Musti']);
    expect(restoredNotes.map((item) => item.title), ['Rokotus']);
  });

  test('automatic backup writes a json file', () async {
    final service = buildService();

    service.scheduleAutomaticBackup();
    final file = await service.flushPendingAutomaticBackup();

    expect(file, isNotNull);
    expect(await file!.exists(), isTrue);
    expect(await file.readAsString(), contains('schemaVersion'));
  });

  test('restore tolerates unknown columns and boolean values', () async {
    final dependant = await dependantRepo.create(
      Dependant(
        name: 'Valtti',
        dependantGroup: DependantGroup.vehicle,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await noteRepo.create(
      InspectionNote(
        dependantId: dependant.id!,
        title: 'Katsastus',
        body: '',
        noteDate: DateTime(2026, 4, 12),
        isApproved: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await schedulerRepo.create(
      Scheduler(
        dependantId: dependant.id!,
        label: 'Katsastus',
        noteType: NoteType.inspection,
        startDate: DateTime(2026, 4, 12),
        calendarIntervalMonths: 12,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final service = buildService();
    final payloadJson = jsonDecode(
      service.encodeBackupPayload(await service.createBackupPayload()),
    ) as Map<String, dynamic>;

    (payloadJson['dependants'] as List)
        .first['legacy_dependant_field'] = 'legacy';
    (payloadJson['notes'] as List).first['approved'] = true;
    (payloadJson['notes'] as List).first['legacy_note_field'] = 123;
    (payloadJson['schedulers'] as List).first['legacy_scheduler_field'] = true;

    await service.restoreFromJsonString(jsonEncode(payloadJson));

    final restoredDependants = await dependantRepo.getAll();
    final restoredNotes = await noteRepo.listAll();
    final restoredSchedulers = await schedulerRepo.listByDependant(
      dependant.id!,
    );

    expect(restoredDependants, hasLength(1));
    expect(restoredNotes, hasLength(1));
    expect(restoredSchedulers, hasLength(1));
  });
}
