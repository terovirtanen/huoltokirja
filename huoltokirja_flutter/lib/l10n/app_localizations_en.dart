// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Maintenance Log';

  @override
  String get loading => 'Loading...';

  @override
  String errorPrefix(Object error) {
    return 'Error: $error';
  }

  @override
  String get retry => 'Try again';

  @override
  String get dependantsEmptyTitle => 'No targets yet';

  @override
  String get dependantsEmptySubtitle => 'Add your first target to get started.';

  @override
  String get addDependant => 'Add target';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get dependantDeleted => 'Target deleted';

  @override
  String get dependantDetails => 'Target details';

  @override
  String get noRelation => 'No relation';

  @override
  String relationLabel(Object relation) {
    return 'Relation: $relation';
  }

  @override
  String get notes => 'Notes';

  @override
  String get addNote => 'Add note';

  @override
  String get noNotes => 'No notes.';

  @override
  String get schedulers => 'Schedules';

  @override
  String get addScheduler => 'Add schedule';

  @override
  String get noSchedulers => 'No schedules.';

  @override
  String nextSchedule(Object date, Object overdue) {
    return 'Next: $date$overdue';
  }

  @override
  String get overdueSuffix => ' (overdue)';

  @override
  String get newDependant => 'New target';

  @override
  String get editDependant => 'Edit target';

  @override
  String get name => 'Name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get relationOptional => 'Relation (optional)';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get addNoteTitle => 'Add note';

  @override
  String get editNoteTitle => 'Edit note';

  @override
  String get serviceNote => 'Service note';

  @override
  String get inspectionNote => 'Inspection note';

  @override
  String get type => 'Type';

  @override
  String get title => 'Title';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get description => 'Description';

  @override
  String get serviceDate => 'Service date';

  @override
  String get counterEstimateOptional => 'Counter estimate (optional)';

  @override
  String get inspectorOptional => 'Inspector (optional)';

  @override
  String get noteSaved => 'Note saved';

  @override
  String get addSchedulerTitle => 'Add schedule';

  @override
  String get editSchedulerTitle => 'Edit schedule';

  @override
  String get intervalDays => 'Interval in days';

  @override
  String get nameMissing => 'Name is missing';

  @override
  String get intervalMustBePositive => 'Interval must be > 0';

  @override
  String get lastCompletedOptional => 'Last completed (optional)';

  @override
  String get notSet => 'Not set';

  @override
  String get schedulerSaved => 'Schedule saved';

  @override
  String serviceNoteSummary(Object date, Object counter) {
    return 'Service $date$counter';
  }

  @override
  String counterEstimateSuffix(Object counter) {
    return ' • Counter estimate: $counter';
  }

  @override
  String inspectionNoteSummary(Object inspector) {
    return 'Inspection$inspector';
  }

  @override
  String inspectorSuffix(Object name) {
    return ' ($name)';
  }

  @override
  String get notesPlaceholderTitle => 'Notes placeholder';

  @override
  String get notesPlaceholderSubtitle => 'This view has been replaced by a data-bound target-specific note flow.';

  @override
  String get schedulersPlaceholderTitle => 'Schedulers placeholder';

  @override
  String get schedulersPlaceholderSubtitle => 'This view has been replaced by a data-bound target-specific schedule flow.';

  @override
  String idLabel(Object id) {
    return 'ID: $id';
  }
}
