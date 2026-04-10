import '../../domain/models/scheduler.dart';
import '../../domain/repositories/scheduler_repository.dart';
import '../database/app_database.dart';
import '../database/schema.dart';
import '../mappers/scheduler_mapper.dart';

class SqfliteSchedulerRepository implements SchedulerRepository {
  SqfliteSchedulerRepository(this._database, this._mapper);

  final AppDatabase _database;
  final SchedulerMapper _mapper;

  @override
  Future<Scheduler> create(Scheduler scheduler) async {
    final now = DateTime.now();
    final toInsert = scheduler.copyWith(createdAt: now, updatedAt: now);
    final row = _mapper.toRow(toInsert)..remove('id');
    final id = await _database.raw.insert(schedulersTable, row);
    return toInsert.copyWith(id: id);
  }

  @override
  Future<void> delete(int id) async {
    await _database.raw.delete(
      schedulersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Scheduler?> getById(int id) async {
    final rows = await _database.raw.query(
      schedulersTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _mapper.fromRow(rows.first);
  }

  @override
  Future<List<Scheduler>> listByDependant(int dependantId) async {
    final rows = await _database.raw.query(
      schedulersTable,
      where: 'dependant_id = ?',
      whereArgs: [dependantId],
      orderBy: 'label ASC',
    );
    return rows.map(_mapper.fromRow).toList(growable: false);
  }

  @override
  Future<Scheduler> update(Scheduler scheduler) async {
    final updated = scheduler.copyWith(updatedAt: DateTime.now());
    final row = _mapper.toRow(updated)..remove('id');
    await _database.raw.update(
      schedulersTable,
      row,
      where: 'id = ?',
      whereArgs: [scheduler.id],
    );
    return updated;
  }
}
