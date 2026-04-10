# Flutter ensiasennuksen esimerkkidata prompt

## Tavoite

Toteuta Flutter-sovellukseen ensiasennuksen esimerkkidata, joka luodaan automaattisesti vain silloin, kun applikaatio avataan **ensimmäisen kerran puhtaalla asennuksella laitteella**.

Tämän tarkoitus on:
- näyttää sovelluksen idea heti ilman tyhjää näkymää
- antaa realistinen esimerkkiaineisto kohteista, muistiinpanoista ja ajastuksista
- auttaa käyttäjää ymmärtämään, miten sovellusta käytetään

## Pakolliset vaatimukset

- Esimerkkidata luodaan vain kerran.
- Jos tietokannassa on jo oikeaa tai aiemmin luotua dataa, esimerkkidataa ei luoda uudelleen.
- Toteutus ei saa synnyttää duplikaatteja sovelluksen seuraavilla käynnistyskerroilla.
- Ajankohdat lasketaan suhteessa **nykyhetkeen** (`DateTime.now()`), ei kovakoodatuilla päivämäärillä.
- Esimerkkidata tallennetaan samaan oikeaan SQLite-tietokantaan ja samoilla repository-/domain-rakenteilla kuin muukin data.
- Käytä olemassa olevia domain-malleja ja teknisiä kenttiä (`dependantGroup`, `tag`, note-tyypit, schedulerit).
- Eläimen kohdalla UI:ssa näytettävä "hoitomuistiinpano" voi teknisesti olla sama note-tyyppi, jota käytetään huoltomuistiinpanoihin, jos nykyarkkitehtuuri toimii niin.

## Toteutettava esimerkkidata

### Esimerkki 1: ajoneuvo

Luo kohde:
- nimi: `Toyota Corolla`
- ryhmä / `dependantGroup`: `vehicle`
- tämänhetkinen km-arvo / `usage`: `234000`
- `tag`: `autot`

Luo huoltomuistiinpanot:
1. `Öljynvaihto`
   - ajankohta: tasan 1 vuosi tästä hetkestä taaksepäin
   - km-lukema: `210000`
   - tekijä: `Korjaamo Oy`
   - hinta: `69`
2. `Jarrupalat`
   - ajankohta: tasan 5 kuukautta tästä hetkestä taaksepäin
   - km-lukema: `220000`
   - tekijä: `Korjaamo Oy`
   - hinta: `169`
3. `Öljynvaihto`
   - ajankohta: tasan 1 kuukausi tästä hetkestä taaksepäin
   - km-lukema: `232000`
   - tekijä: `Korjaamo Oy`
   - hinta: `69`

Luo tarkastusmuistiinpanot:
1. `Katsastus`
   - ajankohta: tasan 5 kuukautta ja 2 viikkoa tästä hetkestä taaksepäin
   - km-lukema: `219000`
   - tekijä: `Katsastaja Oy`
   - hinta: `74`
   - `approved = false`
2. `Uusinta katsastus`
   - ajankohta: tasan 4 kuukautta ja 3 viikkoa tästä hetkestä taaksepäin
   - km-lukema: `221000`
   - tekijä: `Katsastaja Oy`
   - hinta: `34`
   - `approved = true`

### Esimerkki 2: lemmikki

Luo kohde:
- nimi: `Musti`
- ryhmä / `dependantGroup`: `animal`
- syntymäaika / `initialDate`: tasan 3 vuotta tästä hetkestä taaksepäin
- `tag`: esimerkiksi `lemmikit`

Luo hoitomuistiinpano:
1. `Eläinlääkäri käynti`
   - kuvaus: `rokotus`
   - ajankohta: tasan 1 vuosi tästä hetkestä taaksepäin
   - tekijä: `Leevi Eläinhoitaja`
   - hinta: `25`

Luo ajastus:
1. `Eläinlääkäri`
   - tyyppi: hoitomuistiinpano
   - ajastus alkaa: tasan 1 vuosi sitten
   - sääntö: `vuosittain`

## Toteutusohje

Toteuta ratkaisu esimerkiksi näin:

1. Luo erillinen bootstrap-/seed-palvelu, esimerkiksi:
   - `ExampleDataSeeder`
   - `InitialDataBootstrapService`

2. Kutsu sitä sovelluksen käynnistyksessä vasta sen jälkeen, kun tietokanta ja repositoryt ovat käytettävissä.

3. Tarkista ennen lisäystä esimerkiksi jompikumpi seuraavista:
   - tietokanta on tyhjä (`dependants`-taulussa ei rivejä), tai
   - erillinen `SharedPreferences`-lippu kuten `example_data_seeded = true/false`

4. Lisää data repositoryjen kautta, ei suoraan irrallisilla SQL-lauseilla, jotta domain-logiikka pysyy yhtenäisenä.

5. Pidä toteutus helposti poistettavana tai laajennettavana myöhemmin, jos esimerkkidataa halutaan lisää.

## Testaus ja validointi

Varmista ainakin seuraavat:

- ensimmäisellä käynnistyksellä esimerkkidata ilmestyy automaattisesti
- toisella käynnistyksellä samoja rivejä ei lisätä uudelleen
- kohteet näkyvät pääsivulla oikein
- Toyota Corolla näyttää huolto- ja tarkastusmuistiinpanot oikein
- Musti näyttää hoitomuistiinpanon ja vuosittaisen ajastuksen oikein
- tagit/leimat näkyvät ja niitä voidaan käyttää filtterissä

## Tarkistus

- `flutter analyze`
- `flutter test`

## Tuloste

Haluan lopuksi seuraavat osiot:

### 1) Toteutus
- miten ensiasennuksen esimerkkidata toteutettiin
- missä kohtaa sovelluksen käynnistystä se tehdään

### 2) Luodut tiedot
- mitä kohteita, muistiinpanoja ja ajastuksia syntyy

### 3) Muutetut tiedostot
- tiedostoittain mitä lisättiin tai muutettiin

### 4) Varmistus
- miten varmistettiin, että data luodaan vain kerran
- miten `flutter analyze` ja `flutter test` ajettiin
