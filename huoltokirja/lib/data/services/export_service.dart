import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/models/dependant.dart';
import '../../domain/models/note.dart';
import '../../domain/repositories/dependant_repository.dart';
import '../../domain/repositories/note_repository.dart';

class AppExportService {
  AppExportService({
    required DependantRepository dependantRepository,
    required NoteRepository noteRepository,
  }) : _dependantRepository = dependantRepository,
       _noteRepository = noteRepository;

  final DependantRepository _dependantRepository;
  final NoteRepository _noteRepository;

  Future<File> exportCsv() async {
    final dependants = await _dependantRepository.getAll();
    final notes = await _noteRepository.listAll();
    final content = buildCsvContent(dependants: dependants, notes: notes);

    return _writeFile(
      extension: 'csv',
      bytes: content.codeUnits,
      prefix: 'huoltokirja-vienti',
    );
  }

  Future<File> exportPdfReport() async {
    final dependants = await _dependantRepository.getAll();
    final notes = await _noteRepository.listAll();
    final dateFormat = DateFormat.yMd();
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

    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        build: (_) => [
          pw.Header(level: 0, text: 'Huoltokirja'),
          for (final dependant in dependants) ...[
            pw.Header(level: 1, text: dependant.name),
            pw.Text('Ryhmä: ${dependant.dependantGroup.storageValue}'),
            if (dependant.initialDate != null)
              pw.Text(
                'Päivämäärä: ${dateFormat.format(dependant.initialDate!)}',
              ),
            if (dependant.usage != null)
              pw.Text(
                'Lukema: ${dependant.usage} ${dependant.usageUnit ?? ''}',
              ),
            pw.SizedBox(height: 6),
            if ((notesByDependant[dependant.id] ?? const <Note>[]).isEmpty)
              pw.Text('Ei muistiinpanoja')
            else
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  for (final note in notesByDependant[dependant.id]!)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 6),
                      child: pw.Text(
                        '${dateFormat.format(note.noteDate)} • ${note.type.name} • ${note.title}${note.body.trim().isEmpty ? '' : ' — ${note.body.trim()}'}',
                      ),
                    ),
                ],
              ),
            pw.SizedBox(height: 12),
          ],
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
          DateFormat.yMd().format(note.noteDate),
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
