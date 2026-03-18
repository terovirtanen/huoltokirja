Toimi lead-tason Flutter-kehittajana ja jatka projektia bootstrap-vaiheen jalkeen.

Lahdeoletus:
- `07-flutter-project-bootstrap.md` on jo toteutettu
- Flutter-projektin kansiorakenne, SQLite-peruspohja ja placeholder-UI ovat olemassa
- nykyinen Xamarin/.NET-koodi toimii vain domain-vaatimusten lahteena

Tavoite tassa vaiheessa:
- toteuta Dart-domain-mallit oikeasti kayttoon
- toteuta repositoryt niin, etta data voidaan tallentaa ja lukea SQLite-kannasta
- valmistele sovellus siihen pisteeseen, että UI voidaan kytkea oikeaan dataan seuraavassa vaiheessa

Pakolliset vaatimukset:
- Android + iPhone yhdesta Flutter-koodipohjasta
- SQLite pysyy paikallisena tietokantana
- domainin tulee seurata nykyisen sovelluksen ydinkasitteita:
  - Dependant
  - Note
  - ServiceNote
  - InspectionNote
  - Scheduler
- computed kentat ja persisted kentat on eroteltava selkeasti

========================================
TEHTAVA
========================================
Toteuta seuraavat:

1) Domain-mallit valmiiksi
- Dart-tyypit nykyisen model-analyysin perusteella
- value object / enum -rakenteet tarvittaessa
- note-tyyppien erot selkeasti mallinnettuina
- schedulerin saannot mallinnettuina niin, että logiikka on laajennettavissa

2) Mapping-kerros
- mapit SQLite-riveista domain-malleihin
- mapit domain-malleista persistence-malleihin
- ratkaise note-polymorfismi selkeasti (esim. discriminator)

3) Repositoryt valmiiksi
- `DependantRepository`
- `NoteRepository`
- `SchedulerRepository`
- CRUD-operaatiot
- perushaut:
  - hae kaikki dependantit
  - hae dependantin notet
  - hae dependantin schedulerit
  - tallenna / paivita / poista

4) Domain-logiikan toteutus
- riippuvaisen notejen ja schedulerien omistajuus
- counter estimate -logiikan Dart-versio
- schedulerin next schedule -laskennan perusversio
- notejen listatekstien muodostus

5) Testit
- unit test domain-logiikalle
- repository testit SQLite-kerrokselle
- mapping testit polymorfisille note-tyypeille

========================================
RAJOITTEET
========================================
- Ala tee viela lopullista production-UI-kytkentaa.
- Ala ylikuormita arkkitehtuuria tarpeettomilla abstraktioilla.
- Tee ratkaisut niin, että seuraavassa vaiheessa UI voidaan liittaa suoraan repositoryihin tai state management -kerrokseen.
- Pida rakenne selkeana ja helposti testattavana.

========================================
TULOSTE
========================================
Haluan lopuksi seuraavat osiot:

# 1) Domain Implemented
- mitka domain-mallit toteutettiin
- mitka business rulet saatiin mukaan

# 2) Repository Layer
- mitka repositoryt luotiin
- miten SQLite-mapping tehtiin

# 3) Files Created or Updated
- tiedostoittain mita tehtiin ja miksi

# 4) Validation
- miten testit ajettiin
- miten varmistetaan, että SQLite CRUD toimii Androidilla ja iPhonella

# 5) Next Checkpoint
- seuraava vaihe: UI:n kytkeminen oikeaan dataan
- mita kannattaa toteuttaa ensin

Jos jokin domain-sääntö on epäselvä nykykoodin perusteella, tee perusteltu oletus ja kerro se lopuksi.
