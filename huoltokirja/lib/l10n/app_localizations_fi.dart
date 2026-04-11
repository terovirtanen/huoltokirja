// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Huoltokirja';

  @override
  String get menu => 'Valikko';

  @override
  String get exportBackupAction => 'Vie varmuuskopio';

  @override
  String get exportBackupSubtitle => 'Luo JSON-varmuuskopio';

  @override
  String get importBackupAction => 'Palauta varmuuskopio';

  @override
  String get importBackupSubtitle => 'Tuo aiemmin viety varmuuskopio tiedostosta';

  @override
  String get exportCsvAction => 'Vie tiedot CSV-tiedostoon';

  @override
  String get exportCsvSubtitle => 'Vie kohteet ja muistiinpanot taulukkomuotoon';

  @override
  String get exportPdfAction => 'Tulosta PDF-raportti';

  @override
  String get exportPdfSubtitle => 'Luo ja jaa luettava raportti kohteista';

  @override
  String get changeLanguageAction => 'Vaihda kieli';

  @override
  String get aboutAction => 'Tietoja';

  @override
  String get aboutSubtitle => 'Näytä ohjelmiston versio ja build-päivämäärä';

  @override
  String currentSelectionLabel(Object value) {
    return 'Nykyinen: $value';
  }

  @override
  String get chooseLanguage => 'Valitse kieli';

  @override
  String get useDeviceLanguage => 'Käytä puhelimen kieltä';

  @override
  String get finnishLanguage => 'Suomi';

  @override
  String get englishLanguage => 'Englanti';

  @override
  String csvExportReady(Object fileName) {
    return 'CSV-vienti valmis: $fileName';
  }

  @override
  String pdfExportReady(Object fileName) {
    return 'PDF-raportti valmis: $fileName';
  }

  @override
  String backupExportReady(Object fileName) {
    return 'Varmuuskopio valmis: $fileName';
  }

  @override
  String get backupRestoreSuccess => 'Varmuuskopio palautettu';

  @override
  String versionValue(Object version) {
    return 'Versio $version';
  }

  @override
  String buildDateValue(Object date) {
    return 'Build $date';
  }

  @override
  String exportFailed(Object error) {
    return 'Vienti epäonnistui: $error';
  }

  @override
  String backupRestoreFailed(Object error) {
    return 'Varmuuskopion palautus epäonnistui: $error';
  }

  @override
  String get loading => 'Ladataan...';

  @override
  String errorPrefix(Object error) {
    return 'Virhe: $error';
  }

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get dependantsEmptyTitle => 'Ei kohteita vielä';

  @override
  String get dependantsEmptySubtitle => 'Lisää ensimmäinen kohde aloittaaksesi.';

  @override
  String get addDependant => 'Lisää kohde';

  @override
  String get add => 'Lisää';

  @override
  String get edit => 'Muokkaa';

  @override
  String get delete => 'Poista';

  @override
  String get dependantDeleted => 'Kohde poistettu';

  @override
  String get dependantDetails => 'Kohteen tiedot';

  @override
  String get group => 'Ryhmä';

  @override
  String get noGroup => 'Ei ryhmää';

  @override
  String get vehicleGroup => 'Ajoneuvo';

  @override
  String get workMachineGroup => 'Työkone';

  @override
  String get deviceGroup => 'Laite';

  @override
  String get animalGroup => 'Eläin';

  @override
  String get noRelation => 'Ei suhdetta';

  @override
  String relationLabel(Object relation) {
    return 'Suhde: $relation';
  }

  @override
  String get notes => 'Muistiinpanot';

  @override
  String get allNotesTitle => 'Kaikki muistiinpanot';

  @override
  String get allNotesEmptyTitle => 'Ei muistiinpanoja vielä';

  @override
  String get allNotesEmptySubtitle => 'Kun lisäät muistiinpanoja kohteille, ne näkyvät täällä.';

  @override
  String targetNameLabel(Object name) {
    return 'Kohde: $name';
  }

  @override
  String get addNote => 'Lisää muistiinpano';

  @override
  String get noNotes => 'Ei muistiinpanoja.';

  @override
  String get schedulers => 'Ajastukset';

  @override
  String get addScheduler => 'Lisää ajastus';

  @override
  String get noSchedulers => 'Ei ajastuksia.';

  @override
  String nextSchedule(Object date, Object overdue) {
    return 'Seuraava: $date$overdue';
  }

  @override
  String get overdueSuffix => ' (myöhässä)';

  @override
  String get dueSoonSuffix => ' (alle 2 viikkoa)';

  @override
  String get dueTomorrowSuffix => ' (1 päivä tai vähemmän)';

  @override
  String get newDependant => 'Uusi kohde';

  @override
  String get editDependant => 'Muokkaa kohdetta';

  @override
  String get name => 'Nimi';

  @override
  String get nameRequired => 'Nimi on pakollinen';

  @override
  String get tagOptional => 'Leima (valinnainen)';

  @override
  String get filterTagsAction => 'Suodata leimoja';

  @override
  String get filterTagsTitle => 'Valitse leimat';

  @override
  String get noTagsAvailable => 'Ei leimoja vielä.';

  @override
  String get showAllTargets => 'Tyhjennä suodatus';

  @override
  String get applyFilterAction => 'Suodata';

  @override
  String get noMatchingTagsTitle => 'Ei osumia valituilla leimoilla';

  @override
  String get noMatchingTagsSubtitle => 'Muuta leimoja tai näytä kaikki kohteet.';

  @override
  String get relationOptional => 'Suhde (valinnainen)';

  @override
  String get commissioningDateOptional => 'Käyttöönotto pvm (valinnainen)';

  @override
  String get birthDateOptional => 'Syntymäaika (valinnainen)';

  @override
  String get odometerOptional => 'Ajokilometrit (valinnainen)';

  @override
  String get operatingHoursOptional => 'Käyttötunnit (valinnainen)';

  @override
  String get invalidNumber => 'Anna kelvollinen numero';

  @override
  String get cancel => 'Peruuta';

  @override
  String get save => 'Tallenna';

  @override
  String usageEstimateLine(Object value, Object unit) {
    return 'Arviolukema nyt: $value $unit';
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
  String get birthDateShort => 'Syntymäaika';

  @override
  String get commissioningDateShort => 'Käyttöönotto';

  @override
  String get odometerShort => 'Kilometrit';

  @override
  String get operatingHoursShort => 'Tunnit';

  @override
  String get addNoteTitle => 'Lisää muistiinpano';

  @override
  String get editNoteTitle => 'Muokkaa muistiinpanoa';

  @override
  String get plainNote => 'Muistiinpano';

  @override
  String get serviceNote => 'Huolto muistiinpano';

  @override
  String get careNote => 'Hoitomuistiinpano';

  @override
  String get inspectionNote => 'Tarkastus muistiinpano';

  @override
  String get type => 'Tyyppi';

  @override
  String get noteDate => 'Päivämäärä';

  @override
  String get title => 'Otsikko';

  @override
  String get titleRequired => 'Otsikko on pakollinen';

  @override
  String get description => 'Kuvaus';

  @override
  String get serviceDate => 'Huoltopäivä';

  @override
  String get counterEstimateOptional => 'Mittarilukema-arvio (valinnainen)';

  @override
  String get inspectorOptional => 'Tekijä (valinnainen)';

  @override
  String get priceOptional => 'Hinta € (valinnainen)';

  @override
  String get approvedLabel => 'Hyväksytty';

  @override
  String get performerLabel => 'Tekijä';

  @override
  String get priceLabel => 'Hinta';

  @override
  String get yesValue => 'Kyllä';

  @override
  String get noValue => 'Ei';

  @override
  String get noteSaved => 'Muistiinpano tallennettu';

  @override
  String get addSchedulerTitle => 'Lisää ajastus';

  @override
  String get editSchedulerTitle => 'Muokkaa ajastusta';

  @override
  String get scheduleStartDate => 'Ajastuksen alkupäivä';

  @override
  String get calendarRule => 'Kalenterisääntö';

  @override
  String get noCalendarRule => 'Ei kalenterisääntöä';

  @override
  String get yearly => 'Vuosittain';

  @override
  String get semiAnnual => 'Puolivuosittain';

  @override
  String get quarterly => 'Neljännesvuosittain';

  @override
  String get customMonths => 'Mukautettu kuukausiväli';

  @override
  String get customMonthsLabel => 'Kuukausiväli';

  @override
  String everyNMonths(Object months) {
    return 'Joka $months. kuukausi';
  }

  @override
  String get monthsMustBePositive => 'Kuukausivälin tulee olla > 0';

  @override
  String get usageRule => 'Käytön mukaan';

  @override
  String usageIntervalLabel(Object unit) {
    return 'Väli ($unit)';
  }

  @override
  String usageStartValueLabel(Object unit) {
    return 'Alkuarvo ($unit)';
  }

  @override
  String get scheduleRuleRequired => 'Valitse vähintään yksi ajastussääntö';

  @override
  String get intervalDays => 'Väli päivinä';

  @override
  String get nameMissing => 'Nimi puuttuu';

  @override
  String get intervalMustBePositive => 'Välin tulee olla > 0';

  @override
  String get lastCompletedOptional => 'Viimeisin suoritus (valinnainen)';

  @override
  String get notSet => 'Ei asetettu';

  @override
  String get schedulerSaved => 'Ajastus tallennettu';

  @override
  String schedulerTypeLine(Object type) {
    return '$type';
  }

  @override
  String schedulerCalendarLine(Object interval) {
    return 'Kalenteri: $interval';
  }

  @override
  String schedulerUsageLine(Object value, Object unit) {
    return 'Käyttöraja: $value $unit';
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
    return 'Huolto $date$counter';
  }

  @override
  String careNoteSummary(Object date, Object counter) {
    return 'Hoito $date$counter';
  }

  @override
  String counterEstimateSuffix(Object counter) {
    return ' • km-arvio: $counter';
  }

  @override
  String priceSuffix(Object price) {
    return ' • hinta: $price €';
  }

  @override
  String get approvedSuffix => ' • hyväksytty';

  @override
  String inspectionNoteSummary(Object date, Object inspector) {
    return 'Tarkastus $date$inspector';
  }

  @override
  String inspectorSuffix(Object name) {
    return ' • tekijä: $name';
  }

  @override
  String get notesPlaceholderTitle => 'Muistiinpanojen placeholder';

  @override
  String get notesPlaceholderSubtitle => 'Tämä näkymä on korvattu datakytketyllä kohdekohtaisella muistiinpanopolulla.';

  @override
  String get schedulersPlaceholderTitle => 'Aikataulujen placeholder';

  @override
  String get schedulersPlaceholderSubtitle => 'Tämä näkymä on korvattu datakytketyllä kohdekohtaisella aikataulupolulla.';

  @override
  String idLabel(Object id) {
    return 'ID: $id';
  }
}
