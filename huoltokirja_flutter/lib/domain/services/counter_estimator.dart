import '../models/dependant.dart';
import '../models/note.dart';

int estimateCounter({required int latestCounter, int? targetCounter}) {
  if (targetCounter == null) return latestCounter;
  return targetCounter < latestCounter ? latestCounter : targetCounter;
}

class UsageEstimate {
  const UsageEstimate({
    required this.currentValue,
    required this.dailyIncrease,
    required this.lastReadingDate,
  });

  final double currentValue;
  final double dailyIncrease;
  final DateTime lastReadingDate;
}

class _UsagePoint {
  const _UsagePoint({required this.date, required this.value});

  final DateTime date;
  final double value;
}

UsageEstimate? estimateDependantUsage({
  required Dependant dependant,
  required List<Note> notes,
  DateTime? asOf,
}) {
  if (!dependant.supportsUsage) {
    return null;
  }

  final referenceDate = DateTime(
    (asOf ?? DateTime.now()).year,
    (asOf ?? DateTime.now()).month,
    (asOf ?? DateTime.now()).day,
  );

  final points = <_UsagePoint>[
    if (dependant.initialDate != null && dependant.usage != null)
      _UsagePoint(date: dependant.initialDate!, value: dependant.usage!),
    ...notes
        .where((note) => note.estimatedCounter != null)
        .map(
          (note) => _UsagePoint(
            date: note.noteDate,
            value: note.estimatedCounter!.toDouble(),
          ),
        ),
  ]..sort((a, b) => a.date.compareTo(b.date));

  if (points.length < 2) {
    return null;
  }

  final cutoffDate = referenceDate.subtract(const Duration(days: 365));
  final lastYearPoints = points
      .where((point) => !point.date.isBefore(cutoffDate))
      .toList(growable: false);
  final selectedPoints = lastYearPoints.length >= 2
      ? lastYearPoints
      : points.sublist(points.length - 2);

  final first = selectedPoints.first;
  final last = selectedPoints.last;
  final daySpan = last.date.difference(first.date).inDays;
  if (daySpan <= 0) {
    return UsageEstimate(
      currentValue: last.value,
      dailyIncrease: 0,
      lastReadingDate: last.date,
    );
  }

  final dailyIncrease = (last.value - first.value) / daySpan;
  final clampedDailyIncrease = dailyIncrease < 0 ? 0.0 : dailyIncrease;
  final projectionDays = referenceDate.difference(last.date).inDays;
  final projectedValue = projectionDays <= 0
      ? last.value
      : last.value + (clampedDailyIncrease * projectionDays);

  return UsageEstimate(
    currentValue: projectedValue < last.value ? last.value : projectedValue,
    dailyIncrease: clampedDailyIncrease,
    lastReadingDate: last.date,
  );
}
