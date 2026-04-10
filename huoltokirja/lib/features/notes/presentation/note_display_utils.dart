import '../../../domain/models/dependant.dart';
import '../../../domain/models/note.dart';
import '../../../l10n/app_localizations.dart';

List<NoteType> availableNoteTypesForDependantGroup(
  DependantGroup dependantGroup,
) {
  if (dependantGroup == DependantGroup.animal) {
    return const [NoteType.plain, NoteType.service];
  }

  return NoteType.values;
}

NoteType normalizeNoteTypeForDependantGroup(
  DependantGroup dependantGroup,
  NoteType noteType,
) {
  if (dependantGroup == DependantGroup.animal &&
      noteType == NoteType.inspection) {
    return NoteType.service;
  }

  return noteType;
}

bool shouldShowCounterField({
  required DependantGroup dependantGroup,
  required NoteType noteType,
}) {
  if (dependantGroup == DependantGroup.animal) {
    return false;
  }

  return noteType == NoteType.service || noteType == NoteType.inspection;
}

String serviceNoteLabelKey(DependantGroup dependantGroup) {
  return dependantGroup == DependantGroup.animal ? 'care' : 'service';
}

String localizedNoteTypeLabel(
  AppLocalizations l10n,
  NoteType noteType,
  DependantGroup dependantGroup,
) {
  return switch (noteType) {
    NoteType.plain => l10n.plainNote,
    NoteType.service =>
      dependantGroup == DependantGroup.animal
          ? l10n.careNote
          : l10n.serviceNote,
    NoteType.inspection => l10n.inspectionNote,
  };
}

String localizedServiceNoteSummary(
  AppLocalizations l10n, {
  required DependantGroup dependantGroup,
  required String date,
  required String details,
}) {
  if (dependantGroup == DependantGroup.animal) {
    return l10n.careNoteSummary(date, details);
  }

  return l10n.serviceNoteSummary(date, details);
}

bool hasMeaningfulNoteChanges(Note original, Note updated) {
  if (original.type != updated.type) {
    return true;
  }
  if (original.title.trim() != updated.title.trim()) {
    return true;
  }
  if (original.body.trim() != updated.body.trim()) {
    return true;
  }
  if (!_isSameDay(original.noteDate, updated.noteDate)) {
    return true;
  }
  if (original.estimatedCounter != updated.estimatedCounter) {
    return true;
  }
  if ((original.performerName ?? '').trim() !=
      (updated.performerName ?? '').trim()) {
    return true;
  }
  if (original.price != updated.price) {
    return true;
  }
  if (original.isApproved != updated.isApproved) {
    return true;
  }
  return false;
}

bool isPendingAutoCreatedPastNote(Note note, {DateTime? now}) {
  final reference = _dateOnly(now ?? DateTime.now());
  return note.isAutomaticallyCreated &&
      !note.isUserModified &&
      note.noteDate.isBefore(reference);
}

bool isPendingAutoCreatedCurrentOrFutureNote(Note note, {DateTime? now}) {
  final reference = _dateOnly(now ?? DateTime.now());
  return note.isAutomaticallyCreated &&
      !note.isUserModified &&
      !note.noteDate.isBefore(reference);
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
