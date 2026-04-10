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
import 'data/services/scheduler_auto_trigger_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogging();
  final database = await AppDatabase.open();

  final dependantRepository = SqfliteDependantRepository(
    database,
    const DependantMapper(),
  );
  final noteRepository = SqfliteNoteRepository(database, const NoteMapper());
  final schedulerRepository = SqfliteSchedulerRepository(
    database,
    const SchedulerMapper(),
  );

  await ExampleDataSeeder(
    dependantRepository: dependantRepository,
    noteRepository: noteRepository,
    schedulerRepository: schedulerRepository,
  ).seedIfNeeded();

  await SchedulerAutoTriggerService(
    dependantRepository: dependantRepository,
    noteRepository: noteRepository,
    schedulerRepository: schedulerRepository,
  ).triggerDueNotes();

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
      child: const HuoltokirjaApp(),
    ),
  );
}
