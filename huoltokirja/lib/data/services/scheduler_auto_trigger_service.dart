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

  Future<int> triggerForScheduler(int schedulerId, {DateTime? asOf}) async {
    final scheduler = await schedulerRepository.getById(schedulerId);
    if (scheduler == null) {
      return 0;
    }
    return _triggerForDependant(
      dependantId: scheduler.dependantId,
      schedulerId: schedulerId,
      asOf: asOf,
    );
  }

  Future<int> _triggerForDependant({
    required int dependantId,
    int? schedulerId,
    DateTime? asOf,
  }) async {
    final dependant = await dependantRepository.getById(dependantId);
    if (dependant == null) {
      return 0;
    }

    final referenceDate = _dateOnly(asOf ?? DateTime.now());
    final triggerThreshold = referenceDate.add(triggerLeadTime);
    final notes = await noteRepository.listByDependant(dependantId);
    final allSchedulers = await schedulerRepository.listByDependant(
      dependantId,
    );
    final schedulers = schedulerId == null
        ? allSchedulers
        : allSchedulers.where((scheduler) => scheduler.id == schedulerId);
    final usageEstimate = estimateDependantUsage(
      dependant: dependant,
      notes: notes,
      asOf: referenceDate,
    );
    var createdCount = 0;

    for (final scheduler in schedulers) {
      final schedulerId = scheduler.id;
      if (schedulerId == null) {
        continue;
      }

      final schedulerNotes = notes
          .where((note) => note.schedulerId == schedulerId)
          .toList(growable: false);
      final nextScheduleAt = _nextScheduleToTrigger(
        scheduler: scheduler,
        usageEstimate: usageEstimate,
        referenceDate: referenceDate,
        triggerThreshold: triggerThreshold,
        existingNotes: schedulerNotes,
      );
      if (nextScheduleAt == null) {
        continue;
      }

      final triggerKey = scheduler.autoTriggerKeyFor(nextScheduleAt);
      final occurrenceAlreadyExists = schedulerNotes.any(
        (note) =>
            note.schedulerTriggerKey == triggerKey ||
            (note.schedulerTriggerKey == scheduler.autoTriggerKey &&
                _dateOnly(note.noteDate) == nextScheduleAt),
      );
      if (occurrenceAlreadyExists) {
        continue;
      }

      final staleNotes = schedulerNotes.where(
        (note) =>
            !note.isUserModified &&
            !_matchesSchedulerConfiguration(
              scheduler,
              note.schedulerTriggerKey,
            ),
      );
      for (final note in staleNotes) {
        if (note.id != null) {
          await noteRepository.delete(note.id!);
        }
      }

      await noteRepository.create(
        _buildTriggeredNote(
          scheduler: scheduler,
          noteDate: nextScheduleAt,
          createdAt: referenceDate,
        ),
      );
      createdCount += 1;
    }

    return createdCount;
  }

  DateTime? _nextScheduleToTrigger({
    required Scheduler scheduler,
    required UsageEstimate? usageEstimate,
    required DateTime referenceDate,
    required DateTime triggerThreshold,
    required List<Note> existingNotes,
  }) {
    final upcomingDates = <DateTime>[];
    final calendarDate = scheduler.nextCalendarScheduleAt(
      referenceDate: referenceDate,
    );
    if (calendarDate != null) {
      upcomingDates.add(calendarDate);
    }
    if (usageEstimate != null) {
      final usageDate = scheduler.nextUsageScheduleAt(
        estimate: usageEstimate,
        referenceDate: referenceDate,
      );
      if (usageDate != null) {
        upcomingDates.add(usageDate);
      }
    }
    upcomingDates.sort();
    for (final date in upcomingDates) {
      if (!date.isAfter(triggerThreshold)) {
        return date;
      }
    }

    final latestCalendarDate = scheduler.latestCalendarScheduleAt(
      referenceDate: referenceDate,
    );
    if (latestCalendarDate == null) {
      return null;
    }

    final hasLatestCalendarNote = existingNotes.any(
      (note) =>
          note.schedulerTriggerKey ==
              scheduler.autoTriggerKeyFor(latestCalendarDate) ||
          (note.schedulerTriggerKey == scheduler.autoTriggerKey &&
              _dateOnly(note.noteDate) == latestCalendarDate),
    );
    return hasLatestCalendarNote ? null : latestCalendarDate;
  }

  Note _buildTriggeredNote({
    required Scheduler scheduler,
    required DateTime noteDate,
    required DateTime createdAt,
  }) {
    return switch (scheduler.noteType) {
      NoteType.plain => PlainNote(
        schedulerId: scheduler.id,
        schedulerTriggerKey: scheduler.autoTriggerKeyFor(noteDate),
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
        schedulerTriggerKey: scheduler.autoTriggerKeyFor(noteDate),
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
        schedulerTriggerKey: scheduler.autoTriggerKeyFor(noteDate),
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

bool _matchesSchedulerConfiguration(Scheduler scheduler, String? triggerKey) {
  if (triggerKey == scheduler.autoTriggerKey) {
    return true;
  }
  return triggerKey?.startsWith('${scheduler.autoTriggerKey}|occurrence=') ??
      false;
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
