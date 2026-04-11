import '../../domain/models/dependant.dart';
import '../../domain/models/note.dart';
import '../../domain/models/scheduler.dart';
import '../../domain/repositories/dependant_repository.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/scheduler_repository.dart';
import '../services/backup_service.dart';

class BackupAwareDependantRepository implements DependantRepository {
  BackupAwareDependantRepository({
    required DependantRepository delegate,
    required AppBackupService backupService,
  }) : _delegate = delegate,
       _backupService = backupService;

  final DependantRepository _delegate;
  final AppBackupService _backupService;

  @override
  Future<Dependant> create(Dependant dependant) async {
    final created = await _delegate.create(dependant);
    _backupService.scheduleAutomaticBackup();
    return created;
  }

  @override
  Future<void> delete(int id) async {
    await _delegate.delete(id);
    _backupService.scheduleAutomaticBackup();
  }

  @override
  Future<List<Dependant>> getAll() => _delegate.getAll();

  @override
  Future<Dependant?> getById(int id) => _delegate.getById(id);

  @override
  Future<Dependant> update(Dependant dependant) async {
    final updated = await _delegate.update(dependant);
    _backupService.scheduleAutomaticBackup();
    return updated;
  }
}

class BackupAwareNoteRepository implements NoteRepository {
  BackupAwareNoteRepository({
    required NoteRepository delegate,
    required AppBackupService backupService,
  }) : _delegate = delegate,
       _backupService = backupService;

  final NoteRepository _delegate;
  final AppBackupService _backupService;

  @override
  Future<Note> create(Note note) async {
    final created = await _delegate.create(note);
    _backupService.scheduleAutomaticBackup();
    return created;
  }

  @override
  Future<void> delete(int id) async {
    await _delegate.delete(id);
    _backupService.scheduleAutomaticBackup();
  }

  @override
  Future<Note?> getById(int id) => _delegate.getById(id);

  @override
  Future<List<Note>> listAll() => _delegate.listAll();

  @override
  Future<List<Note>> listByDependant(int dependantId) =>
      _delegate.listByDependant(dependantId);

  @override
  Future<Note> update(Note note) async {
    final updated = await _delegate.update(note);
    _backupService.scheduleAutomaticBackup();
    return updated;
  }
}

class BackupAwareSchedulerRepository implements SchedulerRepository {
  BackupAwareSchedulerRepository({
    required SchedulerRepository delegate,
    required AppBackupService backupService,
  }) : _delegate = delegate,
       _backupService = backupService;

  final SchedulerRepository _delegate;
  final AppBackupService _backupService;

  @override
  Future<Scheduler> create(Scheduler scheduler) async {
    final created = await _delegate.create(scheduler);
    _backupService.scheduleAutomaticBackup();
    return created;
  }

  @override
  Future<void> delete(int id) async {
    await _delegate.delete(id);
    _backupService.scheduleAutomaticBackup();
  }

  @override
  Future<Scheduler?> getById(int id) => _delegate.getById(id);

  @override
  Future<List<Scheduler>> listByDependant(int dependantId) =>
      _delegate.listByDependant(dependantId);

  @override
  Future<Scheduler> update(Scheduler scheduler) async {
    final updated = await _delegate.update(scheduler);
    _backupService.scheduleAutomaticBackup();
    return updated;
  }
}
