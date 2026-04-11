Analysoi Scheduler-malli ja sen datarakenne seka laskentasannot uuden Flutter + SQLite -toteutuksen suunnittelua varten.

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
5) Kuvaa, mitkä scheduler-kentät ovat domainissa pysyviä ja mitkä kannattaa laskea ajossa Flutterissa.

Tulosta:
- kenttataulukko
- askel askeleelta algoritmikuvaus
- riskilista
- suositus datamallin dokumentointiin SQLitea varten

Ala muuta koodia.
