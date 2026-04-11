Viimeistele uusi Flutter-sovellus julkaisuvalmiimmaksi Androidille ja iPhonelle.

Tee:
1) Lisaa testikattavuutta kriittisiin kohtiin:
   - SQLite repository CRUD
   - model mapping ja serialisointi
   - scheduler- ja domain edge caset
   - widget- ja integraatiotestit keskeisille floeille
2) Tee build sanity check:
   - Flutter app buildaa Androidille
   - Flutter app buildaa iPhonelle
   - testit ajettavissa
3) Tee release readiness checklist:
   - versionointi
   - package id / bundle id
   - icon / splash
   - permissions
   - SQLite migration/init behavior cold startissa
4) Listaa known issues + technical debt selkeasti

Tulosteeksi haluan:
- priorisoitu bugi-/riski-lista (High/Medium/Low)
- tarkka next sprint -tyolista
- ehdotus miten Flutter-uudelleentoteutus jaetaan 3 pieneen PR:aan
