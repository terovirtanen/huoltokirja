Toimi lead-tason Flutter-arkkitehtina ja luo koko projekti alusta asti uutena Flutter-sovelluksena.

Nykyinen `huoltokirja`-ratkaisu toimii vain vaatimusten lahteena.
Ala jatkokehita nykyista Xamarin/.NET-koodia.
Tee uusi toteutus greenfield-projektina.

Pakolliset vaatimukset:
- yksi Flutter-koodipohja
- tuki Androidille
- tuki iPhonelle
- paikallinen tietokanta on SQLite
- arkkitehtuuri tukee jatkokehitysta: UI, domain, data, repositoryt, testit
- rakenne tukee noteja, dependanteja ja schedulereita

Tavoite tassa vaiheessa:
luo koko Flutter-projektin perusta niin, etta seuraavissa vaiheissa voidaan toteuttaa UI ja domain-logiikka nopeasti ilman arkkitehtuurin uusimista.

========================================
TEHTAVA
========================================
Luo uusi Flutter-projekti ja rakenna siihen valmiiksi:

1) Projektin kansiorakenne
- `lib/app/`
- `lib/core/`
- `lib/features/dependants/`
- `lib/features/notes/`
- `lib/features/schedulers/`
- `lib/data/`
- `lib/domain/`
- `lib/shared/`
- `test/`
- `integration_test/`

2) Arkkitehtuurin peruspohja
- app entrypoint
- reititys / navigation shell
- environment / config perusrakenne
- theme / typography / colors perusrakenne
- error handling perusrakenne
- logging perusrakenne

3) SQLite peruspohja
- valitse Flutteriin sopiva SQLite-ratkaisu (esim. `drift`, `sqflite`, tai muu hyvin perusteltu vaihtoehto)
- perustele valinta lyhyesti
- luo database bootstrap
- luo migration/versioning peruspohja
- luo esimerkkitaulut riippuvaisille, noteille ja schedulereille
- luo repository interface -pohjat
- luo repository implementation -pohjat

4) Domain peruspohja
- Dart-mallit ainakin seuraaville:
  - Dependant
  - Note
  - ServiceNote
  - InspectionNote
  - Scheduler
- erottele persisted kentat ja computed kentat selkeasti
- tee mappausvalmius SQLite-riveista domain-malleihin ja takaisin

5) UI peruspohja
- app shell
- placeholder home screen
- placeholder dependant list screen
- placeholder dependant detail screen
- placeholder note editor screen
- placeholder scheduler screen
- yhteinen loading / empty / error widget perusta

6) Testauksen peruspohja
- yksi unit test esimerkki domainille
- yksi repository testin runko
- yksi widget testin runko
- yksi integration testin runko

7) Kehityskelpoisuus
- package dependencies kuntoon
- analyysi/lint asetukset kuntoon, jos tarpeen
- selkeat kommentit vain sinne missa rakenne ei ole itsestaan selva

========================================
RAJOITTEET
========================================
- Ala tee vielä koko sovelluksen lopullista toiminnallisuutta.
- Ala toteuta kaikkia business ruleja valmiiksi.
- Rakenna vain vahva ja siisti peruspohja.
- Tee ratkaisut niin, että Android ja iPhone pysyvat samanarvoisina alustoina.
- SQLite on pakollinen.
- Flutter on ensisijainen toteutusteknologia.

========================================
TULOSTE
========================================
Haluan lopuksi seuraavat osiot:

# 1) Created Project Structure
- kansiot ja paatiedostot

# 2) Chosen Stack
- Flutter packages
- state management ratkaisu
- SQLite-ratkaisu
- perustelut lyhyesti

# 3) Files Created
- tiedostoittain mita luotiin ja miksi

# 4) Validation
- miten projekti kaynnistetaan
- miten testit ajetaan
- miten varmistetaan Android + iPhone + SQLite bootstrap

# 5) Next Checkpoint
- mita kannattaa toteuttaa seuraavaksi
- suositeltu jarjestys UI -> domain -> repository -> flows

Jos jokin oleellinen arkkitehtuuripaatos on avoin, tee perusteltu oletus ja kerro se lopuksi.
