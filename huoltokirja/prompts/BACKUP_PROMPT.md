# Flutter backup prompt

## Tavoite

Tämä dokumentti kuvaa backup-ominaisuuden nykyisen toteutuksen huhtikuussa 2026 sekä ehdotuksen seuraavasta muutoksesta.

Tämä dokumentti vastaa nyt toteutettua toimintaa ja nykyistä linjausta.

## Nykyinen toteutus

### 1. Datamalli ja formaatti

Backup tallennetaan JSON-muodossa.

Mukana ovat vähintään seuraavat kentät:

- schemaVersion
- createdAt
- appVersion
- dependants
- notes
- schedulers

Restore validoi rakenteen ja korvaa nykyisen tietokantasisällön varmuuskopion sisällöllä.

### 2. Automaattinen backup

Sovellus tekee automaattisen backupin debounce-tyyppisesti datamuutosten jälkeen.

Nykyinen toimintamalli:

- repositoriot ajastavat backupin muutosten jälkeen
- oletusviive on 15 sekuntia
- jos sovellus menee taustalle tai sulkeutuu, odottava backup ajetaan heti loppuun

### 3. Paikallinen tallennus

Paikalliset automaattiset backupit tallennetaan sovelluksen asiakirjahakemiston backups-kansioon.

Nykyinen toimintatapa on tämä:

- käytön aikana tallennetaan vain yksi paikallinen latest-tiedosto
- paikallinen automaattinen backup ei tee enää erillistä historiakiertoa jokaisesta muutoksesta

Tavoitenimi:

- uusin paikallinen backup: huoltokirja-auto-latest.json

### 4. Pilvisynkronointi

Käyttäjä voi:

- laittaa pilvisynkronoinnin päälle tai pois
- valita pilvikansion
- synkronoida uusimman paikallisen backupin pilveen sovelluksen sulkeutuessa tai siirtyessä taustalle

Nykyinen toimintatapa:

- käytön aikana kirjoitetaan vain paikallinen latest
- lopetuksen tai taustalle siirtymisen yhteydessä tehdään pilvitallennus
- samalla tehdään pilven kierrätys latest + prev-1 ... prev-3 mallilla

Ensimmäisellä käynnistyksellä sovellus voi myös tarjota uusimman pilvivarmuuskopion palauttamista.

### 5. Käyttöliittymä

Backup-valikossa on tällä hetkellä:

- pilvisynkronoinnin kytkentä päälle tai pois
- pilvikansion valinta
- vie varmuuskopio
- palauta varmuuskopio

Nykyinen toimintatapa valikolle on tämä:

- Vie varmuuskopio tekee ensin manuaalisen paikallisen kopion
- sen jälkeen sama kopio viedään käyttäjän valittuun pilvikansioon
- toiminnon alaotsikko muutetaan muotoon: Luo varmuuskopio

Palautuksessa käyttäjä voi valita version laitteelta tai pilvestä. Oletuksena valitaan uusin saatavilla oleva versio.

### 6. Testikattavuus

Nykyisestä toteutuksesta on jo testit ainakin seuraaville:

- backup-payloadin muodostus
- restore, joka korvaa tietokannan sisällön
- automaattinen backup tiedostoon
- uusimman backupin synkka pilveen
- palautettavien backup-versioiden listaus

## Havaittu ongelma

Backup-tiedostoja kertyy edelleen liikaa.

Juurisyy on se, että nykyinen toteutus kirjoittaa:

- yhden latest-tiedoston paikallisesti
- lisäksi uuden aikaleimallisen historiatiedoston jokaisesta automaattisesta backupista
- lisäksi uuden aikaleimallisen pilvitiedoston jokaisesta pilvisynkasta

Vaikka vanhoja tiedostoja siivotaan rajaan asti, kansioon kertyy silti käyttäjän näkökulmasta turhan paljon varmuuskopioita.

## Toteutettu muutos

Poistetaan aikaleima tiedostonimestä ja siirrytään kiinteään nimimalliin.

### Ehdotettu uusi nimeämislogiikka

Paikallinen:

- huoltokirja-auto-latest.json
- huoltokirja-auto-prev-1.json
- huoltokirja-auto-prev-2.json
- huoltokirja-auto-prev-3.json

Pilvi:

- huoltokirja-cloud-latest.json
- huoltokirja-cloud-prev-1.json
- huoltokirja-cloud-prev-2.json
- huoltokirja-cloud-prev-3.json

Manuaalinen vienti:

- huoltokirja-backup-latest.json

Tärkeä huomio: aikaleima säilyy edelleen JSON-sisällön createdAt-kentässä, joten tiedostonimestä ei tarvitse enää lukea aikaa.

### Ehdotettu kirjoitusstrategia

Käytön aikana:

1. uusi sisältö kirjoitetaan vain paikalliseen latest-tiedostoon

Lopetuksen tai taustalle siirtymisen yhteydessä:

1. paikallinen latest kopioidaan pilveen
2. pilven nykyinen latest siirretään nimeen prev-1
3. prev-1 siirretään nimeen prev-2
4. prev-2 siirretään nimeen prev-3
5. uusi sisältö kirjoitetaan pilven latest-tiedostoon

Näin käytössä on pieni kiertävä historia ilman, että uusia tiedostonimiä syntyy loputtomasti, ja normaali käyttö pysyy kevyenä.

### Miksi tämä on parempi

- tiedostojen määrä pysyy aidosti pienenä
- normaalin käytön aikana kirjoitus pysyy kevyenä, koska päivitetään vain paikallinen latest
- käyttäjä näkee heti mikä on uusin versio
- restore ei ole sidottu aikaleiman parsintaan tiedostonimestä
- pilvikansio pysyy siistimpänä
- sama malli toimii paikalliselle, pilvelle ja manuaaliselle viennille
- manuaalinen vienti voidaan toteuttaa selkeästi kaksivaiheisena: ensin paikallinen kopio, sitten vienti valittuun pilvikansioon

## Toteutusjärjestys, jolla muutos tehtiin

Kun varsinainen muutos tehdään, toteutus kannattaa tehdä tässä järjestyksessä:

1. muuta käytönaikainen automaattinen backup tallentamaan vain paikallinen latest
2. tee pilvisynkasta lopetuksen yhteydessä kiertävä latest + prev-1 ... prev-3 -malli
3. säilytä latest aina uusimmalle tiedostolle
4. pidä createdAt edelleen backup-payloadissa ennallaan
5. päivitä testit vastaamaan uutta nimeämismallia

## Rajaus

- restore-logiikan perusrakenne säilyy ennallaan
- käyttöliittymää ei laajennettu tämän muutoksen ulkopuolelle
- pilvi-integraatio on edelleen tiedostopohjainen ilman erillistä palvelinrajapintaa
