class Dependant {
  const Dependant({
    this.id,
    required this.name,
    this.birthDate,
    this.relation,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String name;
  final DateTime? birthDate;
  final String? relation;
  final DateTime createdAt;
  final DateTime updatedAt;

  int? get ageYears {
    if (birthDate == null) return null;
    final now = DateTime.now();
    var age = now.year - birthDate!.year;
    final hadBirthday =
        now.month > birthDate!.month ||
        (now.month == birthDate!.month && now.day >= birthDate!.day);
    if (!hadBirthday) {
      age -= 1;
    }
    return age;
  }

  String get listTitle {
    final relationText = relation == null || relation!.isEmpty
        ? ''
        : ' ($relation)';
    return '$name$relationText';
  }

  Dependant copyWith({
    int? id,
    String? name,
    DateTime? birthDate,
    String? relation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Dependant(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      relation: relation ?? this.relation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
