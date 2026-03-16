Viimeistele ratkaisu julkaisuvalmiimmaksi Androidille ja iOS:lle.

Tee:
1) Lisää testikattavuutta kriittisiin kohtiin:
   - repository CRUD
   - migraatio storage.json -> NoSQL
   - domainin tärkeimmät edge caset
2) Tee build sanity check:
   - ratkaisu buildaa
   - testit ajettavissa
3) Tee "release readiness checklist":
   - versionumerot
   - app-id/bundle-id tarkistus
   - ikoni/splash tarkistus
   - perusoikeudet (permissions)
4) Listaa known issues + technical debt selkeästi

Tulosteeksi haluan:
- priorisoitu bugi-/riski-lista (High/Medium/Low)
- täsmällinen next sprint -työlista
- ehdotus miten tämä jaetaan 3 pieneen PR:ään
