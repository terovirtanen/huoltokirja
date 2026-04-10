import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/config/app_config.dart';
import 'schema.dart';

class AppDatabase {
  AppDatabase._(this.raw);

  final Database raw;

  static Future<AppDatabase> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, AppConfig.dbName);

    final db = await openDatabase(
      dbPath,
      version: AppConfig.dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, _) async {
        await db.execute(createDependantsTable);
        await db.execute(createNotesTable);
        await db.execute(createSchedulersTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2 && newVersion >= 2) {
          await db.execute('ALTER TABLE notes ADD COLUMN price REAL');
          await db.execute(
            'ALTER TABLE notes ADD COLUMN approved INTEGER NOT NULL DEFAULT 0',
          );
        }

        if (oldVersion < 3 && newVersion >= 3) {
          await db.execute(
            "ALTER TABLE dependants ADD COLUMN dependant_group TEXT NOT NULL DEFAULT 'none'",
          );
          await db.execute(
            'ALTER TABLE dependants ADD COLUMN initial_date TEXT',
          );
          await db.execute('ALTER TABLE dependants ADD COLUMN usage REAL');
          await db.execute(
            'UPDATE dependants SET initial_date = birth_date WHERE initial_date IS NULL AND birth_date IS NOT NULL',
          );

          await db.execute(
            "ALTER TABLE schedulers ADD COLUMN note_type TEXT NOT NULL DEFAULT 'plain'",
          );
          await db.execute('ALTER TABLE schedulers ADD COLUMN start_date TEXT');
          await db.execute(
            'ALTER TABLE schedulers ADD COLUMN calendar_interval_months INTEGER',
          );
          await db.execute(
            'ALTER TABLE schedulers ADD COLUMN usage_interval REAL',
          );
          await db.execute(
            'ALTER TABLE schedulers ADD COLUMN usage_start_value REAL',
          );
          await db.execute(
            'UPDATE schedulers SET start_date = COALESCE(last_completed_at, created_at) WHERE start_date IS NULL',
          );
          await db.execute('''
            UPDATE schedulers
            SET calendar_interval_months = CASE
              WHEN interval_days >= 330 THEN 12
              WHEN interval_days >= 150 THEN 6
              WHEN interval_days >= 75 THEN 3
              WHEN interval_days > 0 THEN 1
              ELSE NULL
            END
            WHERE calendar_interval_months IS NULL
            ''');
        }

        if (oldVersion < 4 && newVersion >= 4) {
          await db.execute('ALTER TABLE dependants ADD COLUMN tag TEXT');
        }
      },
    );

    return AppDatabase._(db);
  }

  static Future<AppDatabase> openInMemory() async {
    final db = await openDatabase(
      inMemoryDatabasePath,
      version: AppConfig.dbVersion,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (database, _) async {
        await database.execute(createDependantsTable);
        await database.execute(createNotesTable);
        await database.execute(createSchedulersTable);
      },
    );

    return AppDatabase._(db);
  }

  Future<void> close() => raw.close();
}
