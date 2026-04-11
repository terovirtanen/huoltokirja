Viimeistele Flutter-sovellus niin, etta sama koodipohja toimii laadukkaasti iPhonella Androidin ohella.

Tavoite:
- yksi Flutter-koodi, joka tukee:
  - dependant-listaa
  - dependant detailia
  - muistiinpanojen lisausta ja listausta
  - aikataulujen lisausta ja listausta
- sama SQLite-datakerros Androidille ja iPhonelle

Tee nyt:
1) Tunnista Android- ja iOS-kaytokokemuksen erot, jotka on huomioitava Flutter UI:ssa.
2) Paranna navigaatio, layout ja komponentit niin, etta ne tuntuvat luontevilta iPhonella.
3) Varmista, etta SQLite toimii iOS:lla ilman alustakohtaisia runtime-ongelmia.
4) Lisaa iOS-kohtaiset validoinnit, palautteet ja polish.
5) Tee parity-tarkistus Androidin vaatimuksia vasten.

Lopuksi anna:
- parity-matriisi Android vs iPhone
- iOS-simulaattorin testiohjeet
- jaljelle jaaneet alustakohtaiset puutteet
