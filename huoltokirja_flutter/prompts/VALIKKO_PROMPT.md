# Flutter valikko prompt

## Tavoite

Toteuta sovellukseen vasemman yläkulman valikkonappula, josta käyttäjä voi avata sovelluksen päätoiminnot yhteen paikkaan.

## Vaatimukset

- Sovelluksen pääkäyttöliittymässä näytetään valikkonappula vasemmassa yläkulmassa.
- Valikkonappia painamalla avautuu valikko tai drawer-tyyppinen näkymä.
- Valikon pitää toimia mobiilikäyttöön luonnollisesti ja sopia nykyiseen Flutter-UI:hin.

### Valikon toiminnot

Valikosta pitää voida:

- viedä sovelluksen tiedot `CSV`-tiedostoon
- tulostaa `PDF`-raportti kohteista ja kohteiden muistiinpanoista
- vaihtaa sovelluksen kieli

### CSV-vienti

- CSV-vienti sisältää vähintään kohteet ja niihin liittyvät olennaiset tiedot.
- Muistiinpanojen tiedot voidaan sisällyttää samaan vientiin joko omana osionaan tai riveinä.
- Käyttäjälle näytetään selkeä palaute viennin onnistumisesta tai epäonnistumisesta.
- Tiedosto tallennetaan tai jaetaan laitteen normaaleilla tiedostonjakotavoilla, Flutter-ympäristö huomioiden.

### PDF-raportti

- PDF-raportissa näytetään kohteet ja kunkin kohteen muistiinpanot.
- Raportin pitää olla luettavassa muodossa ja aikajärjestyksessä.
- Raportin voi tallentaa tai jakaa tiedostona.
- Käyttäjälle näytetään palaute raportin luonnista.

### Kielen vaihto

- Oletuskielenä käytetään puhelimen kieltä.
- Käyttäjä voi vaihtaa kielen valikosta vähintään suomen ja englannin välillä.
- Valittu kieli pitää ottaa käyttöön koko sovelluksessa.
- Jos käyttäjä ei ole tehnyt omaa valintaa, sovellus seuraa laitteen oletuskieltä.
- Kielen valinta pitää tallentaa pysyvästi, jotta se säilyy sovelluksen uudelleenkäynnistyksen jälkeen.

## Toteutusperiaatteet

- Hyödynnä nykyistä lokalisaatiorakennetta `lib/l10n/app_fi.arb` ja `lib/l10n/app_en.arb`.
- Älä riko nykyisiä pääsivun, kohteiden, muistiinpanojen tai ajastusten toimintoja.
- Toteutuksen pitää istua nykyiseen Flutter-arkkitehtuuriin ja repository/provider-rakenteeseen.
- Näkyvät tekstit lokalisoidaan.

## Tarkistus

- `flutter gen-l10n`
- `flutter analyze`
- `flutter test`
