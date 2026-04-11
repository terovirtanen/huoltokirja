# activity_dependant.xml

Layout: `UpKeep-Android/Resources/layout/activity_dependant.xml`
Kayttopaikka: `UpKeep-Android/ViewDependant/DependantActivity.cs`

## Elementit ja kentat
1. `textDependantActivity` (`TextView`)
- Rooli: nayttaa valitun dependantin otsikko.
- Koodikytkenta: loytyy kommentoituna, aktiivinen asetus puuttuu.

2. `buttonAddNote` (`Button`)
- Teksti: `Lisaa Note`.
- Koodikytkenta: avaa `DialogNoteAddSelector`.

3. `buttonDependantFinish` (`Button`)
- Teksti: `X`.
- Koodikytkenta: `Finish()`.

4. `dependantTabLayout` (`TabLayout`)
- Tab-tekstit: `Basic`, `Notes`, `Schedules` (kovakoodattu strategiassa).

5. `dependantViewPager` (`ViewPager2`)
- Adapteri: `DependantActivityAdapter(itemCount: 3)`.
- Fragmentit: `ViewDependantBasic`, `ViewDependantNote`, `ViewDependantScheduler`.

## Datakytkenta ja flow
- `selectedDependantName` luetaan intentista.
- `mDependant` haetaan DataManagerista nimen perusteella.
- `mDependant` syotetaan adapterille ja edelleen fragmenttien `NewInstance`-kutsuihin.

## Havaitut puutteet
- Otsikkoa ei paivitetä valitun dependantin nimella.
- `dependantViewPager` korkeudella `wrap_content` voi clipata sisaltoa.
- `ActivityResultReceived` sisalto on kommentoitu, refresh-flow osin keskenerainen.

## Riskit
- Null-riski jos intent extra puuttuu tai riippuvaista ei loydy.
- Schedules-tab on UI:ssa mutta toteutus on placeholder.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Aseta otsikko `mDependant.Name` arvolla.
2. Vahvista null-guardit intent-hakuun.
3. Ota refresh-kaytos valmiiksi kaikissa alitabeissa.
