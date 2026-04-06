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

  /// No description provided for @relationOptional.
  ///
  /// In en, this message translates to:
  /// **'Relation (optional)'**
  String get relationOptional;

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
  /// **'Counter estimate (optional)'**
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

  /// No description provided for @counterEstimateSuffix.
  ///
  /// In en, this message translates to:
  /// **' • Counter estimate: {counter}'**
  String counterEstimateSuffix(Object counter);

  /// No description provided for @priceSuffix.
  ///
  /// In en, this message translates to:
  /// **' • price: {price} €'**
  String priceSuffix(Object price);

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

  /// No description provided for @inspectorSuffix.
  ///
  /// In en, this message translates to:
  /// **' • performer: {name}'**
  String inspectorSuffix(Object name);

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
