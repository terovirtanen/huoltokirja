import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja/data/database/app_database.dart';
import 'package:huoltokirja/data/mappers/dependant_mapper.dart';
import 'package:huoltokirja/data/mappers/note_mapper.dart';
import 'package:huoltokirja/data/mappers/scheduler_mapper.dart';
import 'package:huoltokirja/data/repositories/sqflite_dependant_repository.dart';
import 'package:huoltokirja/data/repositories/sqflite_note_repository.dart';
import 'package:huoltokirja/data/repositories/sqflite_scheduler_repository.dart';
import 'package:huoltokirja/data/services/example_data_seeder.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    SharedPreferences.setMockInitialValues({});
    db = await AppDatabase.openInMemory();
    dependantRepo = SqfliteDependantRepository(db, const DependantMapper());
    noteRepo = SqfliteNoteRepository(db, const NoteMapper());
    schedulerRepo = SqfliteSchedulerRepository(db, const SchedulerMapper());
  });

  tearDown(() async {
    await db.close();
  });

  test('example data is seeded only once on first launch', () async {
    final seeder = ExampleDataSeeder(
      dependantRepository: dependantRepo,
      noteRepository: noteRepo,
      schedulerRepository: schedulerRepo,
    );

    await seeder.seedIfNeeded();
    await seeder.seedIfNeeded();

    final dependants = await dependantRepo.getAll();
    expect(dependants, hasLength(2));

    final toyota = dependants.firstWhere(
      (item) => item.name == 'Toyota Corolla',
    );
    final musti = dependants.firstWhere((item) => item.name == 'Musti');

    expect(toyota.tag, 'autot');
    expect(musti.tag, 'lemmikit');
    expect(await noteRepo.listByDependant(toyota.id!), hasLength(5));
    expect(await noteRepo.listByDependant(musti.id!), hasLength(1));
    expect(await schedulerRepo.listByDependant(musti.id!), hasLength(1));
  });
}
