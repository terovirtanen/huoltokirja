# Flutter scheduler prompt

## Tavoite

Toteuta kohteelle ajastetun noten luonti, muokkaus, tallennus ja listaus johdonmukaisesti Flutter-sovelluksessa.

Ajastus myös ilmoittaa käyttäjälle:
- 2 viikkoa ennen tapahtumaa
- 1 päivä ennen tapahtumaa

Note luodaan automaattisesti, kun ajankohta on 2 viikon päässä. 1 päivän ilmoitus tehdään, jos tapahtumaa ei ole päivitetty luonnin jälkeen.

## Vaatimukset

- Ilmoituksen pitäisi tulla puhelimen ilmoituslistalle myös silloin, kun sovellus ei ole käynnissä.
- Ajastukselle asetetaan alkamisajankohta, oletuksena kuluva päivä.
- Alkamisajankohtaa voi muuttaa myös myöhemmin.
- Yksi sääntö = yksi ajastus.
- Kohteella voi olla useita ajastuksia samanaikaisesti.
- Ajastukselle valitaan luotavan noten nimi ja tyyppi. Muuta tietoa ei täytetä.

### Kalenteripohjaiset säännöt

Ajastus voidaan määrittää kalenteriperusteisesti seuraavilla tavoilla:
- vuosittain
- puolivuosittain
- neljännesvuosittain
- annetun kuukausivälin mukaan

Datamallipäätös:
- kenttä `calendarIntervalMonths`
- arvot:
  - `12` = vuosittain
  - `6` = puolivuosittain
  - `3` = neljännesvuosittain
  - muu positiivinen kokonaisluku = käyttäjän asettama kk-väli
  - `null` = ei käytössä

Seuraava ajankohta lasketaan aina alkamisajankohdasta eteenpäin.

### Käyttömääräpohjaiset säännöt

Jos kohteella on lisämääre kilometrit tai tunnit, ajastukselle voi määrittää myös käyttömääräpohjaisen säännön:
- kilometri- tai tuntiväli, jonka jälkeen note luodaan
- alkuarvo (`float`), josta laskenta alkaa
- laskennassa käytetään samaa arviolukemametodia kuin kohteen tiedoissa

## Muuta

- Varmista, että ajastus toimii sekä aikaperusteisesti että käyttömääräperusteisesti ilman ristiriitoja.

## Tarkistus

- `flutter analyze`
- `flutter test`

