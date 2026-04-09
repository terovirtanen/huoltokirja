import '../../domain/models/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../database/app_database.dart';
import '../database/schema.dart';
import '../mappers/note_mapper.dart';

class SqfliteNoteRepository implements NoteRepository {
  SqfliteNoteRepository(this._database, this._mapper);

  final AppDatabase _database;
  final NoteMapper _mapper;

  @override
  Future<Note> create(Note note) async {
    final now = DateTime.now();
    final toInsert = switch (note) {
      PlainNote plain => PlainNote(
        id: plain.id,
        dependantId: plain.dependantId,
        title: plain.title,
        body: plain.body,
        noteDate: plain.noteDate,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceNote service => ServiceNote(
        id: service.id,
        dependantId: service.dependantId,
        title: service.title,
        body: service.body,
        serviceDate: service.serviceDate,
        estimatedCounter: service.estimatedCounter,
        performerName: service.performerName,
        price: service.price,
        createdAt: now,
        updatedAt: now,
      ),
      InspectionNote inspection => InspectionNote(
        id: inspection.id,
        dependantId: inspection.dependantId,
        title: inspection.title,
        body: inspection.body,
        noteDate: inspection.noteDate,
        estimatedCounter: inspection.estimatedCounter,
        performerName: inspection.performerName,
        price: inspection.price,
        isApproved: inspection.isApproved,
        createdAt: now,
        updatedAt: now,
      ),
    };

    final row = _mapper.toRow(toInsert)..remove('id');
    final id = await _database.raw.insert(notesTable, row);

    return switch (toInsert) {
      PlainNote plain => PlainNote(
        id: id,
        dependantId: plain.dependantId,
        title: plain.title,
        body: plain.body,
        noteDate: plain.noteDate,
        createdAt: plain.createdAt,
        updatedAt: plain.updatedAt,
      ),
      ServiceNote service => ServiceNote(
        id: id,
        dependantId: service.dependantId,
        title: service.title,
        body: service.body,
        serviceDate: service.serviceDate,
        estimatedCounter: service.estimatedCounter,
        performerName: service.performerName,
        price: service.price,
        createdAt: service.createdAt,
        updatedAt: service.updatedAt,
      ),
      InspectionNote inspection => InspectionNote(
        id: id,
        dependantId: inspection.dependantId,
        title: inspection.title,
        body: inspection.body,
        noteDate: inspection.noteDate,
        estimatedCounter: inspection.estimatedCounter,
        performerName: inspection.performerName,
        price: inspection.price,
        isApproved: inspection.isApproved,
        createdAt: inspection.createdAt,
        updatedAt: inspection.updatedAt,
      ),
    };
  }

  @override
  Future<void> delete(int id) async {
    await _database.raw.delete(notesTable, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<Note?> getById(int id) async {
    final rows = await _database.raw.query(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _mapper.fromRow(rows.first);
  }

  @override
  Future<List<Note>> listAll() async {
    final rows = await _database.raw.query(
      notesTable,
      orderBy: 'service_date DESC, created_at DESC',
    );
    return rows.map(_mapper.fromRow).toList(growable: false);
  }

  @override
  Future<List<Note>> listByDependant(int dependantId) async {
    final rows = await _database.raw.query(
      notesTable,
      where: 'dependant_id = ?',
      whereArgs: [dependantId],
      orderBy: 'service_date DESC, created_at DESC',
    );
    return rows.map(_mapper.fromRow).toList(growable: false);
  }

  @override
  Future<Note> update(Note note) async {
    final row = _mapper.toRow(switch (note) {
      PlainNote plain => PlainNote(
        id: plain.id,
        dependantId: plain.dependantId,
        title: plain.title,
        body: plain.body,
        noteDate: plain.noteDate,
        createdAt: plain.createdAt,
        updatedAt: DateTime.now(),
      ),
      ServiceNote service => ServiceNote(
        id: service.id,
        dependantId: service.dependantId,
        title: service.title,
        body: service.body,
        serviceDate: service.serviceDate,
        estimatedCounter: service.estimatedCounter,
        performerName: service.performerName,
        price: service.price,
        createdAt: service.createdAt,
        updatedAt: DateTime.now(),
      ),
      InspectionNote inspection => InspectionNote(
        id: inspection.id,
        dependantId: inspection.dependantId,
        title: inspection.title,
        body: inspection.body,
        noteDate: inspection.noteDate,
        estimatedCounter: inspection.estimatedCounter,
        performerName: inspection.performerName,
        price: inspection.price,
        isApproved: inspection.isApproved,
        createdAt: inspection.createdAt,
        updatedAt: DateTime.now(),
      ),
    })..remove('id');

    await _database.raw.update(
      notesTable,
      row,
      where: 'id = ?',
      whereArgs: [note.id],
    );

    final updated = await getById(note.id!);
    return updated!;
  }
}
