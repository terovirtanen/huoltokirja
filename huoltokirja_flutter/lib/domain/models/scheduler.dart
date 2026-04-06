class Scheduler {
  const Scheduler({
    this.id,
    required this.dependantId,
    required this.label,
    required this.intervalDays,
    this.lastCompletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int dependantId;
  final String label;
  final int intervalDays;
  final DateTime? lastCompletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DateTime get nextScheduleAt {
    final anchor = lastCompletedAt ?? createdAt;
    return anchor.add(Duration(days: intervalDays));
  }

  bool get isOverdue => DateTime.now().isAfter(nextScheduleAt);

  Scheduler copyWith({
    int? id,
    int? dependantId,
    String? label,
    int? intervalDays,
    DateTime? lastCompletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Scheduler(
      id: id ?? this.id,
      dependantId: dependantId ?? this.dependantId,
      label: label ?? this.label,
      intervalDays: intervalDays ?? this.intervalDays,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
