Toimi lead-tason Flutter-kehittajana ja viimeistele projekti julkaisuvalmiimmaksi.

Lahdeoletus:
- `07-flutter-project-bootstrap.md` on toteutettu
- `08-flutter-domain-implementation.md` on toteutettu
- `09-flutter-ui-data-binding.md` on toteutettu
- sovellus toimii jo kaytannossa Androidilla ja iPhonella SQLite-datalla

Tavoite tassa vaiheessa:
- viimeistele laatu, testaus, vakaus ja julkaisuvalmius
- varmista, että Flutter-sovellus on hallittavasti vietavissa seuraavaan sprinttiin tai julkaisuun

Pakolliset vaatimukset:
- Android + iPhone tuki
- SQLite toimii luotettavasti
- testit kattavat kriittiset kayttotapaukset
- release readiness dokumentoitu

========================================
TEHTAVA
========================================
Toteuta seuraavat:

1) Testaus kuntoon
- unit testit domain-logiikalle
- repository testit SQLite-kerrokselle
- widget testit kriittisille naymille
- integration testit keskeisille end-to-end floeille

2) Vakaus ja virheenkasittely
- tarkista startup flow
- tarkista SQLite init / migration behavior
- tarkista tyhjatilat ja virhepolut
- tarkista mahdolliset crash-riskit

3) Alustakohtainen release-polish
- Android package/app id tarkistus
- iOS bundle id tarkistus
- icon/splash asetukset
- permissions tarkistus
- build configuration tarkistus

4) Tekninen dokumentointi
- known issues
- technical debt
- release checklist
- next sprint backlog

5) Build ja run validointi
- varmista että app buildaa Androidille
- varmista että app buildaa iPhonelle
- varmista että testit ajettavissa

========================================
RAJOITTEET
========================================
- Ala tee suuria arkkitehtuurimuutoksia tassa vaiheessa ilman pakottavaa syyta.
- Keskity stabilointiin, testaukseen ja julkaisukelpoisuuteen.
- Jos huomaat vakavan rakenneongelman, dokumentoi se selkeasti ja korjaa vain jos se on release blocker.

========================================
TULOSTE
========================================
Haluan lopuksi seuraavat osiot:

# 1) Release Readiness Summary
- onko projekti lahella julkaisua vai ei
- lyhyt perustelu

# 2) Testing Coverage
- mita testejä lisattiin
- mita ajettiin
- mita jäi kattamatta

# 3) Stability Findings
- High / Medium / Low -riskit
- mahdolliset release blockerit

# 4) Files Created or Updated
- tiedostoittain mita tehtiin ja miksi

# 5) Validation
- build/run/test komennot
- Android ja iPhone tarkistuspolut

# 6) Next Actions
- mita kannattaa tehdä ennen julkaisua
- mita voi siirtää seuraavaan sprinttiin
