Toteuta Android UI valmiimmaksi nykyiseen Xamarin-projektiin ilman että rikot olemassa olevaa rakennetta.

Konteksti:
- Projekti: UpKeep-Android
- Nykyinen adapteri esim. MainListAdapter.cs on olemassa
- Tarkoitus on saada käytettävä lista- ja detail-näkymä riippuvaisille (dependant), muistiinpanoille ja aikatauluille

Tee nyt:
1) Käy läpi Androidin näkymät, adapterit ja activityt
2) Korjaa UX- ja käytettävyysongelmat:
   - tyhjät tilat (empty states)
   - virheilmoitukset
   - lataus-/odotustila tarvittaessa
   - listan päivitys, kun data muuttuu
3) Yhdenmukaista nimeämistä ja UI-flowta mahdollisimman vähän invasiivisesti
4) Lisää puuttuvat null-checkit ja crash-suojat kriittisiin kohtiin
5) Lisää tarvittaessa pienet layout-parannukset XML-tiedostoihin

Rajoitteet:
- Säilytä nykyinen arkkitehtuuri niin pitkälle kuin mahdollista
- Tee muutokset vaiheittain ja perustele lyhyesti
- Näytä aina:
  - mitä tiedostoja muutit
  - miksi
  - miten testaan manuaalisesti Androidilla

Lopuksi anna "Done/Next" -lista seuraavaan vaiheeseen.
