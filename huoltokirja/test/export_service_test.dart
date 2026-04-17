import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huoltokirja/data/services/export_service.dart';
import 'package:huoltokirja/domain/models/dependant.dart';
import 'package:huoltokirja/domain/models/note.dart';
import 'package:huoltokirja/l10n/app_localizations.dart';

void main() {
  final fi = lookupAppLocalizations(const Locale('fi'));
  final en = lookupAppLocalizations(const Locale('en'));

  test('pdf note details show plain values in the requested order', () {
    final note = InspectionNote(
      dependantId: 1,
      schedulerId: 42,
      isUserModified: false,
      title: 'Katsastus',
      body: 'Korjauskehotus poistettu',
      noteDate: DateTime(2026, 4, 10),
      estimatedCounter: 221000,
      performerName: 'Katsastaja Oy',
      price: 34,
      isApproved: true,
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 4, 10),
    );

    final details = buildPdfNoteDetails(
      note: note,
      dependantGroup: DependantGroup.vehicle,
      l10n: fi,
      formatDate: (_) => '10.4.2026',
    );

    expect(details.map((line) => line.text), [
      '10.4.2026',
      'Katsastaja Oy',
      '34.00 €',
      'Hyväksytty',
      'Korjauskehotus poistettu',
    ]);
    expect(details.last.isItalic, isTrue);
    expect(details.take(4).every((line) => !line.isItalic), isTrue);
    expect(
      details.map((line) => line.text).join('\n'),
      isNot(contains('Päivämäärä')),
    );
    expect(
      details.map((line) => line.text).join('\n'),
      isNot(contains('221000')),
    );
    expect(
      details.map((line) => line.text).join('\n'),
      isNot(contains('Luotu ajastuksesta')),
    );
  });

  test('pdf details use localized values without field names', () {
    final note = InspectionNote(
      dependantId: 1,
      title: 'Inspection',
      body: 'All good',
      noteDate: DateTime(2026, 4, 10),
      performerName: 'Inspector Inc',
      price: 49.9,
      isApproved: true,
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 4, 10),
    );

    final details = buildPdfNoteDetails(
      note: note,
      dependantGroup: DependantGroup.vehicle,
      l10n: en,
      formatDate: (_) => '4/10/2026',
    );

    expect(
      details.map((line) => line.text),
      containsAll([
        '4/10/2026',
        'Inspector Inc',
        '49.90 €',
        'Approved',
        'All good',
      ]),
    );
    expect(
      details.map((line) => line.text).join('\n'),
      isNot(contains('Date:')),
    );
    expect(
      details.map((line) => line.text).join('\n'),
      isNot(contains('Description:')),
    );
    expect(details.last.isItalic, isTrue);
  });

  test('rejected inspection uses rejected wording in pdf', () {
    final note = InspectionNote(
      dependantId: 1,
      title: 'Inspection',
      body: 'Needs fixes',
      noteDate: DateTime(2026, 4, 10),
      isApproved: false,
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 4, 10),
    );

    final details = buildPdfNoteDetails(
      note: note,
      dependantGroup: DependantGroup.vehicle,
      l10n: fi,
      formatDate: (_) => '10.4.2026',
    );

    expect(details.map((line) => line.text), contains('Hylätty'));
    expect(details.map((line) => line.text), isNot(contains('Ei')));
  });

  test('animal service note is labeled as care note in pdf', () {
    final note = ServiceNote(
      dependantId: 1,
      title: 'Eläinlääkärikäynti',
      body: 'rokotus',
      serviceDate: DateTime(2026, 4, 10),
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 4, 10),
    );

    expect(
      pdfNoteTypeLabel(
        note: note,
        dependantGroup: DependantGroup.animal,
        l10n: fi,
      ),
      'Hoitomuistiinpano',
    );
  });

  test('pdf dependant description is returned without label text', () {
    final dependant = Dependant(
      name: 'Toyota Corolla',
      dependantGroup: DependantGroup.vehicle,
      description: 'Huollettu vain merkkihuollossa',
      createdAt: DateTime(2026, 4, 10),
      updatedAt: DateTime(2026, 4, 10),
    );

    expect(
      buildPdfDependantDescription(dependant),
      'Huollettu vain merkkihuollossa',
    );
  });

  test('export filters dependants by selected tags', () {
    final now = DateTime(2026, 4, 10);
    final dependants = [
      Dependant(
        id: 1,
        name: 'Toyota Corolla',
        dependantGroup: DependantGroup.vehicle,
        tag: 'autot käyttöauto',
        createdAt: now,
        updatedAt: now,
      ),
      Dependant(
        id: 2,
        name: 'Musti',
        dependantGroup: DependantGroup.animal,
        tag: 'lemmikit rokotus',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final filtered = filterDependantsForExport(
      dependants: dependants,
      selectedTags: {'rokotus'},
    );

    expect(filtered.map((dependant) => dependant.name), ['Musti']);
  });

  test('pdf export excludes untouched automatically created notes', () {
    final now = DateTime(2026, 4, 10);
    final notes = [
      ServiceNote(
        dependantId: 1,
        schedulerId: 1,
        isUserModified: false,
        title: 'Automaattinen öljynvaihto',
        body: '',
        serviceDate: now,
        createdAt: now,
        updatedAt: now,
      ),
      ServiceNote(
        dependantId: 1,
        schedulerId: 2,
        isUserModified: true,
        title: 'Muokattu automaattinen huolto',
        body: 'käyttäjä päivitti tätä',
        serviceDate: now,
        createdAt: now,
        updatedAt: now,
      ),
      PlainNote(
        dependantId: 1,
        title: 'Tavallinen muistiinpano',
        body: 'oma teksti',
        noteDate: now,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final filtered = filterNotesForPdfReport(notes);

    expect(filtered.map((note) => note.title), [
      'Muokattu automaattinen huolto',
      'Tavallinen muistiinpano',
    ]);
  });
}
