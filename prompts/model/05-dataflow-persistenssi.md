Analysoi nykyinen datavirta mallista tallennukseen.

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
4) Laadi "as-is" datarakennedokumentti migration pohjaksi SQLiteen.

Tuota seuraavat osiot:
- Current data lifecycle
- Persisted vs non-persisted map
- Migration considerations
- Open questions before SQLite schema

Ala toteuta migraatiota tassa vaiheessa.
