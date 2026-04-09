import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja_flutter/domain/models/dependant.dart';
import 'package:huoltokirja_flutter/domain/models/note.dart';
import 'package:huoltokirja_flutter/domain/models/scheduler.dart';
import 'package:huoltokirja_flutter/domain/services/counter_estimator.dart';
import 'package:huoltokirja_flutter/domain/services/dependant_tag_utils.dart';
import 'package:huoltokirja_flutter/features/notes/presentation/note_display_utils.dart';

void main() {
  test('estimateCounter keeps latest value when target is lower', () {
    final estimated = estimateCounter(
      latestCounter: 120000,
      targetCounter: 100000,
    );
    expect(estimated, 120000);
  });

  test('estimateDependantUsage uses note trend from the last year', () {
    final asOf = DateTime(2026, 4, 6);
    final dependant = Dependant(
      name: 'Test car',
      dependantGroup: DependantGroup.vehicle,
      initialDate: DateTime(2025, 4, 6),
      usage: 1000,
      createdAt: DateTime(2025, 4, 6),
      updatedAt: DateTime(2025, 4, 6),
    );

    final notes = <Note>[
      ServiceNote(
        dependantId: 1,
        title: 'Huolto',
        body: '',
        serviceDate: DateTime(2025, 10, 6),
        estimatedCounter: 1500,
        createdAt: DateTime(2025, 10, 6),
        updatedAt: DateTime(2025, 10, 6),
      ),
      InspectionNote(
        dependantId: 1,
        title: 'Tarkastus',
        body: '',
        noteDate: DateTime(2026, 4, 6),
        estimatedCounter: 2000,
        createdAt: DateTime(2026, 4, 6),
        updatedAt: DateTime(2026, 4, 6),
      ),
    ];

    final estimate = estimateDependantUsage(
      dependant: dependant,
      notes: notes,
      asOf: asOf,
    );

    expect(estimate, isNotNull);
    expect(estimate!.currentValue, closeTo(2000, 0.01));
    expect(estimate.dailyIncrease, greaterThan(0));
  });

  test(
    'animal note pages hide the counter field for service and inspection',
    () {
      expect(
        shouldShowCounterField(
          dependantGroup: DependantGroup.animal,
          noteType: NoteType.service,
        ),
        isFalse,
      );
      expect(
        shouldShowCounterField(
          dependantGroup: DependantGroup.animal,
          noteType: NoteType.inspection,
        ),
        isFalse,
      );
      expect(
        shouldShowCounterField(
          dependantGroup: DependantGroup.vehicle,
          noteType: NoteType.service,
        ),
        isTrue,
      );
    },
  );

  test('animal targets use care-note wording for service notes', () {
    expect(serviceNoteLabelKey(DependantGroup.animal), 'care');
    expect(serviceNoteLabelKey(DependantGroup.vehicle), 'service');
  });

  test('tag words are split by spaces and commas uniquely', () {
    expect(extractTagWords('kesä, vene trailer  vene'), [
      'kesä',
      'vene',
      'trailer',
    ]);
  });

  test('selected tags match dependant tag words', () {
    final dependant = Dependant(
      name: 'Test target',
      tag: 'kesä, vene trailer',
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

    expect(matchesSelectedTags(dependant, {'vene'}), isTrue);
    expect(matchesSelectedTags(dependant, {'talvi'}), isFalse);
    expect(matchesSelectedTags(dependant, {}), isTrue);
  });

  test('scheduler supports calendar and usage rules', () {
    final scheduler = Scheduler(
      dependantId: 1,
      label: 'Annual check',
      noteType: NoteType.inspection,
      startDate: DateTime(2025, 1, 1),
      calendarIntervalMonths: 12,
      usageInterval: 5000,
      usageStartValue: 120000,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

    expect(
      scheduler.nextCalendarScheduleAt(referenceDate: DateTime(2025, 6, 1)),
      DateTime(2026, 1, 1),
    );
    expect(scheduler.nextUsageThreshold, 125000);
  });
}
