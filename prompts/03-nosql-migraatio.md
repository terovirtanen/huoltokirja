Toteuta datakerroksen migraatio JSON-tiedostosta NoSQL-tietokantaan säilyttäen domain-mallit.

Nykytila:
- UpkeepBase/Data/DataManager.cs käyttää in-memory + testidataa
- UpkeepBase/Data/StorageManager.cs kirjoittaa/lukee storage.json (Newtonsoft)
- Domain-mallit UpkeepBase/Model alla ovat pääosin kunnossa

Tavoite:
- Korvataan JSON-pohjainen persistent storage NoSQL-ratkaisulla
- Ratkaisun tulee toimia mobiilissa (Android + iOS)

Valitse toteutus:
- ensisijaisesti SQLite-net (dokkarityylinen/NoSQL-tyylinen objektitallennus) TAI LiteDB, jos se sopii paremmin
- perustele valinta lyhyesti mobiiliyhteensopivuuden kannalta

Tee:
1) Luo selkeä repository-rajapinta (esim. IDependantRepository)
2) Toteuta NoSQL-pohjainen repository
3) Refaktoroi DataManager käyttämään repositorya
4) Lisää migraatiopolku:
   - jos vanha storage.json löytyy, lue data ja tallenna uuteen kantaan
   - merkitse migraatio tehdyksi, ettei toistu
5) Lisää virheenkäsittely ja lokitus
6) Lisää yksikkötestit UpkeepBaseTest-projektiin keskeisille operaatioille

Tärkeää:
- Älä riko olemassa olevia malleja turhaan
- Pidä muutokset mahdollisimman pieninä ja turvallisina
- Anna lopuksi komennot/testiohjeet, joilla varmistan migraation toiminnan
