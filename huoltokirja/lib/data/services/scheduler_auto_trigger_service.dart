import '../../domain/models/note.dart';
import '../../domain/models/scheduler.dart';
import '../../domain/repositories/dependant_repository.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/scheduler_repository.dart';
import '../../domain/services/counter_estimator.dart';

class SchedulerAutoTriggerService {
  SchedulerAutoTriggerService({
    required this.dependantRepository,
    required this.noteRepository,
    required this.schedulerRepository,
  });

  static const triggerLeadTime = Duration(days: 14);

  final DependantRepository dependantRepository;
  final NoteRepository noteRepository;
  final SchedulerRepository schedulerRepository;

  Future<int> triggerDueNotes({DateTime? asOf}) async {
    final dependants = await dependantRepository.getAll();
    var createdCount = 0;

    for (final dependant in dependants) {
      final dependantId = dependant.id;
      if (dependantId == null) {
        continue;
      }
      createdCount += await _triggerForDependant(
        dependantId: dependantId,
        asOf: asOf,
      );
    }

    return createdCount;
  }

  Future<int> triggerForDependant(int dependantId, {DateTime? asOf}) {
    return _triggerForDependant(dependantId: dependantId, asOf: asOf);
  }

  Future<int> _triggerForDependant({
    required int dependantId,
    DateTime? asOf,
  }) async {
    final dependant = await dependantRepository.getById(dependantId);
    if (dependant == null) {
      return 0;
    }

    final referenceDate = _dateOnly(asOf ?? DateTime.now());
    final triggerThreshold = referenceDate.add(triggerLeadTime);
    final notes = await noteRepository.listByDependant(dependantId);
    final schedulers = await schedulerRepository.listByDependant(dependantId);
    final usageEstimate = estimateDependantUsage(
      dependant: dependant,
      notes: notes,
      asOf: referenceDate,
    );
    final existingSchedulerKeys = notes
        .where((note) => note.schedulerId != null)
        .map(
          (note) => _schedulerNoteKey(
            note.schedulerId!,
            note.schedulerTriggerKey ?? '',
          ),
        )
        .toSet();

    var createdCount = 0;

    for (final scheduler in schedulers) {
      final schedulerId = scheduler.id;
      if (schedulerId == null) {
        continue;
      }

      final triggerKey = scheduler.autoTriggerKey;
      final staleNotes = notes.where(
        (note) =>
            note.schedulerId == schedulerId &&
            !note.isUserModified &&
            note.schedulerTriggerKey != triggerKey,
      );

      for (final note in staleNotes) {
        if (note.id != null) {
          await noteRepository.delete(note.id!);
        }
        existingSchedulerKeys.remove(
          _schedulerNoteKey(schedulerId, note.schedulerTriggerKey ?? ''),
        );
      }

      if (existingSchedulerKeys.contains(
        _schedulerNoteKey(schedulerId, triggerKey),
      )) {
        continue;
      }

      final nextScheduleAt =
          scheduler.nextScheduleAtForEstimate(
            usageEstimate: usageEstimate,
            referenceDate: referenceDate,
          ) ??
          scheduler.startDate;
      if (nextScheduleAt.isAfter(triggerThreshold)) {
        continue;
      }

      await noteRepository.create(
        _buildTriggeredNote(
          scheduler: scheduler,
          noteDate: nextScheduleAt,
          createdAt: referenceDate,
        ),
      );
      existingSchedulerKeys.add(_schedulerNoteKey(schedulerId, triggerKey));
      createdCount += 1;
    }

    return createdCount;
  }

  Note _buildTriggeredNote({
    required Scheduler scheduler,
    required DateTime noteDate,
    required DateTime createdAt,
  }) {
    return switch (scheduler.noteType) {
      NoteType.plain => PlainNote(
        schedulerId: scheduler.id,
        schedulerTriggerKey: scheduler.autoTriggerKey,
        isUserModified: false,
        dependantId: scheduler.dependantId,
        title: scheduler.label,
        body: '',
        noteDate: noteDate,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      NoteType.service => ServiceNote(
        schedulerId: scheduler.id,
        schedulerTriggerKey: scheduler.autoTriggerKey,
        isUserModified: false,
        dependantId: scheduler.dependantId,
        title: scheduler.label,
        body: '',
        serviceDate: noteDate,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      NoteType.inspection => InspectionNote(
        schedulerId: scheduler.id,
        schedulerTriggerKey: scheduler.autoTriggerKey,
        isUserModified: false,
        dependantId: scheduler.dependantId,
        title: scheduler.label,
        body: '',
        noteDate: noteDate,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    };
  }
}

String _schedulerNoteKey(int schedulerId, String triggerKey) =>
    '$schedulerId|$triggerKey';

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
