Toimi seniori domain-arkkitehtina ja analysoi nykyinen UpkeepBase mallikerros uuden Flutter + SQLite -toteutuksen lahdevaatimuksena.

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
5) Nosta esiin, miten kentat kannattaa ajatella Dart-domain-malleissa.

Tulosta taulukkona:
- Entity
- Field
- Type
- Persisted/Computed/Transient
- Notes

Ala muuta koodia. Tee vain analyysi, joka auttaa toteuttamaan vastaavan domainin uudelleen Dartilla.
