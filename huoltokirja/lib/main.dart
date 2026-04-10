import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'core/logging/app_logger.dart';
import 'data/database/app_database.dart';
import 'data/mappers/dependant_mapper.dart';
import 'data/mappers/note_mapper.dart';
import 'data/mappers/scheduler_mapper.dart';
import 'data/repositories/sqflite_dependant_repository.dart';
import 'data/repositories/sqflite_note_repository.dart';
import 'data/repositories/sqflite_scheduler_repository.dart';
import 'data/services/example_data_seeder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogging();
  final database = await AppDatabase.open();

  await ExampleDataSeeder(
    dependantRepository: SqfliteDependantRepository(
      database,
      const DependantMapper(),
    ),
    noteRepository: SqfliteNoteRepository(database, const NoteMapper()),
    schedulerRepository: SqfliteSchedulerRepository(
      database,
      const SchedulerMapper(),
    ),
  ).seedIfNeeded();

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
      child: const HuoltokirjaApp(),
    ),
  );
}
