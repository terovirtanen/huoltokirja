# Flutter dependant prompt

## Tavoite

Toteuta kohteen luonti, muokkaus, tallennus ja listaus johdonmukaisesti Flutter-sovelluksessa.

## Vaatimukset

- Kohde voi kuulua ryhmään, joka määrittää sille lisämääreitä.
- Kohteen ei ole pakko kuulua mihinkään ryhmään
- Ryhmä tallennetaan datamalliin kenttään `dependantGroup`.
- `dependantGroup` on vakioitu arvo tai enum, esimerkiksi:
  - `vehicle`
  - `workMachine`
  - `device`
  - `animal`
- UI:ssa näytetään lokalisoitu nimi, mutta tallennuksessa käytetään teknistä arvoa.
- Toistaiseksi ryhmät ovat ennakolta määriteltyjä. Jatkossa käyttäjä voi mahdollisesti luoda omia ryhmiä.
- Ryhmä asetetaan kohdetta luotaessa, eikä sitä voi vaihtaa myöhemmin.
- Ryhmän lisämääreitä voi kuitenkin muokata myöhemmin.

### Ryhmät ja lisämääreet

- `Ajoneuvo`
  - ajokilometrit (valinnainen)
  - käyttöönotto pvm (valinnainen)
- `Työkone`
  - käyttötunnit (valinnainen)
  - käyttöönotto pvm (valinnainen)
- `Laite`
  - käyttöönotto pvm (valinnainen)
- `Eläin`
  - syntymäaika (valinnainen)

### Datamalli

- Lisämääreitä varten kohteella on kentät:
  - `initialYear` (päivämäärä)
  - `usage` (float)
- `usage` tarkoittaa ryhmästä riippuen joko ajokilometrejä tai käyttötunteja.

### Arviolukeman laskenta

- Jos kohteelle on lisätty yksi tai useampi note, jossa on päivämäärä ja km/tunti-lukema, näistä lasketaan arvio kohteen tämänhetkisestä lukemasta.
- Laskenta perustuu alkuarvoon ja noteihin tallennettuihin päivämääriin ja lukemiin.
- Näiden perusteella lasketaan päiväkohtainen nousu, jonka avulla arvioidaan tämänhetkinen lukema.
- Arviossa käytetään ensisijaisesti viimeisen vuoden dataa tai vaihtoehtoisesti vähintään kahta viimeisintä lukemaa.
- Arviolukema näytetään yhdellä tekstirivillä kohteen muokkausnäkymässä.
- Arviolukemaa ei saa muokata manuaalisesti.
- Arviolukemaa käytetään ajastuksissa, jos se on saatavilla.
- Jos noteja ei ole tai niistä puuttuu tarvittavat tiedot, arviota ei lasketa eikä näytetä. Tällöin myöskään siihen perustuvaa ajastusta ei aseteta.
- Tätä varten käytetään yhtä yhteistä metodia, jota hyödynnetään myös ajastuksissa.

## Muuta

- Poista `suhde`, sitä ei tarvita.

## Tarkistus

- `flutter analyze`
- `flutter test`

