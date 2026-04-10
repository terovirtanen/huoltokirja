import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja/data/database/app_database.dart';
import 'package:huoltokirja/data/mappers/dependant_mapper.dart';
import 'package:huoltokirja/data/mappers/note_mapper.dart';
import 'package:huoltokirja/data/mappers/scheduler_mapper.dart';
import 'package:huoltokirja/data/repositories/sqflite_dependant_repository.dart';
import 'package:huoltokirja/data/repositories/sqflite_note_repository.dart';
import 'package:huoltokirja/data/repositories/sqflite_scheduler_repository.dart';
import 'package:huoltokirja/data/services/scheduler_auto_trigger_service.dart';
import 'package:huoltokirja/domain/models/dependant.dart';
import 'package:huoltokirja/domain/models/note.dart';
import 'package:huoltokirja/domain/models/scheduler.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late AppDatabase db;
  late SqfliteDependantRepository dependantRepo;
  late SqfliteNoteRepository noteRepo;
  late SqfliteSchedulerRepository schedulerRepo;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await AppDatabase.openInMemory();
    dependantRepo = SqfliteDependantRepository(db, const DependantMapper());
    noteRepo = SqfliteNoteRepository(db, const NoteMapper());
    schedulerRepo = SqfliteSchedulerRepository(db, const SchedulerMapper());
  });

  tearDown(() async {
    await db.close();
  });

  test('target can be created without a group', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Test target',
        dependantGroup: DependantGroup.none,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final fetched = await dependantRepo.getById(createdDependant.id!);

    expect(fetched, isNotNull);
    expect(fetched!.dependantGroup, DependantGroup.none);
    expect(fetched.supportsUsage, isFalse);
  });

  test('dependant tag is stored and loaded', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Tagged target',
        tag: 'kesä, mökki',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final fetched = await dependantRepo.getById(createdDependant.id!);

    expect(fetched, isNotNull);
    expect(fetched!.tag, 'kesä, mökki');
  });

  test('listAll returns notes newest first across all targets', () async {
    final firstDependant = await dependantRepo.create(
      Dependant(
        name: 'First target',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    final secondDependant = await dependantRepo.create(
      Dependant(
        name: 'Second target',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    await noteRepo.create(
      PlainNote(
        dependantId: firstDependant.id!,
        title: 'Older note',
        body: '',
        noteDate: DateTime(2026, 1, 1),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    await noteRepo.create(
      PlainNote(
        dependantId: secondDependant.id!,
        title: 'Newest note',
        body: '',
        noteDate: DateTime(2026, 2, 1),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final allNotes = await noteRepo.listAll();

    expect(allNotes, hasLength(2));
    expect(allNotes.first.title, 'Newest note');
    expect(allNotes.last.title, 'Older note');
  });

  test('auto trigger creates only one note per scheduler', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Due vehicle',
        dependantGroup: DependantGroup.vehicle,
        initialDate: DateTime(2024, 1, 1),
        usage: 12345,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final scheduler = await schedulerRepo.create(
      Scheduler(
        dependantId: createdDependant.id!,
        label: 'Öljynvaihto',
        noteType: NoteType.service,
        startDate: DateTime(2026, 4, 20),
        calendarIntervalMonths: 12,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final triggerService = SchedulerAutoTriggerService(
      dependantRepository: dependantRepo,
      noteRepository: noteRepo,
      schedulerRepository: schedulerRepo,
    );

    await triggerService.triggerDueNotes(asOf: DateTime(2026, 4, 10));
    await triggerService.triggerDueNotes(asOf: DateTime(2026, 4, 10));

    final notes = await noteRepo.listByDependant(createdDependant.id!);

    expect(notes, hasLength(1));
    expect(notes.single.title, 'Öljynvaihto');
    expect(notes.single.schedulerId, scheduler.id);
    expect(notes.single.isUserModified, isFalse);
    expect(notes.single.noteDate, DateTime(2026, 4, 20));
  });

  test('significant scheduler change resets untouched auto note', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Reset vehicle',
        dependantGroup: DependantGroup.vehicle,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final originalScheduler = await schedulerRepo.create(
      Scheduler(
        dependantId: createdDependant.id!,
        label: 'Keväthuolto',
        noteType: NoteType.service,
        startDate: DateTime(2026, 4, 20),
        calendarIntervalMonths: 12,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final triggerService = SchedulerAutoTriggerService(
      dependantRepository: dependantRepo,
      noteRepository: noteRepo,
      schedulerRepository: schedulerRepo,
    );

    await triggerService.triggerForDependant(
      createdDependant.id!,
      asOf: DateTime(2026, 4, 10),
    );

    final updatedScheduler = await schedulerRepo.update(
      originalScheduler.copyWith(startDate: DateTime(2026, 5, 20)),
    );

    await triggerService.triggerForDependant(
      createdDependant.id!,
      asOf: DateTime(2026, 5, 10),
    );

    final notes = await noteRepo.listByDependant(createdDependant.id!);

    expect(notes, hasLength(1));
    expect(notes.single.noteDate, DateTime(2026, 5, 20));
    expect(notes.single.schedulerTriggerKey, updatedScheduler.autoTriggerKey);
  });

  test('CRUD works for dependant, note and scheduler', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Test vehicle',
        dependantGroup: DependantGroup.vehicle,
        initialDate: DateTime(2024, 1, 1),
        usage: 12345,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    expect(createdDependant.id, isNotNull);
    expect(createdDependant.dependantGroup, DependantGroup.vehicle);
    expect(createdDependant.usage, 12345);

    final noteDate = DateTime(2026, 4, 6);
    final note = await noteRepo.create(
      InspectionNote(
        dependantId: createdDependant.id!,
        title: 'Inspection note',
        body: 'Done',
        noteDate: noteDate,
        performerName: 'Tekijä Testi',
        estimatedCounter: 100,
        price: 59.90,
        isApproved: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    expect(note, isA<InspectionNote>());
    expect(note.noteDate, noteDate);
    expect((note as InspectionNote).performerName, 'Tekijä Testi');
    expect(note.price, 59.90);
    expect(note.isApproved, isTrue);

    final scheduler = await schedulerRepo.create(
      Scheduler(
        dependantId: createdDependant.id!,
        label: 'Inspection reminder',
        noteType: NoteType.inspection,
        startDate: DateTime(2026, 1, 1),
        calendarIntervalMonths: 12,
        usageInterval: 5000,
        usageStartValue: 12000,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    expect(scheduler.noteType, NoteType.inspection);
    expect(scheduler.calendarIntervalMonths, 12);
    expect(scheduler.usageStartValue, 12000);
    expect((await noteRepo.listByDependant(createdDependant.id!)).length, 1);
    expect(
      (await schedulerRepo.listByDependant(createdDependant.id!)).length,
      1,
    );

    await noteRepo.delete(note.id!);
    await schedulerRepo.delete(scheduler.id!);
    await dependantRepo.delete(createdDependant.id!);

    expect(await dependantRepo.getById(createdDependant.id!), isNull);
  });
}
