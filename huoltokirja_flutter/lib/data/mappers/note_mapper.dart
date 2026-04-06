import '../../domain/models/note.dart';

class NoteMapper {
  const NoteMapper();

  Note fromRow(Map<String, Object?> row) {
    final type = row['type'] as String;
    final createdAt = DateTime.parse(row['created_at'] as String);
    final common = (
      id: row['id'] as int,
      dependantId: row['dependant_id'] as int,
      title: row['title'] as String,
      body: row['body'] as String,
      noteDate: DateTime.parse(
        (row['service_date'] as String?) ?? createdAt.toIso8601String(),
      ),
      performerName: row['inspector_name'] as String?,
      estimatedCounter: row['estimated_counter'] as int?,
      price: (row['price'] as num?)?.toDouble(),
      isApproved: (row['approved'] as int? ?? 0) == 1,
      createdAt: createdAt,
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );

    switch (type) {
      case 'plain':
        return PlainNote(
          id: common.id,
          dependantId: common.dependantId,
          title: common.title,
          body: common.body,
          noteDate: common.noteDate,
          createdAt: common.createdAt,
          updatedAt: common.updatedAt,
        );
      case 'service':
        return ServiceNote(
          id: common.id,
          dependantId: common.dependantId,
          title: common.title,
          body: common.body,
          serviceDate: common.noteDate,
          estimatedCounter: common.estimatedCounter,
          performerName: common.performerName,
          price: common.price,
          createdAt: common.createdAt,
          updatedAt: common.updatedAt,
        );
      case 'inspection':
        return InspectionNote(
          id: common.id,
          dependantId: common.dependantId,
          title: common.title,
          body: common.body,
          noteDate: common.noteDate,
          estimatedCounter: common.estimatedCounter,
          performerName: common.performerName,
          price: common.price,
          isApproved: common.isApproved,
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
      'service_date': note.noteDate.toIso8601String(),
      'inspector_name': note.performerName,
      'estimated_counter': note.estimatedCounter,
      'price': note.price,
      'approved': note.isApproved ? 1 : 0,
    };

    return switch (note) {
      PlainNote _ => {...base, 'type': 'plain'},
      ServiceNote service => {
        ...base,
        'type': 'service',
        'service_date': service.serviceDate.toIso8601String(),
      },
      InspectionNote inspection => {
        ...base,
        'type': 'inspection',
        'approved': inspection.isApproved ? 1 : 0,
      },
    };
  }
}
