import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja_flutter/data/database/app_database.dart';
import 'package:huoltokirja_flutter/data/mappers/dependant_mapper.dart';
import 'package:huoltokirja_flutter/data/mappers/note_mapper.dart';
import 'package:huoltokirja_flutter/data/mappers/scheduler_mapper.dart';
import 'package:huoltokirja_flutter/data/repositories/sqflite_dependant_repository.dart';
import 'package:huoltokirja_flutter/data/repositories/sqflite_note_repository.dart';
import 'package:huoltokirja_flutter/data/repositories/sqflite_scheduler_repository.dart';
import 'package:huoltokirja_flutter/domain/models/dependant.dart';
import 'package:huoltokirja_flutter/domain/models/note.dart';
import 'package:huoltokirja_flutter/domain/models/scheduler.dart';
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

  test('CRUD works for dependant, note and scheduler', () async {
    final createdDependant = await dependantRepo.create(
      Dependant(
        name: 'Test User',
        birthDate: null,
        relation: 'Child',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    expect(createdDependant.id, isNotNull);

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
        label: 'Weekly',
        intervalDays: 7,
        lastCompletedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

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
