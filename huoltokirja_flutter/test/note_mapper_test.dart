import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja_flutter/data/mappers/note_mapper.dart';
import 'package:huoltokirja_flutter/domain/models/note.dart';

void main() {
  const mapper = NoteMapper();

  test('maps service note row to ServiceNote', () {
    final row = {
      'id': 1,
      'dependant_id': 10,
      'type': 'service',
      'title': 'Oil change',
      'body': 'Changed filter',
      'service_date': DateTime(2026, 1, 10).toIso8601String(),
      'inspector_name': null,
      'estimated_counter': 130000,
      'created_at': DateTime(2026, 1, 10).toIso8601String(),
      'updated_at': DateTime(2026, 1, 10).toIso8601String(),
    };

    final mapped = mapper.fromRow(row);

    expect(mapped, isA<ServiceNote>());
    expect((mapped as ServiceNote).estimatedCounter, 130000);
  });

  test('maps inspection note row to InspectionNote', () {
    final row = {
      'id': 2,
      'dependant_id': 10,
      'type': 'inspection',
      'title': 'Safety check',
      'body': 'All good',
      'service_date': null,
      'inspector_name': 'Inspector A',
      'estimated_counter': null,
      'created_at': DateTime(2026, 1, 10).toIso8601String(),
      'updated_at': DateTime(2026, 1, 10).toIso8601String(),
    };

    final mapped = mapper.fromRow(row);

    expect(mapped, isA<InspectionNote>());
    expect((mapped as InspectionNote).inspectorName, 'Inspector A');
  });
}
