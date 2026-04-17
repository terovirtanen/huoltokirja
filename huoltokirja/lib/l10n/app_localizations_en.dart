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
  String get menu => 'Menu';

  @override
  String get targetSortAction => 'Target sorting';

  @override
  String get targetSortLatestNote => 'Latest note';

  @override
  String get targetSortName => 'Name';

  @override
  String get backupMenuAction => 'Backups';

  @override
  String get backupMenuSubtitle => 'Manual export and restore';

  @override
  String get exportBackupAction => 'Export backup';

  @override
  String get exportBackupSubtitle => 'Save backup to a file';

  @override
  String get importBackupAction => 'Restore backup';

  @override
  String get importBackupSubtitle => 'Choose a backup file';

  @override
  String get backupRestoreConfirmBody =>
      'Current data will be replaced by the backup. Continue?';

  @override
  String get backupRestoreNoBackupFound => 'No backup found';

  @override
  String get backupCloudSyncAction => 'Sync backup to cloud';

  @override
  String get backupCloudSyncEnabled => 'On';

  @override
  String get backupCloudSyncDisabled => 'Off';

  @override
  String get backupCloudFolderAction => 'Choose cloud folder';

  @override
  String get backupCloudFolderNotSet => 'Not set';

  @override
  String get exportCsvAction => 'Export data to CSV';

  @override
  String get exportCsvSubtitle => 'Export targets and notes into a table file';

  @override
  String get exportPdfAction => 'Create PDF report';

  @override
  String get exportPdfSubtitle => 'Generate and share a readable target report';

  @override
  String get changeLanguageAction => 'Change language';

  @override
  String get aboutAction => 'About';

  @override
  String get aboutSubtitle => 'Show software version and build date';

  @override
  String currentSelectionLabel(Object value) {
    return 'Current: $value';
  }

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get useDeviceLanguage => 'Use device language';

  @override
  String get finnishLanguage => 'Finnish';

  @override
  String get englishLanguage => 'English';

  @override
  String csvExportReady(Object fileName) {
    return 'CSV export ready: $fileName';
  }

  @override
  String pdfExportReady(Object fileName) {
    return 'PDF report ready: $fileName';
  }

  @override
  String backupExportReady(Object fileName) {
    return 'Backup ready: $fileName';
  }

  @override
  String backupSavedToDevice(Object fileName) {
    return 'Backup saved to device: $fileName';
  }

  @override
  String backupSavedToDeviceCloudSyncOnClose(Object fileName) {
    return 'Backup saved to device: $fileName. Cloud sync will run when the app closes.';
  }

  @override
  String backupSavedToDeviceCloudFolderMissing(Object fileName) {
    return 'Backup saved to device: $fileName. Choose a cloud folder to export the backup to the cloud.';
  }

  @override
  String backupCloudFolderSet(Object folderName) {
    return 'Cloud folder set: $folderName';
  }

  @override
  String backupCloudFolderSetFailed(Object error) {
    return 'Failed to set cloud folder: $error';
  }

  @override
  String get backupCloudFolderPickFileHint =>
      'Choose an existing backup file from the cloud folder you want to use.';

  @override
  String get backupRestoreSuccess => 'Backup restored';

  @override
  String get backupVersionPickerTitle => 'Choose backup version';

  @override
  String get backupSourceCloud => 'Cloud';

  @override
  String get backupSourceDevice => 'Device';

  @override
  String get cloudBackupFoundTitle => 'Cloud backup found';

  @override
  String get cloudBackupFoundBody =>
      'Restore the latest cloud backup to this installation?';

  @override
  String backupCloudSyncSuccess(Object fileName) {
    return 'Backup synced to cloud: $fileName';
  }

  @override
  String backupCloudSyncFailedLocalSaved(Object error) {
    return 'Cloud sync failed ($error), backup saved to device';
  }

  @override
  String get backupCloudSyncOn => 'Cloud sync enabled';

  @override
  String get backupCloudSyncOff => 'Cloud sync disabled';

  @override
  String versionValue(Object version) {
    return 'Version $version';
  }

  @override
  String buildDateValue(Object date) {
    return 'Build $date';
  }

  @override
  String exportFailed(Object error) {
    return 'Export failed: $error';
  }

  @override
  String backupRestoreFailed(Object error) {
    return 'Backup restore failed: $error';
  }

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
  String get group => 'Group';

  @override
  String get noGroup => 'No group';

  @override
  String get vehicleGroup => 'Vehicle';

  @override
  String get workMachineGroup => 'Work machine';

  @override
  String get deviceGroup => 'Device';

  @override
  String get animalGroup => 'Animal';

  @override
  String get noRelation => 'No relation';

  @override
  String relationLabel(Object relation) {
    return 'Relation: $relation';
  }

  @override
  String get notes => 'Notes';

  @override
  String get allNotesTitle => 'All notes';

  @override
  String get allNotesEmptyTitle => 'No notes yet';

  @override
  String get allNotesEmptySubtitle =>
      'When you add notes to targets, they will appear here.';

  @override
  String targetNameLabel(Object name) {
    return 'Target: $name';
  }

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
  String get dueSoonSuffix => ' (within 2 weeks)';

  @override
  String get dueTomorrowSuffix => ' (1 day or less)';

  @override
  String get newDependant => 'New target';

  @override
  String get editDependant => 'Edit target';

  @override
  String get name => 'Name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get tagOptional => 'Tags (optional)';

  @override
  String get filterTagsAction => 'Filter tags';

  @override
  String get filterTagsTitle => 'Select tags';

  @override
  String get noTagsAvailable => 'No tags yet.';

  @override
  String get showAllTargets => 'Clear filter';

  @override
  String get applyFilterAction => 'Filter';

  @override
  String get noMatchingTagsTitle => 'No matches for selected tags';

  @override
  String get noMatchingTagsSubtitle =>
      'Change the selected tags or show all targets.';

  @override
  String get relationOptional => 'Relation (optional)';

  @override
  String get commissioningDateOptional => 'Commissioning date (optional)';

  @override
  String get birthDateOptional => 'Birth date (optional)';

  @override
  String get odometerOptional => 'Odometer (optional)';

  @override
  String get operatingHoursOptional => 'Operating hours (optional)';

  @override
  String get invalidNumber => 'Enter a valid number';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String usageEstimateLine(Object value, Object unit) {
    return 'Estimated current reading: $value $unit';
  }

  @override
  String initialDateValue(Object label, Object date) {
    return '$label: $date';
  }

  @override
  String usageValueLabel(Object label, Object value, Object unit) {
    return '$label: $value $unit';
  }

  @override
  String get birthDateShort => 'Birth date';

  @override
  String get commissioningDateShort => 'Commissioned';

  @override
  String get odometerShort => 'Odometer';

  @override
  String get operatingHoursShort => 'Hours';

  @override
  String get addNoteTitle => 'Add note';

  @override
  String get editNoteTitle => 'Edit note';

  @override
  String get plainNote => 'Note';

  @override
  String get serviceNote => 'Service note';

  @override
  String get careNote => 'Care note';

  @override
  String get inspectionNote => 'Inspection note';

  @override
  String get type => 'Type';

  @override
  String get noteDate => 'Date';

  @override
  String get title => 'Title';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get description => 'Description';

  @override
  String get serviceDate => 'Service date';

  @override
  String get counterEstimateOptional => 'Meter reading (optional)';

  @override
  String get inspectorOptional => 'Performer (optional)';

  @override
  String get priceOptional => 'Price € (optional)';

  @override
  String get approvedLabel => 'Approved';

  @override
  String get performerLabel => 'Performer';

  @override
  String get priceLabel => 'Price';

  @override
  String get yesValue => 'Yes';

  @override
  String get noValue => 'No';

  @override
  String get noteSaved => 'Note saved';

  @override
  String get addSchedulerTitle => 'Add schedule';

  @override
  String get editSchedulerTitle => 'Edit schedule';

  @override
  String get scheduleStartDate => 'Schedule start date';

  @override
  String get calendarRule => 'Calendar rule';

  @override
  String get noCalendarRule => 'No calendar rule';

  @override
  String get yearly => 'Yearly';

  @override
  String get semiAnnual => 'Semi-annually';

  @override
  String get quarterly => 'Quarterly';

  @override
  String get customMonths => 'Custom month interval';

  @override
  String get customMonthsLabel => 'Month interval';

  @override
  String everyNMonths(Object months) {
    return 'Every $months months';
  }

  @override
  String get monthsMustBePositive => 'Month interval must be > 0';

  @override
  String get usageRule => 'Usage-based rule';

  @override
  String usageIntervalLabel(Object unit) {
    return 'Interval ($unit)';
  }

  @override
  String usageStartValueLabel(Object unit) {
    return 'Start value ($unit)';
  }

  @override
  String get scheduleRuleRequired => 'Select at least one schedule rule';

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
  String schedulerTypeLine(Object type) {
    return '$type';
  }

  @override
  String schedulerCalendarLine(Object interval) {
    return 'Calendar: $interval';
  }

  @override
  String schedulerUsageLine(Object value, Object unit) {
    return 'Usage threshold: $value $unit';
  }

  @override
  String plainNoteSummary(Object date, Object body) {
    return '$date$body';
  }

  @override
  String noteBodySuffix(Object body) {
    return ' • $body';
  }

  @override
  String serviceNoteSummary(Object date, Object counter) {
    return 'Service $date$counter';
  }

  @override
  String careNoteSummary(Object date, Object counter) {
    return 'Care $date$counter';
  }

  @override
  String get approvedSuffix => ' • approved';

  @override
  String inspectionNoteSummary(Object date, Object inspector) {
    return 'Inspection $date$inspector';
  }

  @override
  String get notesPlaceholderTitle => 'Notes placeholder';

  @override
  String get notesPlaceholderSubtitle =>
      'This view has been replaced by a data-bound target-specific note flow.';

  @override
  String get schedulersPlaceholderTitle => 'Schedulers placeholder';

  @override
  String get schedulersPlaceholderSubtitle =>
      'This view has been replaced by a data-bound target-specific schedule flow.';

  @override
  String idLabel(Object id) {
    return 'ID: $id';
  }
}
