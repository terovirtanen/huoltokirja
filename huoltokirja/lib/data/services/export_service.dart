import 'dart:io';

import 'package:flutter/material.dart' show Locale, MaterialLocalizations;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../domain/models/dependant.dart';
import '../../domain/models/note.dart';
import '../../domain/repositories/dependant_repository.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/services/dependant_tag_utils.dart';
import '../../l10n/app_localizations.dart';

class AppExportService {
  AppExportService({
    required DependantRepository dependantRepository,
    required NoteRepository noteRepository,
  }) : _dependantRepository = dependantRepository,
       _noteRepository = noteRepository;

  final DependantRepository _dependantRepository;
  final NoteRepository _noteRepository;

  Future<File> exportCsv({
    Set<String> selectedTags = const <String>{},
    String? localeName,
  }) async {
    final allDependants = await _dependantRepository.getAll();
    final dependants = filterDependantsForExport(
      dependants: allDependants,
      selectedTags: selectedTags,
    );
    final dependantIds = dependants
        .where((dependant) => dependant.id != null)
        .map((dependant) => dependant.id!)
        .toSet();
    final notes = (await _noteRepository.listAll())
        .where((note) => dependantIds.contains(note.dependantId))
        .toList(growable: false);
    final content = buildCsvContent(
      dependants: dependants,
      notes: notes,
      localeName: localeName,
    );

    return _writeFile(
      extension: 'csv',
      bytes: content.codeUnits,
      prefix: 'huoltokirja-vienti',
    );
  }

