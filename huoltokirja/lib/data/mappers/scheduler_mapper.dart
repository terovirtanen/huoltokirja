import '../../domain/models/note.dart';
import '../../domain/models/scheduler.dart';

class SchedulerMapper {
  const SchedulerMapper();

  Scheduler fromRow(Map<String, Object?> row) {
    final createdAt = DateTime.parse(row['created_at'] as String);

    return Scheduler(
      id: row['id'] as int,
      dependantId: row['dependant_id'] as int,
      label: row['label'] as String,
      noteType: _parseNoteType(row['note_type']),
      startDate:
          _parseDate(row['start_date']) ??
          _parseDate(row['last_completed_at']) ??
          createdAt,
      calendarIntervalMonths:
          _parseInt(row['calendar_interval_months']) ??
          _legacyIntervalToMonths(row['interval_days']),
      usageInterval: _parseDouble(row['usage_interval']),
      usageStartValue: _parseDouble(row['usage_start_value']),
      createdAt: createdAt,
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, Object?> toRow(Scheduler model) {
    return {
      'id': model.id,
      'dependant_id': model.dependantId,
      'label': model.label,
      'interval_days': model.calendarIntervalMonths == null
          ? 0
          : model.calendarIntervalMonths! * 30,
      'last_completed_at': model.startDate.toIso8601String(),
      'note_type': model.noteType.name,
      'start_date': model.startDate.toIso8601String(),
      'calendar_interval_months': model.calendarIntervalMonths,
      'usage_interval': model.usageInterval,
      'usage_start_value': model.usageStartValue,
      'created_at': model.createdAt.toIso8601String(),
      'updated_at': model.updatedAt.toIso8601String(),
    };
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.parse(value as String);
  }

  double? _parseDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  int? _parseInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  int? _legacyIntervalToMonths(Object? value) {
    final intervalDays = _parseInt(value);
    if (intervalDays == null || intervalDays <= 0) {
      return null;
    }
    if (intervalDays >= 330) return 12;
    if (intervalDays >= 150) return 6;
    if (intervalDays >= 75) return 3;
    return 1;
  }

  NoteType _parseNoteType(Object? value) {
    final rawValue = value as String?;
    return NoteType.values.firstWhere(
      (type) => type.name == rawValue,
      orElse: () => NoteType.plain,
    );
  }
}
