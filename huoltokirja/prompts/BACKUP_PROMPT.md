# Flutter backup prompt

## Tavoite

Toteuta sovellukseen **automaattinen varmuuskopiointi** siten, että:

- paikallinen `sqflite` säilyy päätietolähteenä
- varmuuskopio voidaan tehdä **automaattisesti**
- oletuksena käytetään **laitteen omaa pilvipalvelua**
- käyttäjä voi vaihtoehtoisesti valita myös **Jottacloudin**
- ratkaisu toimii mahdollisimman hyvin myös offline-tilassa

## Periaatteet

- Sovellus on edelleen **offline-first**.
- Kaikki varsinainen käyttödata tallennetaan ensin paikalliseen SQLite-tietokantaan.
- Pilvi toimii vähintään **varmuuskopiona**, ei pakollisena ensisijaisena tietolähteenä.
- Ensimmäinen toteutus tehdään niin, että se on turvallinen, palautettava ja laajennettavissa myöhemmin oikeaksi synkaksi.

## Vaiheittainen toteutussuunnitelma

### Vaihe 1: määrittele backup-arkkitehtuuri

Luo backupille selkeä rakenne ja vastuut.

#### Uudet osat

- `backup_service.dart`
- `backup_models.dart`
- tarvittaessa `backup_repository.dart`
- `backup_settings_controller.dart`

#### Vastuut

- lukea kaikki sovelluksen tiedot repositorioista
- muodostaa niistä yksi varmuuskopio-olio
- serialisoida varmuuskopio JSON-muotoon
- tallentaa tai lähettää backup valittuun kohteeseen
- palauttaa varmuuskopio takaisin tietokantaan

### Vaihe 2: määrittele backupin tietosisältö

Varmuuskopio sisältää vähintään:

- `schemaVersion`
- `createdAt`
- `appVersion`
- `dependants`
- `notes`
- `schedulers`
- mahdollisesti myös tulevaisuudessa asetuksia

#### Muoto

Käytä alkuun selkeää **JSON**-rakennetta.

Esimerkiksi:

```json
{
  "schemaVersion": 1,
  "createdAt": "2026-04-11T10:00:00Z",
  "appVersion": "1.0.0",
  "dependants": [],
  "notes": [],
  "schedulers": []
}
```

### Vaihe 3: toteuta manuaalinen backup ja restore ensin

Ennen automatiikkaa tee perustoiminnot valmiiksi:

- `Vie varmuuskopio`
- `Palauta varmuuskopio`

#### Vaatimukset

- backup kirjoitetaan tiedostoksi
- tiedosto voidaan jakaa tai tallentaa käyttäjän valitsemaan sijaintiin
- restore lukee tiedoston, validoi sisällön ja palauttaa datan paikalliseen tietokantaan

#### Ensimmäinen restore-strategia

- MVP: **korvaa kaikki nykyiset tiedot** varmuuskopion tiedoilla
- näytä aina vahvistus ennen palautusta

### Vaihe 4: lisää automaattinen backup-paikallislogiikka

Kun manuaalinen backup toimii, lisää automaattinen ajaminen.

#### Backup triggereitä

Automaattinen backup tehdään ainakin seuraavissa tilanteissa:

- kun sovellus siirtyy taustalle
- kun sovellus suljetaan
- kun käyttäjä on tehnyt muutoksia dataan
- enintään esimerkiksi kerran vuorokaudessa automaattisesti

#### Tärkeä vaatimus

Älä tee backupia jokaisesta yksittäisestä muutoksesta heti.
Käytä esimerkiksi **debouncea** tai jonotusta, jotta useat muutokset yhdistetään yhdeksi backupiksi.

Esimerkki:

- käyttäjä lisää kohteen
- muokkaa muistiinpanoa
- lisää ajastuksen
- tehdään lopulta yksi backup 10–30 sekunnin sisällä muutoksista

### Vaihe 5: oletusbackup laitteen omaan pilveen

Toteuta oletuskohteeksi laitteen pilvipohjainen tiedostoympäristö.

#### iOS

- hyödynnä Files/iCloud-yhteensopivaa tallennusta
- varmista, että backup voidaan tallentaa iCloud Drive -sijaintiin tai sovelluksen backupkelpoiseen dataan

#### Android

- hyödynnä järjestelmän tiedostonvalitsinta ja dokumenttipuuta
- mahdollista tallennus järjestelmän tarjoamaan pilvisijaintiin, esimerkiksi Drive-yhteensopivaan kohteeseen

#### Käyttäjäkokemus

- oletuksena sovellus käyttää laitteen oletusratkaisua
- käyttäjän ei tarvitse heti ymmärtää teknisiä yksityiskohtia

### Vaihe 6: lisää vaihtoehtoinen backup-kohde Jottacloud

Ratkaisu pitää suunnitella niin, että backup-kohteita voi olla useita.

Luo esimerkiksi abstraktio:

