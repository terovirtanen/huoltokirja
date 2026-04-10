import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/dependant.dart';
import '../../domain/models/note.dart';
import '../../domain/models/scheduler.dart';
import '../../domain/repositories/dependant_repository.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/scheduler_repository.dart';

class ExampleDataSeeder {
  ExampleDataSeeder({
    required this.dependantRepository,
    required this.noteRepository,
    required this.schedulerRepository,
    SharedPreferences? preferences,
    DateTime Function()? now,
  }) : _preferences = preferences,
       _now = now ?? DateTime.now;

  static const seededPreferenceKey = 'example_data_seeded';

  final DependantRepository dependantRepository;
  final NoteRepository noteRepository;
  final SchedulerRepository schedulerRepository;
  SharedPreferences? _preferences;
  final DateTime Function() _now;

  Future<void> seedIfNeeded() async {
    final preferences = await _getPreferences();
    if (preferences.getBool(seededPreferenceKey) ?? false) {
      return;
    }

    final existingDependants = await dependantRepository.getAll();
    if (existingDependants.isNotEmpty) {
      await preferences.setBool(seededPreferenceKey, true);
      return;
    }

    await _seedExampleData();
    await preferences.setBool(seededPreferenceKey, true);
  }

  Future<void> _seedExampleData() async {
    final now = _dateOnly(_now());

    final toyota = await dependantRepository.create(
      Dependant(
        name: 'Toyota Corolla',
        dependantGroup: DependantGroup.vehicle,
        tag: 'autot käyttöauto',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await noteRepository.create(
      ServiceNote(
        dependantId: toyota.id!,
        title: 'Öljynvaihto',
        body: '',
        serviceDate: _subtractYears(now, 1),
        estimatedCounter: 210000,
        performerName: 'Korjaamo Oy',
        price: 69,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await noteRepository.create(
      ServiceNote(
        dependantId: toyota.id!,
        title: 'Jarrupalat',
        body: '',
        serviceDate: _subtractMonths(now, 5),
        estimatedCounter: 220000,
        performerName: 'Korjaamo Oy',
        price: 169,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await noteRepository.create(
      ServiceNote(
        dependantId: toyota.id!,
        title: 'Öljynvaihto',
        body: '',
        serviceDate: _subtractMonths(now, 1),
        estimatedCounter: 232000,
        performerName: 'Korjaamo Oy',
        price: 69,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await noteRepository.create(
      InspectionNote(
        dependantId: toyota.id!,
        title: 'Katsastus',
        body: '',
        noteDate: _subtractDays(_subtractMonths(now, 5), 14),
        estimatedCounter: 219000,
        performerName: 'Katsastaja Oy',
        price: 74,
        isApproved: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await noteRepository.create(
      InspectionNote(
        dependantId: toyota.id!,
        title: 'Uusinta katsastus',
        body: '',
        noteDate: _subtractDays(_subtractMonths(now, 4), 21),
        estimatedCounter: 221000,
        performerName: 'Katsastaja Oy',
        price: 34,
        isApproved: true,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await schedulerRepository.create(
      Scheduler(
        dependantId: toyota.id!,
        label: 'Katsastus',
        noteType: NoteType.inspection,
        startDate: _subtractYears(now, 1),
        calendarIntervalMonths: 12,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await schedulerRepository.create(
      Scheduler(
        dependantId: toyota.id!,
        label: 'Öljynvaihto',
        noteType: NoteType.service,
        startDate: _subtractYears(now, 1),
        usageInterval: 20000,
        usageStartValue: 190000,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final musti = await dependantRepository.create(
      Dependant(
        name: 'Musti',
        dependantGroup: DependantGroup.animal,
        initialDate: _subtractYears(now, 3),
        tag: 'lemmikit rokotus',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await noteRepository.create(
      ServiceNote(
        dependantId: musti.id!,
        title: 'Eläinlääkärikäynti',
        body: 'rokotus',
        serviceDate: _subtractYears(now, 1),
        performerName: 'Leevi Eläinhoitaja',
        price: 25,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await schedulerRepository.create(
      Scheduler(
        dependantId: musti.id!,
        label: 'Eläinlääkäri',
        noteType: NoteType.service,
        startDate: _subtractYears(now, 1),
        calendarIntervalMonths: 12,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<SharedPreferences> _getPreferences() async {
    return _preferences ??= await SharedPreferences.getInstance();
  }
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime _subtractDays(DateTime value, int days) =>
    value.subtract(Duration(days: days));

DateTime _subtractYears(DateTime value, int years) {
  final year = value.year - years;
  final lastDayOfMonth = DateTime(year, value.month + 1, 0).day;
  return DateTime(
    year,
    value.month,
    value.day > lastDayOfMonth ? lastDayOfMonth : value.day,
  );
}

DateTime _subtractMonths(DateTime value, int monthsToSubtract) {
  final totalMonths = value.year * 12 + value.month - 1 - monthsToSubtract;
  final year = totalMonths ~/ 12;
  final month = (totalMonths % 12) + 1;
  final lastDayOfMonth = DateTime(year, month + 1, 0).day;

  return DateTime(
    year,
    month,
    value.day > lastDayOfMonth ? lastDayOfMonth : value.day,
  );
}
