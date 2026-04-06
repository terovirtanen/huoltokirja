enum DependantGroup {
  none('none'),
  vehicle('vehicle'),
  workMachine('workMachine'),
  device('device'),
  animal('animal');

  const DependantGroup(this.storageValue);

  final String storageValue;

  bool get supportsUsage =>
      this == DependantGroup.vehicle || this == DependantGroup.workMachine;

  String? get usageUnit => switch (this) {
    DependantGroup.vehicle => 'km',
    DependantGroup.workMachine => 'h',
    DependantGroup.none ||
    DependantGroup.device ||
    DependantGroup.animal => null,
  };

  static DependantGroup fromStorage(Object? value) {
    final storageValue = value as String?;
    return DependantGroup.values.firstWhere(
      (group) => group.storageValue == storageValue,
      orElse: () => DependantGroup.none,
    );
  }
}

class Dependant {
  const Dependant({
    this.id,
    required this.name,
    this.dependantGroup = DependantGroup.none,
    this.initialDate,
    this.usage,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String name;
  final DependantGroup dependantGroup;
  final DateTime? initialDate;
  final double? usage;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get supportsUsage =>
      dependantGroup == DependantGroup.vehicle ||
      dependantGroup == DependantGroup.workMachine;

  String? get usageUnit => switch (dependantGroup) {
    DependantGroup.vehicle => 'km',
    DependantGroup.workMachine => 'h',
    DependantGroup.none ||
    DependantGroup.device ||
    DependantGroup.animal => null,
  };

  int? get ageYears {
    if (dependantGroup != DependantGroup.animal || initialDate == null) {
      return null;
    }

    final now = DateTime.now();
    var age = now.year - initialDate!.year;
    final hadBirthday =
        now.month > initialDate!.month ||
        (now.month == initialDate!.month && now.day >= initialDate!.day);
    if (!hadBirthday) {
      age -= 1;
    }
    return age;
  }

  String get listTitle => name;

  Dependant copyWith({
    int? id,
    String? name,
    DependantGroup? dependantGroup,
    DateTime? initialDate,
    bool clearInitialDate = false,
    double? usage,
    bool clearUsage = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Dependant(
      id: id ?? this.id,
      name: name ?? this.name,
      dependantGroup: dependantGroup ?? this.dependantGroup,
      initialDate: clearInitialDate ? null : initialDate ?? this.initialDate,
      usage: clearUsage ? null : usage ?? this.usage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
