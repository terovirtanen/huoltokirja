import '../../domain/models/note.dart';

class NoteMapper {
  const NoteMapper();

  Note fromRow(Map<String, Object?> row) {
    final type = row['type'] as String;
    final common = (
      id: row['id'] as int,
      dependantId: row['dependant_id'] as int,
      title: row['title'] as String,
      body: row['body'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );

    switch (type) {
      case 'service':
        return ServiceNote(
          id: common.id,
          dependantId: common.dependantId,
          title: common.title,
          body: common.body,
          serviceDate: DateTime.parse(row['service_date'] as String),
          estimatedCounter: row['estimated_counter'] as int?,
          createdAt: common.createdAt,
          updatedAt: common.updatedAt,
        );
      case 'inspection':
        return InspectionNote(
          id: common.id,
          dependantId: common.dependantId,
          title: common.title,
          body: common.body,
          inspectorName: row['inspector_name'] as String?,
          createdAt: common.createdAt,
          updatedAt: common.updatedAt,
        );
      default:
        throw ArgumentError('Unknown note type: $type');
    }
  }

  Map<String, Object?> toRow(Note note) {
    final base = <String, Object?>{
      'id': note.id,
      'dependant_id': note.dependantId,
      'title': note.title,
      'body': note.body,
      'created_at': note.createdAt.toIso8601String(),
      'updated_at': note.updatedAt.toIso8601String(),
      'service_date': null,
      'inspector_name': null,
      'estimated_counter': null,
    };

    return switch (note) {
      ServiceNote service => {
        ...base,
        'type': 'service',
        'service_date': service.serviceDate.toIso8601String(),
        'estimated_counter': service.estimatedCounter,
      },
      InspectionNote inspection => {
        ...base,
        'type': 'inspection',
        'inspector_name': inspection.inspectorName,
      },
    };
  }
}
