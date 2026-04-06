import '../../domain/models/scheduler.dart';

class SchedulerMapper {
  const SchedulerMapper();

  Scheduler fromRow(Map<String, Object?> row) {
    return Scheduler(
      id: row['id'] as int,
      dependantId: row['dependant_id'] as int,
      label: row['label'] as String,
      intervalDays: row['interval_days'] as int,
      lastCompletedAt: _parseDate(row['last_completed_at']),
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, Object?> toRow(Scheduler model) {
    return {
      'id': model.id,
      'dependant_id': model.dependantId,
      'label': model.label,
      'interval_days': model.intervalDays,
      'last_completed_at': model.lastCompletedAt?.toIso8601String(),
      'created_at': model.createdAt.toIso8601String(),
      'updated_at': model.updatedAt.toIso8601String(),
    };
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.parse(value as String);
  }
}
