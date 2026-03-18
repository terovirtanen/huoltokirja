Analysoi Scheduler-malli ja sen datarakenne seka laskentasannot.

Kohde:
- `UpkeepBase/Model/Scheduler/IScheduler.cs`
- `UpkeepBase/Model/Scheduler/Scheduler.cs`
- `UpkeepBase/Model/Dependant.cs` (schedulerin kayttokohta)

Tehtava:
1) Listaa kaikki scheduler-kentat ja roolit:
   - ajoitussaannot (Annual, Biannual, Quaterly, CustomPeriodMonths)
   - counter-saannot (CounterValue, StartCounterValue)
   - lasketut kentat (NextScheduleTime, ListText)
2) Kuvaa miten `calculateNextScheduleTime()` valitsee seuraavan ajankohdan.
3) Kuvaa miten `GenerateNote()` luo noteja ja milloin silmukka pysahtyy.
4) Tunnista edge caset (puuttuva data, nolla-arvot, ristiriitaiset saannot).

Tulosta:
- kenttataulukko
- askel askeleelta algoritmikuvaus
- riskilista
- suositus datamallin dokumentointiin NoSQL:aa varten

Ala muuta koodia.
