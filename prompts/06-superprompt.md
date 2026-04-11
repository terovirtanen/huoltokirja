Toimi lead-tason Flutter-arkkitehtina ja rakenna tama sovellus alusta uudelleen vaiheittain.
Nykyinen projekti "huoltokirja" toimii vaatimusten lahteena, ei toteutuspohjana.

Nykyinen ratkaisu sisaltaa:
- UpKeep-Android (nykyinen Android UI)
- Upkeep-iOS (nykyinen iOS-aihio)
- UpkeepBase (nykyinen domain/data)
- UpkeepBaseTest (nykyiset domain-testit)

Yleistavoite:
1) analysoi nykyjarjestelma vaatimuksina
2) toteuta uusi sovellus alusta Flutterilla
3) tue seka Androidia etta iPhonea yhdesta koodipohjasta
4) kayta SQLitea paikallisena tietokantana
5) viimeistele laatu, testit ja release-readiness

TARKEÄ TYÖTAPA:
- Työskentele checkpoint-mallilla: pysähdy aina vaiheen lopussa ja odota hyväksyntää ennen seuraavaa vaihetta.
- Tee muutokset pieninä, turvallisina kokonaisuuksina.
- Käsittele nykyistä arkkitehtuuria vain vaatimusten ja domain-logiikan lähteenä.
- Älä jatkokehitä Xamarin/.NET-koodia vaan rakenna uusi toteutus greenfieldina.
- Jokaisessa vaiheessa raportoi:
   - mitä tiedostoja muutit
   - miksi muutit
   - miten testaan tämän vaiheen
  - riskit / avoimet kysymykset
- Jos löydät blockerin, ehdota 1-2 vaihtoehtoista ratkaisua ja suositus.

========================================
VAIHE 0: Nykytilan kartoitus (ei isoja koodimuutoksia)
========================================
Tee ensin nopea analyysi:
- Androidin nykyiset näkymät vaatimusten lahteena
- UpkeepBase datamalli ja datavirta vaatimusten lahteena
- iOS:n nykyinen toiminnallinen taso ja puutteet
- mitä tästä pitää siirtää Flutter-uudelleentoteutukseen

Tuota:
1) "Current State" -yhteenveto
2) priorisoitu puutelista (High/Medium/Low)
3) toteutussuunnitelma 4-6 pienessä checkpointissa Flutter-uudelleentoteutukseen
4) hyväksyntäkriteerit per vaihe

PYSÄHDY CHECKPOINT 0:aan ja odota hyväksyntä.

========================================
VAIHE 1: Flutter UI perusrunko
========================================
Toteuta uusi UI Flutterilla nykyisten UI-analyysien pohjalta:
- paanavigaatio
- dependant-lista
- dependant detail
- note-listat ja editorit
- scheduler-nakymat
- empty state / error / loading tilat
- adaptiivinen kayttokokemus Androidille ja iPhonelle

Tekniset odotukset:
- rakenna uusi Flutter-projektirakenne vaiheittain
- ala muokkaa vanhaa Xamarin-UI:ta
- kayta nykyista UI:ta vain spesifikaationa

Tuota:
- luodut Flutter UI -tiedostot
- manuaalinen testiskripti Androidille ja iPhonelle
- jaljelle jaaneet UI-puutteet

PYSÄHDY CHECKPOINT 1:een ja odota hyväksyntä.

========================================
VAIHE 2: SQLite datakerros Flutteriin
========================================
Nykyinen tila:
- nykyinen data on kuvattu .NET-malleissa ja JSON-rakenteessa
- uusi toteutus tehdään Dart-malleilla ja SQLite-skeemalla

Tavoite:
- toteuta uusi SQLite-pohjainen data layer Flutter-sovellukselle
- Android ja iPhone kayttavat samaa repository-kerrosta

Toteuta:
1) Dart-domain-mallit nykyisen model-analyysin perusteella
2) repository-abstraktiot
3) SQLite-toteutus
4) tarvittaessa JSON-import polku nykyisesta rakenteesta SQLiteen
5) virheenkasittely + lokitus
6) testit tärkeimmille CRUD- ja mapping-poluille

Rajoitteet:
- ala jatkokehita vanhaa C# data stackia
- kayta nykyista domainia vain uuden Dart-domainin lahteena

Tuota:
- SQLite-skeema tai taulurakenne
- Flutter data layer -tiedostot
- testiohjeet Androidille ja iPhonelle
- riskit datan eheyden osalta

PYSÄHDY CHECKPOINT 2:een ja odota hyväksyntä.

========================================
VAIHE 3: Cross-platform polish iPhonelle
========================================
Varmista, että Flutter-sovellus tarjoaa samat ydintoiminnot iPhonella kuin Androidilla:
- dependant-lista
- dependant detail
- muistiinpanot (listaus + lisäys)
- aikataulut (listaus + lisäys)

Toteuta:
1) gap-analyysi Android UX vs iPhone UX
2) alusta- ja kokokohtaiset UI-parannukset Flutterissa
3) kytkenta samaan SQLite-datakerrokseen
4) validoinnit + käyttäjäpalautteet (alertit)
5) käynnistyksen ja perusnavigaation runtime-vakaus

Tuota:
- parity-matriisi (Android vs iPhone)
- iOS manuaalinen testiskripti simulaattorille
- lista jaljella olevista alustakohtaisista puutteista

PYSÄHDY CHECKPOINT 3:een ja odota hyväksyntä.

========================================
VAIHE 4: Laatu, testit ja release readiness
========================================
Tee viimeistely:
1) lisää testit kriittisiin kohtiin:
   - SQLite repository CRUD
   - model mapping
   - tärkeät domain edge caset
   - widget/integration flows
2) varmista buildit (Flutter Android/iOS + testit)
3) release-checklist:
   - versionointi
   - app-id/bundle-id
   - icon/splash
   - permissions
4) dokumentoi known issues + technical debt

Tuota:
- priorisoitu findings-lista (High/Medium/Low)
- mitä testejä ajettiin ja tulokset
- ehdotus 3 viimeistely-PR:stä

PYSÄHDY CHECKPOINT 4:ään ja odota lopullinen hyväksyntä.

========================================
RAPORTOINTIMUOTO (käytä tätä joka vaiheessa)
========================================
# Phase X Result
## What changed
- ...

## Files touched
- path/to/file.dart: mitä ja miksi

## Validation
- build/test/manual steps
- outcome

## Risks / Open questions
- ...

## Ready for next checkpoint?
- Ehdotus: Proceed / Hold (perustelu)
