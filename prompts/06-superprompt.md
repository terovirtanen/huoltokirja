Toimi lead-tason .NET/Xamarin-kehittäjänä ja vie tämä projekti valmiimmaksi vaiheittain.
Projekti on "huoltokirja" ja sisältää:
- UpKeep-Android (Android UI)
- Upkeep-iOS (iOS UI)
- UpkeepBase (domain/data)
- UpkeepBaseTest (testit)

Yleistavoite:
1) Android UI viimeistellään ensin
2) data siirretään JSON-tiedostosta mobiiliin sopivaan NoSQL-tallennukseen
3) iOS-versio saatetaan ominaisuuspariteettiin Androidin kanssa
4) lopuksi laatu, testit ja release-readiness

TARKEÄ TYÖTAPA:
- Työskentele checkpoint-mallilla: pysähdy aina vaiheen lopussa ja odota hyväksyntää ennen seuraavaa vaihetta.
- Tee muutokset pieninä, turvallisina kokonaisuuksina.
- Säilytä nykyinen arkkitehtuuri mahdollisimman pitkälle.
- Älä tee tarpeettomia massiivisia refaktorointeja.
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
- Androidin nykyiset näkymät, adapterit, activityt
- UpkeepBase datavirta (DataManager, StorageManager, modelit)
- iOS:n nykyinen toteutuksen taso
- testien nykytila

Tuota:
1) "Current State" -yhteenveto
2) priorisoitu puutelista (High/Medium/Low)
3) toteutussuunnitelma 4-6 pienessä PR:ssä
4) hyväksyntäkriteerit per vaihe

PYSÄHDY CHECKPOINT 0:aan ja odota hyväksyntä.

========================================
VAIHE 1: Android UI valmiimmaksi
========================================
Toteuta Androidiin käytettävyyden kannalta tärkeimmät puutteet:
- listojen päivitys luotettavasti datan muuttuessa
- empty state -näkymät
- virhetilaviestit (selkeät)
- perus loading/odotustila siellä missä tarpeen
- null-checkit ja crash-riskien minimointi
- pienet XML/layout-parannukset ilman designin rikkomista

Tekniset odotukset:
- pidä muutokset kohdistettuina olemassa oleviin tiedostoihin
- älä vaihda teknologiaa
- lisää vain tarpeelliset kommentit monimutkaisiin kohtiin

Tuota:
- diff-tyylinen muutoslista tiedostoittain
- manuaalinen Android-testiskripti (askel askeleelta)
- jäljelle jääneet Android-puutteet

PYSÄHDY CHECKPOINT 1:een ja odota hyväksyntä.

========================================
VAIHE 2: JSON -> NoSQL migraatio (mobiiliyhteensopiva)
========================================
Nykyinen tila:
- StorageManager käyttää storage.json (Newtonsoft)
- DataManager käyttää in-memory + testidataa
- domain-mallit ovat pääosin ok

Tavoite:
- siirrä persistent data NoSQL-tyyliseen mobiilitallennukseen
- ensisijainen vaihtoehto: SQLite-net (objektitallennus), ellei vahva syy muuhun

Toteuta:
1) repository-abstraktio (esim. IDependantRepository)
2) NoSQL/SQLite-pohjainen toteutus
3) DataManager käyttämään repositorya
4) migraatiopolku:
   - jos storage.json löytyy, lue vanha data ja tallenna uuteen kantaan
   - migraatio ajetaan vain kerran (idempotentti)
5) virheenkäsittely + kevyt lokitus
6) yksikkötestit tärkeimmille CRUD- ja migraatiopoluille

Rajoitteet:
- älä riko domain-malleja turhaan
- pidä API-käytös taaksepäin yhteensopivana mahdollisuuksien mukaan

Tuota:
- arkkitehtuurikuvaus ennen/jälkeen (lyhyt)
- testiohjeet migraation varmistamiseen
- riskit datan eheyden osalta

PYSÄHDY CHECKPOINT 2:een ja odota hyväksyntä.

========================================
VAIHE 3: iOS parity Androidin kanssa
========================================
Tee iOS:lle samat ydinominaisuudet kuin Androidissa:
- dependant-lista
- dependant detail
- muistiinpanot (listaus + lisäys)
- aikataulut (listaus + lisäys)

Toteuta:
1) gap-analyysi Android vs iOS
2) puuttuvat iOS-näkymät/controllerit
3) kytkenta samaan UpkeepBase datakerrokseen
4) validoinnit + käyttäjäpalautteet (alertit)
5) käynnistyksen ja perusnavigaation runtime-vakaus

Tuota:
- parity-matriisi (feature by feature: Done/Partial/Missing)
- iOS manuaalinen testiskripti simulaattorille
- lista jäljellä olevista puutteista

PYSÄHDY CHECKPOINT 3:een ja odota hyväksyntä.

========================================
VAIHE 4: Laatu, testit ja release readiness
========================================
Tee viimeistely:
1) lisää testit kriittisiin kohtiin:
   - repository CRUD
   - migraatio
   - tärkeät domain edge caset
2) varmista buildit (Android/iOS + testiprojekti)
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
- path/to/file.cs: mitä ja miksi

## Validation
- build/test/manual steps
- outcome

## Risks / Open questions
- ...

## Ready for next checkpoint?
- Ehdotus: Proceed / Hold (perustelu)