- `BackupDestination`
  - `DeviceCloudBackupDestination`
  - `JottacloudBackupDestination`

#### Ensimmäinen Jottacloud-taso

- käyttäjä voi valita Jottacloudin backup-kohteeksi
- jos suora API-integraatio ei ole vielä valmis, toteuta vähintään yhteensopiva tiedostovienti/palautuspolku

#### Täysi automaattinen Jottacloud-tuki

Tätä varten tarvitaan myöhemmin:

- Jottacloud-käyttäjätunnistus
- OAuth / access token -hallinta
- tiedoston upload/download API
- virheenkäsittely ja uudelleenyritys

### Vaihe 7: lisää asetukset käyttäjälle

Tee sovellukseen backup-asetukset.

#### Asetukset

- `Automaattinen varmuuskopiointi` on/off
- `Varmuuskopion kohde`
  - laitteen pilvi
  - Jottacloud
- `Vain Wi‑Fi-yhteydellä` on/off
- `Säilytettävien varmuuskopioiden määrä`
- `Viimeisin onnistunut varmuuskopio`
- `Varmuuskopioi nyt`

### Vaihe 8: huomioi taustasuoritus mobiilissa

Automaattinen backup ei voi mobiilissa toimia täysin rajattomasti taustalla.

Siksi toteuta tämä realistisesti:

- ensisijaisesti backup tehdään, kun sovellus on aktiivinen tai siirtyy taustalle
- käytä tarvittaessa taustatyökirjastoa kuten `workmanager`
- huomioi iOS- ja Android-rajoitukset
- älä oleta, että upload voidaan tehdä milloin tahansa ilman käyttöjärjestelmän ehtoja

### Vaihe 9: varmista palautettavuus ja eheys

Backup ei saa olla vain tiedosto, vaan sen on oltava myös turvallisesti palautettavissa.

#### Tee vähintään nämä tarkistukset

- tarkista `schemaVersion`
- tarkista JSON-rakenne
- tarkista pakolliset kentät
- estä osittain rikkinäisen backupin palautus
- näytä käyttäjälle virheilmoitus, jos backup ei ole kelvollinen

#### Lisäparannukset myöhemmin

- checksum tai hash
- salattu backup
- useampi historiallinen backup-versio

### Vaihe 10: toteuta backupin kierto ja siivous

Jotta pilvi ei täyty turhaan, hallitse vanhoja varmuuskopioita.

#### Suositus

- säilytä esimerkiksi viimeiset 10 onnistunutta backupia
- poista vanhimmat automaattisesti
- merkitse uusimmat selkeästi aikaleimalla

Tiedostonimi voi olla esimerkiksi:

- `huoltokirja-backup-2026-04-11T10-30-00.json`

### Vaihe 11: lisää käyttöönotto käyttöliittymään

Lisää valikkoon tai asetuksiin:

- `Varmuuskopioi nyt`
- `Palauta varmuuskopio`
- `Automaattinen varmuuskopiointi`
- `Varmuuskopion kohde`
- `Viimeisin varmuuskopio` -tila

Näytä myös käyttäjälle yksinkertainen tila:

- onnistui
- epäonnistui
- odottaa verkkoyhteyttä
- viimeisin backup päivämäärällä

### Vaihe 12: testaus

Kirjoita testit vähintään seuraaville:

- backup JSON muodostuu oikein
- restore palauttaa datan oikein
- rikkinäinen backup hylätään
- automaattinen backup ei laukea liian usein
- Jottacloud-kohde voidaan valita asetuksista
- laitteen oletusbackup toimii oletuspolkuna

## Toteutusjärjestys

Tee ominaisuus tässä järjestyksessä:

1. backup-datamalli
2. JSON export
3. JSON import / restore
4. manuaaliset UI-toiminnot
5. automaattinen backup triggeröinti
6. backup-asetukset
7. laitteen oletuspilvi oletuskohteeksi
8. Jottacloud vaihtoehtoiseksi kohteeksi
9. taustatyöt ja retry-logiikka
10. laajempi validointi ja siivous

## Rajaus MVP-versioon

Ensimmäisessä toimivassa versiossa riittää, että:

- backup tehdään automaattisesti paikallisen datan muutosten jälkeen
- backup tallennetaan tiedostoksi
- käyttäjä voi käyttää laitteen omaa pilveä oletuksena
- Jottacloud on valittavissa vähintään yhteensopivan tiedostopolun kautta
- restore toimii turvallisesti

## Ei tehdä vielä, ellei erikseen pyydetä

- täyttä kaksisuuntaista reaaliaikaista synkkaa
- monimutkaista konfliktinratkaisua eri laitteiden välillä
- täydellistä online-first arkkitehtuuria
- raskasta palvelinpuolta ilman erillistä tarvetta

## Tarkistus

- `flutter analyze`
- `flutter test`
- testaa iOS-simulaattorilla ja Android-emulaattorilla
- testaa backupin vienti, palautus ja automaattinen triggeröinti käytännössä
