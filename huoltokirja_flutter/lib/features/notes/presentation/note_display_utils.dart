import '../../../domain/models/dependant.dart';
import '../../../domain/models/note.dart';
import '../../../l10n/app_localizations.dart';

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
    NoteType.service => dependantGroup == DependantGroup.animal
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
