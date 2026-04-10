import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja/domain/models/dependant.dart';
import 'package:huoltokirja/domain/models/note.dart';
import 'package:huoltokirja/domain/models/scheduler.dart';
import 'package:huoltokirja/domain/services/counter_estimator.dart';
import 'package:huoltokirja/domain/services/dependant_tag_utils.dart';
import 'package:huoltokirja/features/notes/presentation/note_display_utils.dart';

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
    'usage estimate stays hidden when current reading is already higher',
    () {
      final dependant = Dependant(
        name: 'Truck',
        dependantGroup: DependantGroup.workMachine,
        usage: 2500,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
      final estimate = UsageEstimate(
        currentValue: 2400,
        dailyIncrease: 5,
        lastReadingDate: DateTime(2026, 1, 1),
      );

      expect(
        shouldShowUsageEstimate(dependant: dependant, estimate: estimate),
        isFalse,
      );
    },
  );

  test('latest usage reading comes from the newest note entry', () {
    final dependant = Dependant(
      name: 'Car',
      dependantGroup: DependantGroup.vehicle,
      initialDate: DateTime(2025, 1, 1),
      usage: 12000,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );
    final notes = <Note>[
      ServiceNote(
        dependantId: 1,
        title: 'Huolto',
        body: '',
        serviceDate: DateTime(2025, 6, 1),
        estimatedCounter: 15000,
        createdAt: DateTime(2025, 6, 1),
        updatedAt: DateTime(2025, 6, 1),
      ),
      InspectionNote(
        dependantId: 1,
        title: 'Tarkastus',
        body: '',
        noteDate: DateTime(2026, 3, 1),
        estimatedCounter: 18000,
        createdAt: DateTime(2026, 3, 1),
        updatedAt: DateTime(2026, 3, 1),
      ),
    ];

    expect(latestRecordedUsage(dependant: dependant, notes: notes), 18000);
  });

  test('usage scheduler finds the next matching threshold for estimate', () {
    final scheduler = Scheduler(
      dependantId: 1,
      label: '5000 km huolto',
      noteType: NoteType.service,
      startDate: DateTime(2026, 1, 1),
      usageInterval: 5000,
      usageStartValue: 12000,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

    final nextDate = scheduler.nextUsageScheduleAt(
      estimate: UsageEstimate(
        currentValue: 20000,
        dailyIncrease: 100,
        lastReadingDate: DateTime(2026, 4, 1),
      ),
      referenceDate: DateTime(2026, 4, 10),
    );

    expect(nextDate, DateTime(2026, 4, 30));
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

  test('scheduler-created past note stays pending until user changes it', () {
    final note = PlainNote(
      schedulerId: 42,
      dependantId: 1,
      title: 'Ajastettu note',
      body: '',
      noteDate: DateTime(2026, 4, 1),
      createdAt: DateTime(2026, 3, 20),
      updatedAt: DateTime(2026, 3, 20),
    );

    expect(
      isPendingAutoCreatedPastNote(note, now: DateTime(2026, 4, 10)),
      isTrue,
    );
    expect(
      isPendingAutoCreatedCurrentOrFutureNote(note, now: DateTime(2026, 3, 25)),
      isTrue,
    );
  });

  test('saving without real content changes does not mark note changed', () {
    final original = ServiceNote(
      schedulerId: 7,
      dependantId: 1,
      title: 'Öljynvaihto',
      body: '',
      serviceDate: DateTime(2026, 4, 20),
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 4, 10),
    );

    final unchanged = ServiceNote(
      schedulerId: 7,
      dependantId: 1,
      title: 'Öljynvaihto',
      body: '',
      serviceDate: DateTime(2026, 4, 20),
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 4, 10, 12),
    );

    final changed = ServiceNote(
      schedulerId: 7,
      dependantId: 1,
      title: 'Öljynvaihto',
      body: 'vaihdettu liikkeessä',
      serviceDate: DateTime(2026, 4, 20),
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 4, 10, 12),
    );

    expect(hasMeaningfulNoteChanges(original, unchanged), isFalse);
    expect(hasMeaningfulNoteChanges(original, changed), isTrue);
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

  test('usage threshold uses the first boundary above estimate', () {
    final scheduler = Scheduler(
      dependantId: 1,
      label: '5000 km huolto',
      noteType: NoteType.service,
      startDate: DateTime(2026, 1, 1),
      usageInterval: 5000,
      usageStartValue: 12000,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

    final threshold = scheduler.nextUsageThresholdForEstimate(
      UsageEstimate(
        currentValue: 20000,
        dailyIncrease: 50,
        lastReadingDate: DateTime(2026, 4, 1),
      ),
    );

    expect(threshold, 22000);
  });

  test('calendar rule starting today points to the next interval', () {
    final scheduler = Scheduler(
      dependantId: 1,
      label: 'Vuosihuolto',
      noteType: NoteType.service,
      startDate: DateTime(2026, 4, 10),
      calendarIntervalMonths: 12,
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 4, 10),
    );

    expect(
      scheduler.nextCalendarScheduleAt(referenceDate: DateTime(2026, 4, 10)),
      DateTime(2027, 4, 10),
    );
  });
}
