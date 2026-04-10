import '../services/counter_estimator.dart';
import 'note.dart';

class Scheduler {
  const Scheduler({
    this.id,
    required this.dependantId,
    required this.label,
    required this.noteType,
    required this.startDate,
    this.calendarIntervalMonths,
    this.usageInterval,
    this.usageStartValue,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int dependantId;
  final String label;
  final NoteType noteType;
  final DateTime startDate;
  final int? calendarIntervalMonths;
  final double? usageInterval;
  final double? usageStartValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasCalendarRule =>
      calendarIntervalMonths != null && calendarIntervalMonths! > 0;

  bool get hasUsageRule =>
      usageInterval != null && usageInterval! > 0 && usageStartValue != null;

  double? get nextUsageThreshold =>
      hasUsageRule ? usageStartValue! + usageInterval! : null;

  double? nextUsageThresholdForEstimate(UsageEstimate? usageEstimate) {
    if (usageEstimate == null) {
      return nextUsageThreshold;
    }

    return _nextUsageThresholdForEstimate(
      currentValue: usageEstimate.currentValue,
      usageStartValue: usageStartValue,
      usageInterval: usageInterval,
    );
  }

  String get autoTriggerKey {
    return [
      label.trim(),
      noteType.name,
      _dateOnly(startDate).toIso8601String(),
      calendarIntervalMonths?.toString() ?? '',
      _normalizeDouble(usageInterval),
      _normalizeDouble(usageStartValue),
    ].join('|');
  }

  DateTime? nextCalendarScheduleAt({DateTime? referenceDate}) {
    final intervalMonths = calendarIntervalMonths;
    if (intervalMonths == null || intervalMonths <= 0) {
      return null;
    }

    final reference = _dateOnly(referenceDate ?? DateTime.now());
    var next = _dateOnly(startDate);
    while (!next.isAfter(reference)) {
      next = _addMonths(next, intervalMonths);
    }
    return next;
  }

  DateTime? nextUsageScheduleAt({
    required UsageEstimate estimate,
    DateTime? referenceDate,
  }) {
    final threshold = nextUsageThresholdForEstimate(estimate);
    if (threshold == null) {
      return null;
    }

    final reference = _dateOnly(referenceDate ?? DateTime.now());
    if (estimate.currentValue >= threshold) {
      return reference;
    }
    if (estimate.dailyIncrease <= 0) {
      return null;
    }

    final remainingUsage = threshold - estimate.currentValue;
    final days = (remainingUsage / estimate.dailyIncrease).ceil();
    return reference.add(Duration(days: days < 0 ? 0 : days));
  }

  DateTime? nextScheduleAtForEstimate({
    UsageEstimate? usageEstimate,
    DateTime? referenceDate,
  }) {
    final reference = referenceDate ?? DateTime.now();
    final calendarNext = nextCalendarScheduleAt(referenceDate: reference);
    final usageNext = usageEstimate == null
        ? null
        : nextUsageScheduleAt(
            estimate: usageEstimate,
            referenceDate: reference,
          );
    final candidates = <DateTime>[];
    if (calendarNext != null) {
      candidates.add(calendarNext);
    }
    if (usageNext != null) {
      candidates.add(usageNext);
    }
    candidates.sort((a, b) => a.compareTo(b));

    if (candidates.isEmpty) {
      return null;
    }
    return candidates.first;
  }

  DateTime get nextScheduleAt =>
      nextScheduleAtForEstimate(referenceDate: DateTime.now()) ??
      _dateOnly(startDate);

  bool get isOverdue => nextScheduleAt.isBefore(_dateOnly(DateTime.now()));

  bool get isDueSoon {
    final days = nextScheduleAt.difference(_dateOnly(DateTime.now())).inDays;
    return days >= 0 && days <= 14;
  }

  bool get isDueTomorrow =>
      nextScheduleAt.difference(_dateOnly(DateTime.now())).inDays <= 1;

  Scheduler copyWith({
    int? id,
    int? dependantId,
    String? label,
    NoteType? noteType,
    DateTime? startDate,
    int? calendarIntervalMonths,
    bool clearCalendarIntervalMonths = false,
    double? usageInterval,
    bool clearUsageInterval = false,
    double? usageStartValue,
    bool clearUsageStartValue = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Scheduler(
      id: id ?? this.id,
      dependantId: dependantId ?? this.dependantId,
      label: label ?? this.label,
      noteType: noteType ?? this.noteType,
      startDate: startDate ?? this.startDate,
      calendarIntervalMonths: clearCalendarIntervalMonths
          ? null
          : calendarIntervalMonths ?? this.calendarIntervalMonths,
      usageInterval: clearUsageInterval
          ? null
          : usageInterval ?? this.usageInterval,
      usageStartValue: clearUsageStartValue
          ? null
          : usageStartValue ?? this.usageStartValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

double? _nextUsageThresholdForEstimate({
  required double currentValue,
  required double? usageStartValue,
  required double? usageInterval,
}) {
  if (usageStartValue == null || usageInterval == null || usageInterval <= 0) {
    return null;
  }

  final progress = (currentValue - usageStartValue) / usageInterval;
  final nextStep = (progress.floor() + 1).clamp(1, 1 << 30);
  return usageStartValue + (nextStep * usageInterval);
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

String _normalizeDouble(double? value) {
  if (value == null) return '';
  return value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(3);
}

DateTime _addMonths(DateTime value, int monthsToAdd) {
  final totalMonths = value.month - 1 + monthsToAdd;
  final year = value.year + (totalMonths ~/ 12);
  final month = (totalMonths % 12) + 1;
  final lastDayOfMonth = DateTime(year, month + 1, 0).day;
  return DateTime(
    year,
    month,
    value.day > lastDayOfMonth ? lastDayOfMonth : value.day,
  );
}
