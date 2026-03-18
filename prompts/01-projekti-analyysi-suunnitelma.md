Toimi lead-tason Flutter-arkkitehtina. Projektini on ratkaisu "huoltokirja", jonka nykyinen Xamarin/.NET-koodi toimii vain vaatimusten lahteena.

Tassa vaiheessa EI muuteta vanhaa sovelluskoodia.
Tassa vaiheessa analysoidaan nykyinen ratkaisu ja laaditaan greenfield-toteutussuunnitelma uudelle Flutter-sovellukselle.

Tavoite:
- uusi toteutus alusta Flutterilla
- yksi koodipohja Androidille ja iPhonelle
- SQLite paikallisena tietokantana

Tehtava:
1) Kay lapi nykyinen Android UI, iOS-tila ja domain/data-mallit vaatimusten lahteena.
2) Tee vaiheittainen toteutussuunnitelma uudelle Flutter-sovellukselle.
3) Tunnista mitka nykyisen sovelluksen ominaisuudet, naymat ja datarakenteet on siirrettava uuteen toteutukseen.
4) Kirjoita tarvittaessa analyysitiedostoja kansioihin `prompts/ui` ja `prompts/model`, jos jokin osa tarvitsee tarkempaa spesifikaatiota.

Tulosteessa haluan:
- Current system summary
- Flutter rebuild scope
- priorisoitu ominaisuuslista
- vaiheistus 4-6 pienessa checkpointissa
- hyvaksyntakriteerit jokaiselle vaiheelle

Rajoitteet:
- ala muuta vanhan Xamarin/.NET-sovelluksen lahdekoodia
- ala tee osittaiskorjauksia vanhaan stackiin
- kasittele nykykoodia vain lahdevaatimuksena
