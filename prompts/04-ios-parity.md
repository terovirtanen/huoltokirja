Tee iOS-projektiin (Upkeep-iOS) toiminnallinen parity Androidin kanssa.

Tavoite:
- Samat ydintoiminnot iOS:lle:
  - dependant-lista
  - dependant detail
  - muistiinpanot (lisäys/listaus)
  - aikataulut (lisäys/listaus)
- Data tulee samasta UpkeepBase NoSQL-toteutuksesta

Tee nyt:
1) Vertaa Android flow vs iOS flow ja listaa puuttuvat iOS-toiminnot
2) Toteuta puuttuvat näkymät/controllerit iOS-projektiin
3) Kytke iOS käyttöliittymä DataManager/repository-kerrokseen
4) Lisää perusvalidoinnit ja käyttäjäpalautteet (alertit)
5) Varmista, että iOS-käynnistys toimii ilman runtime-poikkeuksia

Anna lopuksi:
- muokatut tiedostot
- mitä parity-puutteita jäi jäljelle (jos jäi)
- askel askeleelta testiohje iOS-simulaattorille
