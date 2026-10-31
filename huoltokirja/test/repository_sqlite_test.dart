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
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
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
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
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
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );
    final secondDependant = await dependantRepo.create(
      Dependant(
        name: 'Second target',
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );

    await noteRepo.create(
      PlainNote(
        dependantId: firstDependant.id!,
        title: 'Older note',
        body: '',
        noteDate: DateTime(2026, 1, 1),
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );
    await noteRepo.create(
      PlainNote(
        dependantId: secondDependant.id!,
        title: 'Newest note',
        body: '',
        noteDate: DateTime(2026, 2, 1),
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );

    final allNotes = await noteRepo.listAll();

    expect(allNotes, hasLength(2));
    expect(allNotes.first.title, 'Newest note');
    expect(allNotes.last.title, 'Older note');
  });

  test('auto trigger creates only one note per occurrence', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Due vehicle',
        dependantGroup: DependantGroup.vehicle,
        initialDate: DateTime(2024, 1, 1),
        usage: 12345,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );

    final scheduler = await schedulerRepo.create(
      Scheduler(
        dependantId: createdDependant.id!,
        label: 'Öljynvaihto',
        noteType: NoteType.service,
        startDate: DateTime(2025, 4, 20),
        calendarIntervalMonths: 12,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
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

  test(
    'auto trigger creates missed and upcoming monthly, semiannual, yearly notes',
    () async {
      final createdDependant = await dependantRepo.create(
        Dependant(
          name: 'Recurring schedule vehicle',
          dependantGroup: DependantGroup.vehicle,
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ),
      );
      await noteRepo.create(
        PlainNote(
          dependantId: createdDependant.id!,
          title: 'Alkumerkintä',
          body: '',
          noteDate: DateTime(2025, 1, 1),
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ),
      );
      final monthly = await schedulerRepo.create(
        Scheduler(
          dependantId: createdDependant.id!,
          label: 'Kuukausihuolto',
          noteType: NoteType.service,
          startDate: DateTime(2023, 1, 10),
          calendarIntervalMonths: 1,
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ),
      );
      final semiannual = await schedulerRepo.create(
        Scheduler(
          dependantId: createdDependant.id!,
          label: 'Puolivuosihuolto',
          noteType: NoteType.service,
          startDate: DateTime(2023, 6, 9),
          calendarIntervalMonths: 6,
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ),
      );
      final yearly = await schedulerRepo.create(
        Scheduler(
          dependantId: createdDependant.id!,
          label: 'Vuosihuolto',
          noteType: NoteType.service,
          startDate: DateTime(2023, 1, 8),
          calendarIntervalMonths: 12,
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ),
      );
      final triggerService = SchedulerAutoTriggerService(
        dependantRepository: dependantRepo,
        noteRepository: noteRepo,
        schedulerRepository: schedulerRepo,
      );

      expect(
        await triggerService.triggerForDependant(
          createdDependant.id!,
          asOf: DateTime(2025, 1, 1),
        ),
        3,
      );
      var scheduledNotes = (await noteRepo.listByDependant(
        createdDependant.id!,
      )).where((note) => note.schedulerId != null).toList();
      expect(scheduledNotes, hasLength(3));
      expect(scheduledNotes.map((note) => note.schedulerId).toSet(), {
        monthly.id,
        semiannual.id,
        yearly.id,
      });
      expect(scheduledNotes.map((note) => note.noteDate).toSet(), {
        DateTime(2025, 1, 10),
        DateTime(2024, 12, 9),
        DateTime(2025, 1, 8),
      });

      expect(
        await triggerService.triggerForDependant(
          createdDependant.id!,
          asOf: DateTime(2025, 1, 11),
        ),
        0,
      );
      scheduledNotes = (await noteRepo.listByDependant(
        createdDependant.id!,
      )).where((note) => note.schedulerId != null).toList();
      expect(scheduledNotes, hasLength(3));

      expect(
        await triggerService.triggerForDependant(
          createdDependant.id!,
          asOf: DateTime(2025, 6, 1),
        ),
        2,
      );
      scheduledNotes = (await noteRepo.listByDependant(
        createdDependant.id!,
      )).where((note) => note.schedulerId != null).toList();
      expect(scheduledNotes, hasLength(5));
      expect(
        scheduledNotes
            .where(
              (note) =>
                  note.noteDate == DateTime(2025, 6, 10) ||
                  note.noteDate == DateTime(2025, 6, 9),
            )
            .map((note) => note.schedulerId)
            .toSet(),
        {monthly.id, semiannual.id},
      );

      expect(
        await triggerService.triggerForDependant(
          createdDependant.id!,
          asOf: DateTime(2026, 1, 1),
        ),
        3,
      );
      scheduledNotes = (await noteRepo.listByDependant(
        createdDependant.id!,
      )).where((note) => note.schedulerId != null).toList();
      expect(scheduledNotes, hasLength(8));
      expect(
        scheduledNotes
            .where(
              (note) =>
                  note.noteDate == DateTime(2026, 1, 10) ||
                  note.noteDate == DateTime(2025, 12, 9) ||
                  note.noteDate == DateTime(2026, 1, 8),
            )
            .map((note) => note.schedulerId)
            .toSet(),
        {monthly.id, semiannual.id, yearly.id},
      );
    },
  );

  test(
    'triggering a newly saved scheduler creates its note for next week only',
    () async {
      final dependant = await dependantRepo.create(
        Dependant(
          name: 'Upcoming service vehicle',
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ),
      );
      final otherScheduler = await schedulerRepo.create(
        Scheduler(
          dependantId: dependant.id!,
          label: 'Muu ajastus',
          noteType: NoteType.service,
          startDate: DateTime(2025, 1, 5),
          calendarIntervalMonths: 12,
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ),
      );
      final newScheduler = await schedulerRepo.create(
        Scheduler(
          dependantId: dependant.id!,
          label: 'Ensi viikon huolto',
          noteType: NoteType.service,
          startDate: DateTime(2025, 1, 8),
          calendarIntervalMonths: 12,
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ),
      );
      final triggerService = SchedulerAutoTriggerService(
        dependantRepository: dependantRepo,
        noteRepository: noteRepo,
        schedulerRepository: schedulerRepo,
      );

      expect(
        await triggerService.triggerForScheduler(
          newScheduler.id!,
          asOf: DateTime(2025, 1, 1),
        ),
        1,
      );

      final notes = await noteRepo.listByDependant(dependant.id!);
      expect(notes, hasLength(1));
      expect(notes.single.schedulerId, newScheduler.id);
      expect(notes.single.schedulerId, isNot(otherScheduler.id));
      expect(notes.single.noteDate, DateTime(2025, 1, 8));
    },
  );

  test('yearly calendar scheduler creates a note for each year', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Calendar vehicle',
        dependantGroup: DependantGroup.vehicle,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );

    final scheduler = await schedulerRepo.create(
      Scheduler(
        dependantId: createdDependant.id!,
        label: 'Vuosihuolto',
        noteType: NoteType.service,
        startDate: DateTime(2025, 4, 20),
        calendarIntervalMonths: 12,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
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
    await triggerService.triggerForDependant(
      createdDependant.id!,
      asOf: DateTime(2026, 4, 10),
    );
    await triggerService.triggerForDependant(
      createdDependant.id!,
      asOf: DateTime(2027, 4, 10),
    );

    final notes = await noteRepo.listByDependant(createdDependant.id!);
    final schedulerNotes = notes
        .where((note) => note.schedulerId == scheduler.id)
        .toList();
    expect(schedulerNotes, hasLength(2));
    expect(
      schedulerNotes.map((note) => note.noteDate),
      containsAll([DateTime(2026, 4, 20), DateTime(2027, 4, 20)]),
    );
  });

  test(
    'calendar scheduler starting today creates its first note next year',
    () async {
      final createdDependant = await dependantRepo.create(
        Dependant(
          name: 'Today vehicle',
          dependantGroup: DependantGroup.vehicle,
          createdAt: DateTime(2026, 4, 10),
          updatedAt: DateTime(2026, 4, 10),
        ),
      );
      final scheduler = await schedulerRepo.create(
        Scheduler(
          dependantId: createdDependant.id!,
          label: 'Tämän päivän huolto',
          noteType: NoteType.service,
          startDate: DateTime(2026, 4, 10),
          calendarIntervalMonths: 12,
          createdAt: DateTime(2026, 4, 10),
          updatedAt: DateTime(2026, 4, 10),
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

      var notes = await noteRepo.listByDependant(createdDependant.id!);
      expect(notes, isEmpty);

      await triggerService.triggerForDependant(
        createdDependant.id!,
        asOf: DateTime(2027, 3, 27),
      );

      notes = await noteRepo.listByDependant(createdDependant.id!);
      expect(notes.single.schedulerId, scheduler.id);
      expect(notes.single.noteDate, DateTime(2027, 4, 10));
    },
  );

  test(
    'semiannual calendar scheduler creates a note every six months',
    () async {
      final createdDependant = await dependantRepo.create(
        Dependant(
          name: 'Semiannual vehicle',
          dependantGroup: DependantGroup.vehicle,
          createdAt: DateTime(2026, 4, 10),
          updatedAt: DateTime(2026, 4, 10),
        ),
      );
      final scheduler = await schedulerRepo.create(
        Scheduler(
          dependantId: createdDependant.id!,
          label: 'Puolivuosihuolto',
          noteType: NoteType.service,
          startDate: DateTime(2025, 10, 20),
          calendarIntervalMonths: 6,
          createdAt: DateTime(2026, 4, 10),
          updatedAt: DateTime(2026, 4, 10),
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
      await triggerService.triggerForDependant(
        createdDependant.id!,
        asOf: DateTime(2026, 10, 6),
      );

      final notes = await noteRepo.listByDependant(createdDependant.id!);
      final schedulerNotes = notes
          .where((note) => note.schedulerId == scheduler.id)
          .toList();
      expect(schedulerNotes, hasLength(2));
      expect(
        schedulerNotes.map((note) => note.noteDate),
        containsAll([DateTime(2026, 4, 20), DateTime(2026, 10, 20)]),
      );
    },
  );

  test('significant scheduler change resets untouched auto note', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Reset vehicle',
        dependantGroup: DependantGroup.vehicle,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );

    final originalScheduler = await schedulerRepo.create(
      Scheduler(
        dependantId: createdDependant.id!,
        label: 'Keväthuolto',
        noteType: NoteType.service,
        startDate: DateTime(2025, 4, 20),
        calendarIntervalMonths: 12,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
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
      originalScheduler.copyWith(startDate: DateTime(2025, 5, 20)),
    );

    await triggerService.triggerForDependant(
      createdDependant.id!,
      asOf: DateTime(2026, 5, 10),
    );

    final notes = await noteRepo.listByDependant(createdDependant.id!);

    expect(notes, hasLength(1));
    expect(notes.single.noteDate, DateTime(2026, 5, 20));
    expect(
      notes.single.schedulerTriggerKey,
      updatedScheduler.autoTriggerKeyFor(DateTime(2026, 5, 20)),
    );
  });

  test('stale untouched auto note stays when replacement is not due', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Seed vehicle',
        dependantGroup: DependantGroup.vehicle,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );

    await noteRepo.create(
      ServiceNote(
        dependantId: createdDependant.id!,
        title: 'Öljynvaihto',
        body: '',
        serviceDate: DateTime(2025, 4, 10),
        estimatedCounter: 210000,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );
    await noteRepo.create(
      ServiceNote(
        dependantId: createdDependant.id!,
        title: 'Jarrupalat',
        body: '',
        serviceDate: DateTime(2025, 11, 10),
        estimatedCounter: 220000,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );
    await noteRepo.create(
      ServiceNote(
        dependantId: createdDependant.id!,
        title: 'Ilmastoinnin huolto',
        body: '',
        serviceDate: DateTime(2026, 3, 10),
        estimatedCounter: 232000,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );

    final scheduler = await schedulerRepo.create(
      Scheduler(
        dependantId: createdDependant.id!,
        label: 'Öljynvaihto',
        noteType: NoteType.service,
        startDate: DateTime(2025, 6, 10),
        usageInterval: 50000,
        usageStartValue: 210000,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
      ),
    );

    await noteRepo.create(
      ServiceNote(
        dependantId: createdDependant.id!,
        schedulerId: scheduler.id,
        schedulerTriggerKey: '${scheduler.autoTriggerKey}|vanhentunut',
        isUserModified: false,
        title: 'Öljynvaihto',
        body: '',
        serviceDate: DateTime(2026, 2, 10),
        estimatedCounter: 226000,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
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

    final notes = await noteRepo.listByDependant(createdDependant.id!);
    final schedulerNotes = notes.where(
      (note) => note.schedulerId == scheduler.id,
    );

    expect(schedulerNotes, hasLength(1));
    expect(
      schedulerNotes.single.schedulerTriggerKey,
      isNot(scheduler.autoTriggerKey),
    );
    expect(schedulerNotes.single.isUserModified, isFalse);
  });

  test(
    'usage-only scheduler does not trigger without enough usage notes',
    () async {
      final createdDependant = await dependantRepo.create(
        Dependant(
          name: 'Loader',
          dependantGroup: DependantGroup.workMachine,
          initialDate: DateTime(2026, 1, 1),
          usage: 1000,
          createdAt: DateTime(2026, 4, 10),
          updatedAt: DateTime(2026, 4, 10),
        ),
      );

      await schedulerRepo.create(
        Scheduler(
          dependantId: createdDependant.id!,
          label: '250 h huolto',
          noteType: NoteType.service,
          startDate: DateTime(2026, 4, 1),
          usageInterval: 250,
          usageStartValue: 1000,
          createdAt: DateTime(2026, 4, 10),
          updatedAt: DateTime(2026, 4, 10),
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

      final notes = await noteRepo.listByDependant(createdDependant.id!);
      expect(notes, isEmpty);
    },
  );

  test('CRUD works for dependant, note and scheduler', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Test vehicle',
        dependantGroup: DependantGroup.vehicle,
        initialDate: DateTime(2024, 1, 1),
        usage: 12345,
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
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
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
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
        createdAt: DateTime(2026, 4, 10),
        updatedAt: DateTime(2026, 4, 10),
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
