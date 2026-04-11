import '../../domain/models/dependant.dart';

class DependantMapper {
  const DependantMapper();

  Dependant fromRow(Map<String, Object?> row) {
    return Dependant(
      id: row['id'] as int,
      name: row['name'] as String,
      dependantGroup: DependantGroup.fromStorage(row['dependant_group']),
      initialDate: _parseDate(row['initial_date'] ?? row['birth_date']),
      usage: _parseDouble(row['usage']),
      tag: (row['tag'] as String?)?.trim().isEmpty ?? true
          ? null
          : (row['tag'] as String).trim(),
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, Object?> toRow(Dependant model) {
    return {
      'id': model.id,
      'name': model.name,
      'dependant_group': model.dependantGroup.storageValue,
      'initial_date': model.initialDate?.toIso8601String(),
      'usage': model.usage,
      'tag': model.tag?.trim().isEmpty ?? true ? null : model.tag!.trim(),
      'created_at': model.createdAt.toIso8601String(),
      'updated_at': model.updatedAt.toIso8601String(),
    };
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.parse(value as String);
  }

  double? _parseDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
