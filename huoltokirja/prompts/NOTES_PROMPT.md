# Flutter notes prompt

Tavoite: toteuta muistiinpanojen luonti, muokkaus, tallennus ja listaus johdonmukaisesti Flutter-sovelluksessa.

Vaatimukset:
- muistiinpanojen lisäyksessä pitää olla kolme vaihtoehtoa: `Muistiinpano`, `Huoltomuistiinpano` ja `Tarkastusmuistiinpano`
- tavallinen `Muistiinpano` pitää voida tallentaa ilman service- tai inspection-erikoiskenttiä
- jokaisella muistiinpanotyypillä pitää olla myös asetettava päivämäärä
- päivämäärä pitää voida valita editorissa kaikille tyypeille samalla päivämäärävalitsimella
- päivämäärä tallennetaan myös tavalliselle `Muistiinpano`-tyypille, ei vain huolto- tai tarkastusmuistiinpanoille
- tallennettu päivämäärä pitää näkyä muistiinpanon yhteenvedossa/listauksessa
- muokkaustilassa aiemmin tallennettu päivämäärä pitää ladata takaisin editoriin
- `Huoltomuistiinpano`-tyypissä pitää olla valinnaiset kentät `tekijä` ja `hinta`
- `Tarkastusmuistiinpano`-tyypissä pitää olla samat kentät kuin huoltomuistiinpanossa sekä lisäksi täppä `hyväksytty`
- erillistä `tarkastaja`-kenttää ei tarvita; käytä yhteistä `tekijä`-kenttää myös tarkastusmuistiinpanolle
- muistiinpanoihin liittyvät näkyvät tekstit pitää lokalisoida `lib/l10n/app_fi.arb` ja `lib/l10n/app_en.arb` -tiedostoihin
- käytä termiä `kohde` vanhan `riippuvainen`-termin sijasta myös muistiinpanoihin liittyvässä UI:ssa

Tarkistus:
- `flutter gen-l10n`
- `flutter analyze`
- `flutter test`
