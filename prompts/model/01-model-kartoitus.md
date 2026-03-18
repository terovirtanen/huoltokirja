Toimi seniori .NET-arkkitehtina ja analysoi vain UpkeepBase mallikerros.

Kohde:
- `UpkeepBase/Model/**`
- `UpkeepBase/Data/DataManager.cs`
- `UpkeepBase/Data/StorageManager.cs`

Tehtava:
1) Listaa kaikki mallin paaentiteetit.
2) Listaa jokaisen entiteetin kentat (nimi, tyyppi, nullable-oletus, tarkoitus).
3) Merkitse mitka kentat ovat:
   - persisted (sarjoitetaan)
   - computed (lasketaan)
   - transient (runtime-only)
4) Kuvaa nykyinen kokonaisrakenne lyhyena domain-yhteenvetona.

Tulosta taulukkona:
- Entity
- Field
- Type
- Persisted/Computed/Transient
- Notes

Ala muuta koodia. Tee vain analyysi.
