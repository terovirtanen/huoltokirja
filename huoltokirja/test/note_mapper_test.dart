import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja/data/mappers/note_mapper.dart';
import 'package:huoltokirja/domain/models/note.dart';

void main() {
  const mapper = NoteMapper();

  test('maps service note row to ServiceNote', () {
    final date = DateTime(2026, 1, 10);
    final row = {
      'id': 1,
      'dependant_id': 10,
      'type': 'service',
      'title': 'Oil change',
      'body': 'Changed filter',
      'service_date': date.toIso8601String(),
      'inspector_name': 'Huoltaja',
      'estimated_counter': 130000,
      'price': 249.90,
      'approved': 0,
      'created_at': date.toIso8601String(),
      'updated_at': date.toIso8601String(),
    };

    final mapped = mapper.fromRow(row);

    expect(mapped, isA<ServiceNote>());
    expect((mapped as ServiceNote).estimatedCounter, 130000);
    expect(mapped.performerName, 'Huoltaja');
    expect(mapped.price, 249.90);
    expect(mapped.noteDate, date);
  });

  test('maps inspection note row to InspectionNote', () {
    final createdAt = DateTime(2026, 1, 10);
    final noteDate = DateTime(2026, 2, 5);
    final row = {
      'id': 2,
      'dependant_id': 10,
      'type': 'inspection',
      'title': 'Safety check',
      'body': 'All good',
      'service_date': noteDate.toIso8601String(),
      'inspector_name': 'Tarkastaja A',
      'estimated_counter': 555,
      'price': 89.50,
      'approved': 1,
      'created_at': createdAt.toIso8601String(),
      'updated_at': createdAt.toIso8601String(),
    };

    final mapped = mapper.fromRow(row);

    expect(mapped, isA<InspectionNote>());
    expect((mapped as InspectionNote).performerName, 'Tarkastaja A');
    expect(mapped.estimatedCounter, 555);
    expect(mapped.price, 89.50);
    expect(mapped.isApproved, isTrue);
    expect(mapped.noteDate, noteDate);
  });

  test('maps plain note row to PlainNote', () {
    final createdAt = DateTime(2026, 1, 10);
    final noteDate = DateTime(2026, 3, 1);
    final row = {
      'id': 3,
      'dependant_id': 10,
      'type': 'plain',
      'title': 'Reminder',
      'body': 'Just a normal note',
      'service_date': noteDate.toIso8601String(),
      'inspector_name': null,
      'estimated_counter': null,
      'created_at': createdAt.toIso8601String(),
      'updated_at': createdAt.toIso8601String(),
    };

    final mapped = mapper.fromRow(row);

    expect(mapped, isA<PlainNote>());
    expect(mapped.title, 'Reminder');
    expect(mapped.body, 'Just a normal note');
    expect(mapped.noteDate, noteDate);
  });
}
