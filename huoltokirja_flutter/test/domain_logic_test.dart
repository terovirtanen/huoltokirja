import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja_flutter/domain/models/scheduler.dart';
import 'package:huoltokirja_flutter/domain/services/counter_estimator.dart';

void main() {
  test('estimateCounter keeps latest value when target is lower', () {
    final estimated = estimateCounter(
      latestCounter: 120000,
      targetCounter: 100000,
    );
    expect(estimated, 120000);
  });

  test('scheduler nextScheduleAt is based on interval', () {
    final scheduler = Scheduler(
      dependantId: 1,
      label: 'Annual check',
      intervalDays: 365,
      lastCompletedAt: DateTime(2025, 1, 1),
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

    expect(scheduler.nextScheduleAt, DateTime(2026, 1, 1));
  });
}
