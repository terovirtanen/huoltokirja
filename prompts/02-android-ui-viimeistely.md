Toteuta uuden sovelluksen UI alusta Flutterilla nykyisen Android-kayttoliittyman pohjalta.

Konteksti:
- Nykyinen Android UI toimii vaatimusten lahteena
- Uusi toteutus tehdaan Flutterilla
- UI:n tulee toimia seka Androidilla etta iPhonella yhdesta koodipohjasta

Tee nyt:
1) Kay lapi `prompts/ui`-kansion analyysit ja nykyinen Android UI vaatimusten lahteena.
2) Toteuta Flutterilla vastaavat paanaymat:
  - paanavigaatio
  - dependant-lista
  - dependant detail
  - note-listat ja note-editori
  - scheduler-nakymat
3) Korjaa samalla nykyanalyysissa loydetyt UX-puutteet:
  - empty states
  - virheviestit
  - loading-tilat
  - johdonmukainen navigaatio
4) Tee UI adaptiiviseksi Androidille ja iPhonelle.
5) Pida rakenne modulaarisena niin, etta SQLite-data voidaan kytkea siihen seuraavassa vaiheessa.

Rajoitteet:
- ala muokkaa vanhaa Xamarin-UI-koodia
- rakenna uusi Flutter UI greenfieldina
- käytä nykyistä UI:ta vain speksinä, älä porttaa tiedostoja mekaanisesti

Lopuksi anna:
- luodut Flutter-tiedostot
- mitä nykyisen UI:n osia toteutit 1:1 ja mitä paransit
- manuaalinen testiskripti Androidille ja iPhonelle
