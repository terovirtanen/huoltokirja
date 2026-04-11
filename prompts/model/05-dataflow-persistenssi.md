Analysoi nykyinen datavirta mallista tallennukseen niin, että sen pohjalta voidaan suunnitella uusi Flutter + SQLite -persistenssi.

Kohde:
- `UpkeepBase/Data/DataManager.cs`
- `UpkeepBase/Data/TestData.cs`
- `UpkeepBase/Data/StorageManager.cs`
- `UpkeepBase/Model/**`

Tehtava:
1) Kuvaa dataflow:
   - startup
   - testidatan lisays
   - muistissa oleva data
   - JSON serialisointi/deserialisointi
2) Mihin kenttiin/tyyppeihin persistenssi vaikuttaa?
3) Mitka osat eivat pysy (JsonIgnore, static, runtime state)?
4) Laadi "as-is" datarakennedokumentti migration ja uuden SQLite-skeeman pohjaksi.

Tuota seuraavat osiot:
- Current data lifecycle
- Persisted vs non-persisted map
- Migration considerations
- Open questions before Flutter SQLite schema

Ala toteuta migraatiota tassa vaiheessa. Tuota vain analyysi uuden Flutter-toteutuksen syotteeksi.
