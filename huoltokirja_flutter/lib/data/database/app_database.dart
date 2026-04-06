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
          // Future migration placeholder.
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
