# Flutter ensiasennuksen esimerkkidata prompt

## Tavoite

Toteuta Flutter-sovellukseen ensiasennuksen esimerkkidata, joka luodaan automaattisesti vain silloin, kun sovellus avataan **ensimmäisen kerran puhtaalla asennuksella laitteella**.

Tämän tarkoitus on:
- näyttää sovelluksen idea heti ilman tyhjää näkymää
- antaa realistinen esimerkkiaineisto kohteista, muistiinpanoista ja ajastuksista
- auttaa käyttäjää ymmärtämään, miten sovellusta käytetään

---

## Pakolliset vaatimukset

- Esimerkkidata luodaan vain kerran.
- Jos tietokannassa on jo oikeaa tai aiemmin luotua dataa, esimerkkidataa ei luoda uudelleen.
- Toteutus ei saa synnyttää duplikaatteja sovelluksen seuraavilla käynnistyskerroilla.
- Ajankohdat lasketaan suhteessa **nykyhetkeen** (`DateTime.now()`), ei kovakoodatuilla päivämäärillä.
- Esimerkkidata tallennetaan samaan oikeaan SQLite-tietokantaan ja samoilla repository-/domain-rakenteilla kuin muukin data.
- Käytä olemassa olevia domain-malleja ja teknisiä kenttiä (`dependantGroup`, `tag`, note-tyypit, schedulerit).
- UI:ssa **leima/leimat** perustuvat tekniseen kenttään `tag`.
- Päivämäärien tulee näkyä UI:ssa **lokalisoinnin mukaisesti**, ei kiinteässä `yyyy-MM-dd`-muodossa.

---

## Nykyiset sovellussäännöt, jotka promptissa on huomioitava

### 1) Kohteen tiedot
- Kohteen yksityiskohdissa **ryhmää ei näytetä** käyttäjälle.
- Sen sijaan näytetään **leimat** (`tag`).
- Ryhmä on edelleen tekninen kenttä datassa, jotta sovellus osaa käyttäytyä oikein.

### 2) Ajoneuvon ja työkoneen käyttömäärä
- Ajoneuvon kilometrejä tai työkoneen tunteja **ei enää syötetä kohteen tietoihin käyttäjän näkymässä**.
- Käyttöhistoria ja arviot muodostetaan **muistiinpanoihin syötettyjen `estimatedCounter`-lukemien** perusteella.
- Jos käyttömääräarviota ei voida laskea, koska km/h-muistiinpanoja on liian vähän, **käyttömääräsääntö ei saa luoda uutta automaattimuistiinpanoa**.
- Jos näkyvä käyttöraja on jo arviota pienempi, pitää käyttää **ensimmäistä käyttörajaa, joka on arviota suurempi**.

### 3) Eläin
- Eläimelle voi tehdä **tavallisen muistiinpanon** ja **hoitomuistiinpanon** (teknisesti sama note-tyyppi kuin huoltomuistiinpano).
- Eläimelle **ei voi tehdä tarkastusmuistiinpanoa**.
- Eläimelle **ei voi tehdä ajastinta tarkastusmuistiinpanolle**.

### 4) Ajastukset
- Kalenterisäännössä, jos aloituspäivä on **tänään** ja sääntö on esimerkiksi **vuosittain**, seuraava ajankohta tarkoittaa **ensi vuotta**, ei tätä päivää.
- Automaattisesti luotuja muistiinpanoja syntyy **vain yksi per ajastus**.
- Jos ajastus muuttuu merkittävästi, vanha koskematon automaattimuistiinpano voidaan korvata uudella oikeaan ajankohtaan.

---

## Toteutettava esimerkkidata

### Esimerkki 1: ajoneuvo

Luo kohde:
- nimi: `Toyota Corolla`
- ryhmä / `dependantGroup`: `vehicle`
- `tag`: `autot käyttöauto`

> Älä nojaa erilliseen kohteen `usage`-arvoon käyttömäärädemonstraatiossa, vaan muodosta käyttömäärähistoria muistiinpanojen km-lukemista.

Luo huoltomuistiinpanot:
1. `Öljynvaihto`
   - ajankohta: tasan 1 vuosi tästä hetkestä taaksepäin
   - km-lukema (`estimatedCounter`): `210000`
   - tekijä: `Korjaamo Oy`
   - hinta: `69`
2. `Jarrupalat`
   - ajankohta: tasan 5 kuukautta tästä hetkestä taaksepäin
   - km-lukema (`estimatedCounter`): `220000`
   - tekijä: `Korjaamo Oy`
   - hinta: `169`
3. `Öljynvaihto`
   - ajankohta: tasan 1 kuukausi tästä hetkestä taaksepäin
   - km-lukema (`estimatedCounter`): `232000`
   - tekijä: `Korjaamo Oy`
   - hinta: `69`

Luo tarkastusmuistiinpanot:
1. `Katsastus`
   - ajankohta: tasan 5 kuukautta ja 2 viikkoa tästä hetkestä taaksepäin
   - km-lukema (`estimatedCounter`): `219000`
   - tekijä: `Katsastaja Oy`
   - hinta: `74`
   - `approved = false`
2. `Uusinta katsastus`
   - ajankohta: tasan 4 kuukautta ja 3 viikkoa tästä hetkestä taaksepäin
   - km-lukema (`estimatedCounter`): `221000`
   - tekijä: `Katsastaja Oy`
   - hinta: `34`
   - `approved = true`

Luo ajastukset:
1. `Katsastus`
   - tyyppi: tarkastusmuistiinpano
   - aloitus: noin 1 vuosi sitten
   - sääntö: `vuosittain`
2. `Öljynvaihto`
   - tyyppi: huoltomuistiinpano
   - käyttömääräsääntö
   - väli: `20000`
   - alkuarvo: sellainen, että seuraava raja löytyy viimeisimpien km-muistiinpanojen perusteella oikein

### Esimerkki 2: lemmikki

Luo kohde:
- nimi: `Musti`
- ryhmä / `dependantGroup`: `animal`
- syntymäaika / `initialDate`: tasan 3 vuotta tästä hetkestä taaksepäin
- `tag`: `lemmikit rokotus`

Luo hoitomuistiinpano:
1. `Eläinlääkärikäynti`
   - kuvaus: `rokotus`
   - ajankohta: tasan 1 vuosi tästä hetkestä taaksepäin
   - tekijä: `Leevi Eläinhoitaja`
   - hinta: `25`

Luo ajastus:
1. `Eläinlääkäri`
   - tyyppi: hoitomuistiinpano / service-note eläimelle
   - aloitus: tasan 1 vuosi sitten
   - sääntö: `vuosittain`

> Älä luo eläimelle tarkastusmuistiinpanoja tai tarkastusajastimia.

---

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

---

## Testaus ja validointi

Varmista ainakin seuraavat:

- ensimmäisellä käynnistyksellä esimerkkidata ilmestyy automaattisesti
- toisella käynnistyksellä samoja rivejä ei lisätä uudelleen
- kohteet näkyvät pääsivulla oikein
- kohteen tiedoissa näkyvät **leimat**, ei ryhmä
- Toyota Corolla näyttää huolto- ja tarkastusmuistiinpanot oikein
- käyttömääräarvio muodostuu Toyota-esimerkin muistiinpanojen km-lukemista
- Musti näyttää hoitomuistiinpanon ja vuosittaisen ajastuksen oikein
- eläimelle ei tarjota tarkastusmuistiinpanoa eikä tarkastusajastinta
- tagit/leimat näkyvät ja niitä voidaan käyttää filtterissä

---

## Tarkistus

- `flutter analyze`
- `flutter test`

---

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
