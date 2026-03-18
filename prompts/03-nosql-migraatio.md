Suunnittele ja toteuta uuden Flutter-sovelluksen datakerros SQLitella nykyisen mallin pohjalta.

Nykytila:
- nykyinen .NET-ratkaisu kayttaa in-memory + JSON-lahestymista
- nykyinen model-kerros toimii vaatimusten lahteena, ei suoraan uudelleenkaytettavana koodina

Tavoite:
- uusi datakerros Flutter/Dartilla
- paikallinen tietokanta on SQLite
- Android ja iPhone kayttavat samaa SQLite-pohjaista repository-kerrosta

Tee:
1) Kay lapi `prompts/model`-kansion analyysit ja johda niista uusi SQLite-skeema.
2) Luo Dart-domain-mallit Flutter-sovellukselle.
3) Toteuta repository-rajapinnat ja SQLite-toteutus.
4) Mallinna notet ja schedulerit niin, etta polymorfinen data toimii selkeasti SQLite-rakenteessa.
5) Suunnittele tarvittaessa import-polku nykyisesta JSON-rakenteesta SQLiteen.
6) Lisaa testit keskeisille CRUD- ja mapping-operaatioille.

Rajoitteet:
- ala jatkokehita vanhaa C# DataManager/StorageManager-ratkaisua
- tee uusi toteutus Flutterin tarpeisiin alusta
- SQLite on pakollinen valinta

Lopuksi anna:
- uusi skeema tai taulurakenne
- luodut Dart-tiedostot
- testiohjeet Androidille ja iPhonelle
