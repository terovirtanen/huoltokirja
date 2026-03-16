# view_scheduler_timing.xml

Layout: `UpKeep-Android/Resources/layout/view_scheduler_timing.xml`
Kayttopaikka: lisataan dynaamisesti `ViewScheduler`-nakymaan.

## Elementit ja kentat
1. `schedulerCheckboxAnnually` (`AppCompatCheckBox`)
- Luku: `ElementSetTiming` <- `mScheduler.Annual`.
- Tallennus: `ElementSave` -> `mScheduler.Annual`.

2. `schedulerCheckboxBiannually` (`AppCompatCheckBox`)
- Luku: `ElementSetTiming` <- `mScheduler.Biannual`.
- Tallennus: `ElementSave` -> `mScheduler.Biannual`.

3. `schedulerCheckboxQuaterly` (`AppCompatCheckBox`)
- Luku: `ElementSetTiming` <- `mScheduler.Quaterly`.
- Tallennus: `ElementSave` -> `mScheduler.Quaterly`.

4. `schedulerMonthPeriod` (`AppCompatEditText`, number)
- Luku: `ElementSetTiming` <- `mScheduler.CustomPeriodMonths`.
- Tallennus: `Convert.ToInt32(...)` -> `mScheduler.CustomPeriodMonths`.

5. `schedulerCounterValue` (`AppCompatEditText`, numberDecimal)
- Luku: `ElementSetTiming` <- `mScheduler.CounterValue`.
- Tallennus: `Convert.ToInt32(...)` -> `mScheduler.CounterValue`.

6. `schedulerStartCounterValue` (`AppCompatEditText`)
- Luku: `ElementSetTiming` <- `mScheduler.StartCounterValue`.
- Tallennus: `Convert.ToInt32(...)` -> `mScheduler.StartCounterValue`.

7. `schedulerDate` (`AppCompatEditText`, date)
- Luku: `OnCreateView` <- `mScheduler.StartTime.ToShortDateString()`.
- Tallennus: `DateTime.Parse(elementDate.Text)` -> `mScheduler.StartTime`.

## Datakytkenta
- Kaikki kentat sitoutuvat suoraan samaan `IScheduler`-olioon ilman validointikerrosta.
- Asetukset vaikuttavat schedulerin seuraavan paivan laskentaan mallikerroksessa.

## Havaitut puutteet
- Ei syotteen validointia numeerisille kentille.
- Labelit sisaltavat kirjoitusvirheita (`Mounth`, `Quaterly`).
- Ei UI-opastusta, voiko useita saantoja valita samanaikaisesti.

## Riskit
- Virheellinen kombinaatio saannoissa voi johtaa yllattavaan ajoitukseen.
- Parse-poikkeukset voivat kaataa editorin.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Lisaa kenttakohtainen validointi ja virheviestit.
2. Yhdenmukaista termit ja kieli string-resursseihin.
3. Kuvaa saantojen prioriteetti/kombo-logiikka kayttajalle.