  Future<File> exportPdfReport({
    Set<String> selectedTags = const <String>{},
    AppLocalizations? l10n,
    MaterialLocalizations? materialLocalizations,
  }) async {
    final pdfL10n = l10n ?? lookupAppLocalizations(const Locale('fi'));
    final formatDate = buildPdfDateFormatter(
      materialLocalizations: materialLocalizations,
      localeName: pdfL10n.localeName,
    );
    final allDependants = await _dependantRepository.getAll();
    final dependants = filterDependantsForExport(
      dependants: allDependants,
      selectedTags: selectedTags,
    );
    final dependantIds = dependants
        .where((dependant) => dependant.id != null)
        .map((dependant) => dependant.id!)
        .toSet();
    final notes = filterNotesForPdfReport(
      (await _noteRepository.listAll())
          .where((note) => dependantIds.contains(note.dependantId))
          .toList(growable: false),
    );
    final pageTheme = await _buildPdfPageTheme();
    final notesByDependant = <int, List<Note>>{};

    for (final note in notes) {
      notesByDependant.putIfAbsent(note.dependantId, () => []).add(note);
    }
    for (final list in notesByDependant.values) {
      list.sort((a, b) {
        final dateComparison = b.noteDate.compareTo(a.noteDate);
        if (dateComparison != 0) {
          return dateComparison;
        }
        return b.createdAt.compareTo(a.createdAt);
      });
    }

    final document = pw.Document(theme: pageTheme.theme);
    document.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (_) => [
          pw.Header(level: 0, text: pdfL10n.appTitle),
          pw.SizedBox(height: 8),
          if (dependants.isEmpty)
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey50,
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(pdfL10n.noMatchingTagsTitle),
            )
          else
            ...dependants.expand(
              (dependant) => [
                _buildPdfDependantSection(
                  dependant: dependant,
                  notes: notesByDependant[dependant.id] ?? const <Note>[],
                  l10n: pdfL10n,
                  formatDate: formatDate,
                ),
                pw.SizedBox(height: 12),
              ],
            ),
        ],
      ),
    );

    return _writeFile(
      extension: 'pdf',
      bytes: await document.save(),
      prefix: 'huoltokirja-raportti',
    );
  }

  String buildCsvContent({
    required List<Dependant> dependants,
    required List<Note> notes,
    String? localeName,
  }) {
    final dependantsById = {
      for (final dependant in dependants)
        if (dependant.id != null) dependant.id!: dependant,
    };
    final sortedNotes = [...notes]
      ..sort((a, b) {
        final dateComparison = b.noteDate.compareTo(a.noteDate);
        if (dateComparison != 0) {
          return dateComparison;
        }
        return b.createdAt.compareTo(a.createdAt);
      });

    final dateFormat = DateFormat.yMd(localeName);

    final rows = <List<String>>[
      [
        'target_id',
        'target_name',
        'target_group',
        'note_date',
        'note_type',
        'title',
        'body',
        'performer',
        'estimated_counter',
        'price',
        'approved',
      ],
    ];

    if (sortedNotes.isEmpty) {
      for (final dependant in dependants) {
        rows.add([
          '${dependant.id ?? ''}',
          dependant.name,
          dependant.dependantGroup.storageValue,
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          '',
        ]);
      }
    } else {
      for (final note in sortedNotes) {
        final dependant = dependantsById[note.dependantId];
        rows.add([
          '${dependant?.id ?? note.dependantId}',
          dependant?.name ?? '',
          dependant?.dependantGroup.storageValue ?? '',
          dateFormat.format(note.noteDate),
          note.type.name,
          note.title,
          note.body,
          note.performerName ?? '',
          note.estimatedCounter?.toString() ?? '',
          note.price?.toStringAsFixed(2) ?? '',
          note.isApproved ? 'yes' : 'no',
        ]);
      }
    }

    return rows.map((row) => row.map(_escapeCsv).join(',')).join('\n');
  }

  String _escapeCsv(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  Future<File> _writeFile({
    required String extension,
    required List<int> bytes,
    required String prefix,
  }) async {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File(p.join(directory.path, '$prefix-$timestamp.$extension'));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

List<Dependant> filterDependantsForExport({
  required List<Dependant> dependants,
  Set<String> selectedTags = const <String>{},
}) {
  if (selectedTags.isEmpty) {
    return List<Dependant>.from(dependants, growable: false);
  }

  return dependants
      .where((dependant) => matchesSelectedTags(dependant, selectedTags))
      .toList(growable: false);
}

List<Note> filterNotesForPdfReport(List<Note> notes) {
  return notes
      .where((note) => !note.isAutomaticallyCreated || note.isUserModified)
      .toList(growable: false);
}

String Function(DateTime) buildPdfDateFormatter({
  MaterialLocalizations? materialLocalizations,
  String? localeName,
}) {
  final dateFormat = DateFormat.yMd(localeName);
  return (date) =>
      materialLocalizations?.formatShortDate(date) ?? dateFormat.format(date);
}

Future<pw.PageTheme> _buildPdfPageTheme() async {
  final baseFont = await PdfGoogleFonts.notoSansRegular();
  final boldFont = await PdfGoogleFonts.notoSansBold();
  final italicFont = await PdfGoogleFonts.notoSansItalic();
  final boldItalicFont = await PdfGoogleFonts.notoSansBoldItalic();

  return pw.PageTheme(
    margin: const pw.EdgeInsets.fromLTRB(28, 32, 28, 32),
    theme: pw.ThemeData.withFont(
      base: baseFont,
      bold: boldFont,
      italic: italicFont,
      boldItalic: boldItalicFont,
    ),
  );
}

String pdfNoteTypeLabel({
  required Note note,
  required DependantGroup dependantGroup,
  AppLocalizations? l10n,
}) {
  final pdfL10n = l10n ?? lookupAppLocalizations(const Locale('fi'));

  return switch (note.type) {
    NoteType.plain => pdfL10n.plainNote,
    NoteType.service =>
      dependantGroup == DependantGroup.animal
          ? pdfL10n.careNote
          : pdfL10n.serviceNote,
    NoteType.inspection => pdfL10n.inspectionNote,
  };
}

class PdfDetailLine {
  const PdfDetailLine(this.text, {this.isItalic = false});

  final String text;
  final bool isItalic;
}

String? buildPdfDependantDescription(Dependant dependant) {
  final description = dependant.description?.trim();
  if (description == null || description.isEmpty) {
    return null;
  }
  return description;
}

List<PdfDetailLine> buildPdfNoteDetails({
  required Note note,
  required DependantGroup dependantGroup,
  AppLocalizations? l10n,
  String Function(DateTime)? formatDate,
}) {
  final pdfL10n = l10n ?? lookupAppLocalizations(const Locale('fi'));
  final resolvedFormatDate =
      formatDate ?? buildPdfDateFormatter(localeName: pdfL10n.localeName);
  final details = <PdfDetailLine>[
    PdfDetailLine(resolvedFormatDate(note.noteDate)),
  ];

  if (note.performerName != null && note.performerName!.trim().isNotEmpty) {
    details.add(PdfDetailLine(note.performerName!.trim()));
  }
  if (note.price != null) {
    details.add(PdfDetailLine('${note.price!.toStringAsFixed(2)} €'));
  }
  if (note.type == NoteType.inspection) {
    details.add(
      PdfDetailLine(
        note.isApproved ? pdfL10n.approvedLabel : pdfL10n.rejectedLabel,
      ),
    );
  }

  final body = note.body.trim();
  if (body.isNotEmpty) {
    details.add(PdfDetailLine(body, isItalic: true));
  }

  return details;
}

pw.Widget _buildPdfDependantSection({
  required Dependant dependant,
  required List<Note> notes,
  required AppLocalizations l10n,
  required String Function(DateTime) formatDate,
}) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          border: pw.Border.all(color: PdfColors.blueGrey100),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              dependant.name,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            if (dependant.initialDate != null) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                '${_pdfDependantDateLabel(dependant, l10n)}: ${formatDate(dependant.initialDate!)}',
              ),
            ],
            if (buildPdfDependantDescription(dependant) != null) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                buildPdfDependantDescription(dependant)!,
                style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
      pw.SizedBox(height: 8),
      if (notes.isEmpty)
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey50,
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            l10n.noNotes,
            style: const pw.TextStyle(color: PdfColors.blueGrey700),
          ),
        )
      else
        ...notes.map(
          (note) => pw.Container(
            width: double.infinity,
            margin: const pw.EdgeInsets.only(bottom: 8),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey50,
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  note.title,
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                ...buildPdfNoteDetails(
                  note: note,
                  dependantGroup: dependant.dependantGroup,
                  l10n: l10n,
                  formatDate: formatDate,
                ).map(
                  (line) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 2),
                    child: pw.Text(
                      line.text,
                      style: line.isItalic
                          ? pw.TextStyle(fontStyle: pw.FontStyle.italic)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}

String _pdfDependantDateLabel(Dependant dependant, AppLocalizations l10n) {
  return dependant.dependantGroup == DependantGroup.animal
      ? l10n.birthDateShort
      : l10n.commissioningDateShort;
}
