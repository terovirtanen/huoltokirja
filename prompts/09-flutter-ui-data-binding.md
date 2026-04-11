Toimi lead-tason Flutter-kehittajana ja jatka projektia domain- ja repository-vaiheen jalkeen.

Lahdeoletus:
- `07-flutter-project-bootstrap.md` on toteutettu
- `08-flutter-domain-implementation.md` on toteutettu
- Flutter-projektissa on jo:
  - kansiorakenne
  - SQLite-peruspohja
  - domain-mallit
  - repositoryt
  - placeholder-UI

Tavoite tassa vaiheessa:
- kytke UI oikeaan dataan
- tee paaflowt toimiviksi Androidilla ja iPhonella
- rakenna kayttokelpoinen MVP Flutterilla

Pakolliset vaatimukset:
- yksi Flutter-koodipohja Androidille ja iPhonelle
- SQLite on ensisijainen datalahde
- UI:n tulee seurata `prompts/ui`-analyysien ydinsisaltoa
- domainin tulee seurata `prompts/model`-analyysien rakennetta

========================================
TEHTAVA
========================================
Toteuta seuraavat:

1) State management UI:n ja datan valiin
- valitse projektiin sopiva state management ratkaisu
- perustele valinta lyhyesti
- kytke UI ja repositoryt yhteen selkeasti

2) Dependant flow valmiiksi
- dependant list screen hakee oikean datan SQLitesta
- dependant detail screen nayttaa perustiedot, notet ja schedulerit
- riippuvaisen lisaaminen/muokkaaminen toimii

3) Note flow valmiiksi
- note-lista toimii
- note editor toimii eri note-tyypeille
- service note ja inspection note toimivat oikein
- validoinnit ja virhepalautteet kuntoon

4) Scheduler flow valmiiksi
- scheduler-lista toimii
- schedulerin lisays/muokkaus toimii
- next schedule -logiikka naytetaan kayttajalle ymmarrettavasti

5) Yleinen UX kuntoon
- empty states
- loading states
- error states
- perus onnistumisfeedback
- Android + iPhone adaptiivisuus

6) Perustoimivuuden validointi
- cold start -> data latautuu SQLitesta
- create/update/delete toimii riippuvaisille, noteille ja schedulereille
- UI paivittyy oikein dataoperaatioiden jalkeen

========================================
RAJOITTEET
========================================
- Ala tee viela lopullista release-polishia.
- Ala muuta arkkitehtuuria tarpeettomasti, jos bootstrap ja domain-vaihe on jo tehty hyvin.
- Keskity nyt toimiviin kayttotapauksiin.
- Android ja iPhone ovat samanarvoiset alustat.

========================================
TULOSTE
========================================
Haluan lopuksi seuraavat osiot:

# 1) UI Data Binding Done
- mitka naymat on kytketty oikeaan dataan
- mitka kayttotapaukset toimivat end-to-end

# 2) State Management
- valittu ratkaisu
- miten state liikkuu UI:n, domainin ja repositoryiden valilla

# 3) Files Created or Updated
- tiedostoittain mita tehtiin ja miksi

# 4) Validation
- miten testasit CRUD-flowt
- miten testasit Androidin ja iPhonen peruspolut

# 5) Remaining Gaps
- mita puuttuu ennen release-vaihetta
- mika kannattaa tehdä seuraavaksi

Jos jokin UI-kayttotapa on epaselva nykyanalyysien perusteella, tee perusteltu oletus ja kerro se lopuksi.
