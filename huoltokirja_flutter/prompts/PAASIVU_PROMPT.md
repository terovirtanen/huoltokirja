# Flutter pääsivu prompt

## Tavoite

Toteuta sovellukseen kaksiosainen pääsivu siten, että käyttäjä voi vaihtaa näkymää vaakasuuntaisella swipella.

## Vaatimukset

- Pääsivu jaetaan kahteen sivuun.
- Ensimmäinen sivu on nykyinen pääsivu sellaisenaan.
- Ensimmäiseen sivuun ei tehdä toiminnallisia tai visuaalisia muutoksia tämän muutoksen yhteydessä.
- Toiselle sivulle pääsee swipaamalla.
- Sivujen välillä liikkuminen pitää tuntua luonnolliselta mobiilikäytössä.
- Pääsivulla näytetään sivuindikaattori, jotta käyttäjä huomaa että näkymää voi vaihtaa swipaamalla.
- Sivuindikaattori päivittyy aktiivisen sivun mukaan.

### Toinen sivu: kaikkien kohteiden muistiinpanot

- Toisella sivulla näytetään yksi yhteinen lista kaikista kohteista.
- Lista sisältää kaikkien kohteiden muistiinpanot samassa näkymässä.
- Muistiinpanot järjestetään aikajärjestykseen siten, että uusimmat näkyvät ensin.
- Järjestyksessä käytetään muistiinpanon päivämäärää.
- Jokaisesta listan rivistä pitää käydä ilmi vähintään:
  - muistiinpanon otsikko
  - päivämäärä
  - mihin kohteeseen muistiinpano kuuluu
- Jos muistiinpanoja ei ole, näytetään selkeä tyhjätilaviesti.

### Toteutusperiaatteet

- Hyödynnä olemassa olevia note-malleja, repository-kerrosta ja lokalisointia.
- Älä riko nykyistä kohdekohtaista muistiinpanopolkuja.
- Toteutuksen pitää toimia johdonmukaisesti nykyisen Flutter-rakenteen kanssa.
- Näkyvät tekstit lokalisoidaan `lib/l10n/app_fi.arb` ja `lib/l10n/app_en.arb` -tiedostoihin tarvittaessa.

## Tarkistus

- `flutter gen-l10n`
- `flutter analyze`
- `flutter test`
