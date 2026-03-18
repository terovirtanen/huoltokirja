Toimi lead-tason .NET domain-arkkitehtina. Tavoite on dokumentoida nykyinen kaytettava datarakenne huolellisesti ennen SQLite-migraatiota.

Analysoi tiedostot:
- `UpkeepBase/Model/**`
- `UpkeepBase/Data/DataManager.cs`
- `UpkeepBase/Data/TestData.cs`
- `UpkeepBase/Data/StorageManager.cs`

Rajoitteet:
- Ala muuta koodia.
- Ala ehdota viela lopullista toteutusta.
- Keskity as-is datarakenteen ymmartamiseen.

Tuota raportti tassa muodossa:

# 1) Domain Overview
- paaentiteetit ja tarkoitus

# 2) Entity Field Catalog
- jokaisesta entiteetista kentat, tyypit, persisted/computed/transient

# 3) Relationships and Ownership
- cardinality
- omistajuus
- viittaussuunnat
- staattiset rakenteet ja vaikutus

# 4) Notes Model Deep Dive
- INote/Service/Inspection erot
- enumit ja statusvirrat
- listatekstien muodostus

# 5) Scheduler Model Deep Dive
- saannot
- laskenta-algoritmi
- note-generointi
- edge caset

# 6) Serialization and Persistence Map
- mita menee JSON:iin
- mita ei mene JSON:iin
- mitka tiedot voivat kadota restartissa

# 7) SQLite Migration Input
- taulut/kokoelmat joita tarvitaan
- kentat joita ei kannata persistoida suoraan
- migration riskit (High/Medium/Low)

# 8) Deliverables
- Mermaid ER diagram
- esimerkkidata JSON-muodossa (Dependant + notes + schedulers)
- checklist: "valmis siirtymaan SQLite-suunnitteluun" (kylla/ei + perustelu)
