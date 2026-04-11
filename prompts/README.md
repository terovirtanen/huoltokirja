# Promptit: huoltokirja Flutter-uudelleentoteutukseen

Tassa kansiossa on valmiit promptit AI:lle, jotta nykyinen sovellus voidaan rakentaa alusta uudelleen eri teknologialla.

Tavoite:
- nykyinen Xamarin/.NET-koodi toimii vaatimusten lahteena
- uusi toteutus tehdaan alusta Flutterilla
- sovellus toimii seka Androidilla etta iPhonella
- paikallisena tietokantana kaytetaan SQLitea

## Ensisijainen jarjestys

Paapolku on ajaa uusi Flutter-sovellus suoraan seuraavilla prompteilla:

1. `07-flutter-project-bootstrap.md`
2. `08-flutter-domain-implementation.md`
3. `09-flutter-ui-data-binding.md`
4. `10-flutter-release-readiness.md`

## Uudelleenanalysointi tarvittaessa

Jos haluat analysoida nykyisen Xamarin/.NET-ratkaisun uudestaan ennen toteutusta, voit kayttaa myos seuraavia promptteja:

1. `01-projekti-analyysi-suunnitelma.md`
2. `02-android-ui-viimeistely.md`
3. `03-nosql-migraatio.md`
4. `04-ios-parity.md`
5. `05-laatu-release-readiness.md`
6. `06-superprompt.md`

`01-06` ovat siis hyodyllisia vain, jos haluat tehdä analyysin tai vaatimusten tarkennuksen uudelleen.

## Kayttotapa

1. Avaa haluttu tiedosto ja kopioi koko sisalto AI-keskusteluun.
2. Keraa ensin nykyjarjestelman vaatimukset nykykoodista.
3. Toteuta uusi sovellus greenfield-projektina Flutterilla vaiheittain.
4. Pyyda jokaisen vaiheen lopussa:
   - luodut/muokatut tiedostot
   - testausohjeet Androidille ja iPhonelle
   - SQLite-skeemaan liittyvat riskit

## Vinkki

Paasuositus on ajaa jarjestys `07 -> 08 -> 09 -> 10` bootstrapista julkaisuvalmiuteen.

Kayta `01-06` vain silloin, jos haluat analysoida nykyisen ratkaisun uudestaan tai tarkentaa vaatimuksia ennen toteutusta.
