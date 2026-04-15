import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Log'**
  String get appTitle;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @targetSortAction.
  ///
  /// In en, this message translates to:
  /// **'Target sorting'**
  String get targetSortAction;

  /// No description provided for @targetSortLatestNote.
  ///
  /// In en, this message translates to:
  /// **'Latest note'**
  String get targetSortLatestNote;

  /// No description provided for @targetSortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get targetSortName;

  /// No description provided for @exportBackupAction.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackupAction;

  /// No description provided for @exportBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a JSON backup for iCloud or Jottacloud'**
  String get exportBackupSubtitle;

  /// No description provided for @importBackupAction.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get importBackupAction;

  /// No description provided for @importBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import a previously exported backup file'**
  String get importBackupSubtitle;

  /// No description provided for @exportCsvAction.
  ///
  /// In en, this message translates to:
  /// **'Export data to CSV'**
  String get exportCsvAction;

  /// No description provided for @exportCsvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export targets and notes into a table file'**
  String get exportCsvSubtitle;

  /// No description provided for @exportPdfAction.
  ///
  /// In en, this message translates to:
  /// **'Create PDF report'**
  String get exportPdfAction;

  /// No description provided for @exportPdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate and share a readable target report'**
  String get exportPdfSubtitle;

  /// No description provided for @changeLanguageAction.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguageAction;

  /// No description provided for @aboutAction.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutAction;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show software version and build date'**
  String get aboutSubtitle;

  /// No description provided for @currentSelectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Current: {value}'**
  String currentSelectionLabel(Object value);

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @useDeviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get useDeviceLanguage;

  /// No description provided for @finnishLanguage.
  ///
  /// In en, this message translates to:
  /// **'Finnish'**
  String get finnishLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @csvExportReady.
  ///
  /// In en, this message translates to:
  /// **'CSV export ready: {fileName}'**
  String csvExportReady(Object fileName);

  /// No description provided for @pdfExportReady.
  ///
  /// In en, this message translates to:
  /// **'PDF report ready: {fileName}'**
  String pdfExportReady(Object fileName);

  /// No description provided for @backupExportReady.
  ///
  /// In en, this message translates to:
  /// **'Backup ready: {fileName}'**
  String backupExportReady(Object fileName);

  /// No description provided for @backupRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupRestoreSuccess;

  /// No description provided for @versionValue.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionValue(Object version);

  /// No description provided for @buildDateValue.
  ///
  /// In en, this message translates to:
  /// **'Build {date}'**
  String buildDateValue(Object date);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(Object error);

  /// No description provided for @backupRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup restore failed: {error}'**
  String backupRestoreFailed(Object error);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(Object error);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @dependantsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No targets yet'**
  String get dependantsEmptyTitle;

  /// No description provided for @dependantsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first target to get started.'**
  String get dependantsEmptySubtitle;

  /// No description provided for @addDependant.
  ///
  /// In en, this message translates to:
  /// **'Add target'**
  String get addDependant;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @dependantDeleted.
  ///
  /// In en, this message translates to:
  /// **'Target deleted'**
  String get dependantDeleted;

  /// No description provided for @dependantDetails.
  ///
  /// In en, this message translates to:
  /// **'Target details'**
  String get dependantDetails;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @noGroup.
  ///
  /// In en, this message translates to:
  /// **'No group'**
  String get noGroup;

  /// No description provided for @vehicleGroup.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleGroup;

  /// No description provided for @workMachineGroup.
  ///
  /// In en, this message translates to:
  /// **'Work machine'**
  String get workMachineGroup;

  /// No description provided for @deviceGroup.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get deviceGroup;

  /// No description provided for @animalGroup.
  ///
  /// In en, this message translates to:
  /// **'Animal'**
  String get animalGroup;

  /// No description provided for @noRelation.
  ///
  /// In en, this message translates to:
  /// **'No relation'**
  String get noRelation;

  /// No description provided for @relationLabel.
  ///
  /// In en, this message translates to:
  /// **'Relation: {relation}'**
  String relationLabel(Object relation);

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @allNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'All notes'**
  String get allNotesTitle;

  /// No description provided for @allNotesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get allNotesEmptyTitle;

  /// No description provided for @allNotesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'When you add notes to targets, they will appear here.'**
  String get allNotesEmptySubtitle;

  /// No description provided for @targetNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Target: {name}'**
  String targetNameLabel(Object name);

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes.'**
  String get noNotes;

  /// No description provided for @schedulers.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedulers;

  /// No description provided for @addScheduler.
  ///
  /// In en, this message translates to:
  /// **'Add schedule'**
  String get addScheduler;

  /// No description provided for @noSchedulers.
  ///
  /// In en, this message translates to:
  /// **'No schedules.'**
  String get noSchedulers;

  /// No description provided for @nextSchedule.
  ///
  /// In en, this message translates to:
  /// **'Next: {date}{overdue}'**
  String nextSchedule(Object date, Object overdue);

  /// No description provided for @overdueSuffix.
  ///
  /// In en, this message translates to:
  /// **' (overdue)'**
  String get overdueSuffix;

  /// No description provided for @dueSoonSuffix.
  ///
  /// In en, this message translates to:
  /// **' (within 2 weeks)'**
  String get dueSoonSuffix;

  /// No description provided for @dueTomorrowSuffix.
  ///
  /// In en, this message translates to:
  /// **' (1 day or less)'**
  String get dueTomorrowSuffix;

  /// No description provided for @newDependant.
  ///
  /// In en, this message translates to:
  /// **'New target'**
  String get newDependant;

  /// No description provided for @editDependant.
  ///
  /// In en, this message translates to:
  /// **'Edit target'**
  String get editDependant;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @tagOptional.
  ///
  /// In en, this message translates to:
  /// **'Tags (optional)'**
  String get tagOptional;

  /// No description provided for @filterTagsAction.
  ///
  /// In en, this message translates to:
  /// **'Filter tags'**
  String get filterTagsAction;

  /// No description provided for @filterTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Select tags'**
  String get filterTagsTitle;

  /// No description provided for @noTagsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tags yet.'**
  String get noTagsAvailable;

  /// No description provided for @showAllTargets.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get showAllTargets;

  /// No description provided for @applyFilterAction.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get applyFilterAction;

  /// No description provided for @noMatchingTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches for selected tags'**
  String get noMatchingTagsTitle;

  /// No description provided for @noMatchingTagsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change the selected tags or show all targets.'**
  String get noMatchingTagsSubtitle;

  /// No description provided for @relationOptional.
  ///
  /// In en, this message translates to:
  /// **'Relation (optional)'**
  String get relationOptional;

  /// No description provided for @commissioningDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Commissioning date (optional)'**
  String get commissioningDateOptional;

  /// No description provided for @birthDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Birth date (optional)'**
  String get birthDateOptional;

  /// No description provided for @odometerOptional.
  ///
  /// In en, this message translates to:
  /// **'Odometer (optional)'**
  String get odometerOptional;

  /// No description provided for @operatingHoursOptional.
  ///
  /// In en, this message translates to:
  /// **'Operating hours (optional)'**
  String get operatingHoursOptional;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get invalidNumber;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @usageEstimateLine.
  ///
  /// In en, this message translates to:
  /// **'Estimated current reading: {value} {unit}'**
  String usageEstimateLine(Object value, Object unit);

  /// No description provided for @initialDateValue.
  ///
  /// In en, this message translates to:
  /// **'{label}: {date}'**
  String initialDateValue(Object label, Object date);

  /// No description provided for @usageValueLabel.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value} {unit}'**
  String usageValueLabel(Object label, Object value, Object unit);

  /// No description provided for @birthDateShort.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get birthDateShort;

  /// No description provided for @commissioningDateShort.
  ///
  /// In en, this message translates to:
  /// **'Commissioned'**
  String get commissioningDateShort;

  /// No description provided for @odometerShort.
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get odometerShort;

  /// No description provided for @operatingHoursShort.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get operatingHoursShort;

  /// No description provided for @addNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNoteTitle;

  /// No description provided for @editNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNoteTitle;

  /// No description provided for @plainNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get plainNote;

  /// No description provided for @serviceNote.
  ///
  /// In en, this message translates to:
  /// **'Service note'**
  String get serviceNote;

  /// No description provided for @careNote.
  ///
  /// In en, this message translates to:
  /// **'Care note'**
  String get careNote;

  /// No description provided for @inspectionNote.
  ///
  /// In en, this message translates to:
  /// **'Inspection note'**
  String get inspectionNote;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @noteDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get noteDate;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @serviceDate.
  ///
  /// In en, this message translates to:
  /// **'Service date'**
  String get serviceDate;

  /// No description provided for @counterEstimateOptional.
  ///
  /// In en, this message translates to:
  /// **'Meter reading (optional)'**
  String get counterEstimateOptional;

  /// No description provided for @inspectorOptional.
  ///
  /// In en, this message translates to:
  /// **'Performer (optional)'**
  String get inspectorOptional;

  /// No description provided for @priceOptional.
  ///
  /// In en, this message translates to:
  /// **'Price € (optional)'**
  String get priceOptional;

  /// No description provided for @approvedLabel.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approvedLabel;

  /// No description provided for @performerLabel.
  ///
  /// In en, this message translates to:
  /// **'Performer'**
  String get performerLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @yesValue.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesValue;

  /// No description provided for @noValue.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noValue;

  /// No description provided for @noteSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get noteSaved;

  /// No description provided for @addSchedulerTitle.
  ///
  /// In en, this message translates to:
  /// **'Add schedule'**
  String get addSchedulerTitle;

  /// No description provided for @editSchedulerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get editSchedulerTitle;

  /// No description provided for @scheduleStartDate.
  ///
  /// In en, this message translates to:
  /// **'Schedule start date'**
  String get scheduleStartDate;

  /// No description provided for @calendarRule.
  ///
  /// In en, this message translates to:
  /// **'Calendar rule'**
  String get calendarRule;

  /// No description provided for @noCalendarRule.
  ///
  /// In en, this message translates to:
  /// **'No calendar rule'**
  String get noCalendarRule;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @semiAnnual.
  ///
  /// In en, this message translates to:
  /// **'Semi-annually'**
  String get semiAnnual;

  /// No description provided for @quarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get quarterly;

  /// No description provided for @customMonths.
  ///
  /// In en, this message translates to:
  /// **'Custom month interval'**
  String get customMonths;

  /// No description provided for @customMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Month interval'**
  String get customMonthsLabel;

  /// No description provided for @everyNMonths.
  ///
  /// In en, this message translates to:
  /// **'Every {months} months'**
  String everyNMonths(Object months);

  /// No description provided for @monthsMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Month interval must be > 0'**
  String get monthsMustBePositive;

  /// No description provided for @usageRule.
  ///
  /// In en, this message translates to:
  /// **'Usage-based rule'**
  String get usageRule;

  /// No description provided for @usageIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Interval ({unit})'**
  String usageIntervalLabel(Object unit);

  /// No description provided for @usageStartValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Start value ({unit})'**
  String usageStartValueLabel(Object unit);

  /// No description provided for @scheduleRuleRequired.
  ///
  /// In en, this message translates to:
  /// **'Select at least one schedule rule'**
  String get scheduleRuleRequired;

  /// No description provided for @intervalDays.
  ///
  /// In en, this message translates to:
  /// **'Interval in days'**
  String get intervalDays;

  /// No description provided for @nameMissing.
  ///
  /// In en, this message translates to:
  /// **'Name is missing'**
  String get nameMissing;

  /// No description provided for @intervalMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Interval must be > 0'**
  String get intervalMustBePositive;

  /// No description provided for @lastCompletedOptional.
  ///
  /// In en, this message translates to:
  /// **'Last completed (optional)'**
  String get lastCompletedOptional;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @schedulerSaved.
  ///
  /// In en, this message translates to:
  /// **'Schedule saved'**
  String get schedulerSaved;

  /// No description provided for @schedulerTypeLine.
  ///
  /// In en, this message translates to:
  /// **'{type}'**
  String schedulerTypeLine(Object type);

  /// No description provided for @schedulerCalendarLine.
  ///
  /// In en, this message translates to:
  /// **'Calendar: {interval}'**
  String schedulerCalendarLine(Object interval);

  /// No description provided for @schedulerUsageLine.
  ///
  /// In en, this message translates to:
  /// **'Usage threshold: {value} {unit}'**
  String schedulerUsageLine(Object value, Object unit);

  /// No description provided for @plainNoteSummary.
  ///
  /// In en, this message translates to:
  /// **'{date}{body}'**
  String plainNoteSummary(Object date, Object body);

  /// No description provided for @noteBodySuffix.
  ///
  /// In en, this message translates to:
  /// **' • {body}'**
  String noteBodySuffix(Object body);

  /// No description provided for @serviceNoteSummary.
  ///
  /// In en, this message translates to:
  /// **'Service {date}{counter}'**
  String serviceNoteSummary(Object date, Object counter);

  /// No description provided for @careNoteSummary.
  ///
  /// In en, this message translates to:
  /// **'Care {date}{counter}'**
  String careNoteSummary(Object date, Object counter);

  /// No description provided for @approvedSuffix.
  ///
  /// In en, this message translates to:
  /// **' • approved'**
  String get approvedSuffix;

  /// No description provided for @inspectionNoteSummary.
  ///
  /// In en, this message translates to:
  /// **'Inspection {date}{inspector}'**
  String inspectionNoteSummary(Object date, Object inspector);

  /// No description provided for @notesPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes placeholder'**
  String get notesPlaceholderTitle;

  /// No description provided for @notesPlaceholderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This view has been replaced by a data-bound target-specific note flow.'**
  String get notesPlaceholderSubtitle;

  /// No description provided for @schedulersPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedulers placeholder'**
  String get schedulersPlaceholderTitle;

  /// No description provided for @schedulersPlaceholderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This view has been replaced by a data-bound target-specific schedule flow.'**
  String get schedulersPlaceholderSubtitle;

  /// No description provided for @idLabel.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String idLabel(Object id);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fi': return AppLocalizationsFi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
