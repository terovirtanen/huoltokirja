import '../../domain/models/dependant.dart';
import '../../domain/repositories/dependant_repository.dart';
import '../database/app_database.dart';
import '../database/schema.dart';
import '../mappers/dependant_mapper.dart';

class SqfliteDependantRepository implements DependantRepository {
  SqfliteDependantRepository(this._database, this._mapper);

  final AppDatabase _database;
  final DependantMapper _mapper;

  @override
  Future<Dependant> create(Dependant dependant) async {
    final now = DateTime.now();
    final toInsert = dependant.copyWith(createdAt: now, updatedAt: now);
    final row = _mapper.toRow(toInsert)..remove('id');
    final id = await _database.raw.insert(dependantTable, row);
    return toInsert.copyWith(id: id);
  }

  @override
  Future<void> delete(int id) async {
    await _database.raw.delete(
      dependantTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Dependant>> getAll() async {
    final rows = await _database.raw.query(dependantTable, orderBy: 'name ASC');
    return rows.map(_mapper.fromRow).toList(growable: false);
  }

  @override
  Future<Dependant?> getById(int id) async {
    final rows = await _database.raw.query(
      dependantTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _mapper.fromRow(rows.first);
  }

  @override
  Future<Dependant> update(Dependant dependant) async {
    final updated = dependant.copyWith(updatedAt: DateTime.now());
    final row = _mapper.toRow(updated)..remove('id');
    await _database.raw.update(
      dependantTable,
      row,
      where: 'id = ?',
      whereArgs: [dependant.id],
    );
    return updated;
  }
}
