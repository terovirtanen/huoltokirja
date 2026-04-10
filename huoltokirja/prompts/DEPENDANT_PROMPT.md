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
  - `tag` (vapaavalintainen tekstikenttä)
- `usage` tarkoittaa ryhmästä riippuen joko ajokilometrejä tai käyttötunteja.
- `tag` voi sisältää yhden tai useamman sanan.
- Tagien sanojen erottimena toimii joko tyhjämerkki tai pilkku.

### Tagit ja filtteröinti pääsivulla

- Kohteelle voi antaa vapaan `tag`-kentän jo luonti- ja muokkausnäkymässä.
- Pääsivun vasempaan alareunaan lisätään filtteröintipainike.
- Filtteri toimii kummassakin pääsivun näkymässä, eli:
  - kohdelistassa
  - notes-/muistiinpanonäkymässä
- Filtteristä voidaan valita yksi tai useampi tagi.
- Valinnat muodostetaan hakemalla kaikkien kohteiden `tag`-kentistä yksittäiset sanat.
- Jos useammassa kohteessa on sama tagisana, se näytetään filtterissä vain kerran.
- Filtterissä pitää voida valita yksittäisiä sanoja monivalintana.
- Jos mitään tagia ei ole valittuna, näytetään kaikki kohteet.
- Jos tageja on valittuna, näytetään vain ne kohteet, joilla on vähintään yksi valituista tageista.
- Sama aktiivinen filtterivalinta vaikuttaa molempiin pääsivun näkymiin yhtenäisesti.

### Pääsivun kohdelista

- Pääsivun kohdelistalla ei enää näytetä `id`-tietoa.
- Pääsivun kohdelistalla ei enää näytetä ryhmän nimeä tekstinä.
- Ryhmä ilmaistaan vain kuvakkeella.
- `id`- ja ryhmätekstin sijaan listalla näytetään kohteen `tag`-kenttä.

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

