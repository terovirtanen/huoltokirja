import '../models/note.dart';

abstract class NoteRepository {
  Future<List<Note>> listByDependant(int dependantId);
  Future<Note?> getById(int id);
  Future<Note> create(Note note);
  Future<Note> update(Note note);
  Future<void> delete(int id);
}
