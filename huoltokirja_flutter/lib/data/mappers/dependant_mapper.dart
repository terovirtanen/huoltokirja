import '../../domain/models/dependant.dart';

class DependantMapper {
  const DependantMapper();

  Dependant fromRow(Map<String, Object?> row) {
    return Dependant(
      id: row['id'] as int,
      name: row['name'] as String,
      birthDate: _parseDate(row['birth_date']),
      relation: row['relation'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, Object?> toRow(Dependant model) {
    return {
      'id': model.id,
      'name': model.name,
      'birth_date': model.birthDate?.toIso8601String(),
      'relation': model.relation,
      'created_at': model.createdAt.toIso8601String(),
      'updated_at': model.updatedAt.toIso8601String(),
    };
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.parse(value as String);
  }
}
