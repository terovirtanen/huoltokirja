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
  String get noRelation => 'Ei suhdetta';

  @override
  String relationLabel(Object relation) {
    return 'Suhde: $relation';
  }

  @override
  String get notes => 'Muistiinpanot';

  @override
  String get addNote => 'Lisää muistiinpano';

  @override
  String get noNotes => 'Ei muistiinpanoja.';

  @override
  String get schedulers => 'Aikataulut';

  @override
  String get addScheduler => 'Lisää aikataulu';

  @override
  String get noSchedulers => 'Ei aikatauluja.';

  @override
  String nextSchedule(Object date, Object overdue) {
    return 'Seuraava: $date$overdue';
  }

  @override
  String get overdueSuffix => ' (myöhässä)';

  @override
  String get newDependant => 'Uusi kohde';

  @override
  String get editDependant => 'Muokkaa kohdetta';

  @override
  String get name => 'Nimi';

  @override
  String get nameRequired => 'Nimi on pakollinen';

  @override
  String get relationOptional => 'Suhde (valinnainen)';

  @override
  String get cancel => 'Peruuta';

  @override
  String get save => 'Tallenna';

  @override
  String get addNoteTitle => 'Lisää muistiinpano';

  @override
  String get editNoteTitle => 'Muokkaa muistiinpanoa';

  @override
  String get serviceNote => 'Huoltomuistiinpano';

  @override
  String get inspectionNote => 'Tarkastusmuistiinpano';

  @override
  String get type => 'Tyyppi';

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
  String get inspectorOptional => 'Tarkastaja (valinnainen)';

  @override
  String get noteSaved => 'Muistiinpano tallennettu';

  @override
  String get addSchedulerTitle => 'Lisää aikataulu';

  @override
  String get editSchedulerTitle => 'Muokkaa aikataulua';

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
  String get schedulerSaved => 'Aikataulu tallennettu';

  @override
  String serviceNoteSummary(Object date, Object counter) {
    return 'Huolto $date$counter';
  }

  @override
  String counterEstimateSuffix(Object counter) {
    return ' • km-arvio: $counter';
  }

  @override
  String inspectionNoteSummary(Object inspector) {
    return 'Tarkastus$inspector';
  }

  @override
  String inspectorSuffix(Object name) {
    return ' ($name)';
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
