# view_list_dependant.xml

Layout: `UpKeep-Android/Resources/layout/view_list_dependant.xml`
Kayttopaikka: `UpKeep-Android/ViewMain/ViewDependantList.cs`

## Elementit ja kentat
1. `dependantSpinner` (`AppCompatSpinner`)
- Rooli: riippuvaisen valinta.
- Data: `dataManager.GetDependantList().Items.Select(x => x.Name)`.
- Event: `spinner_ItemSelected` -> paivittaa listan valinnan mukaan.

2. `buttonAddDependant` (`Button`)
- Teksti: `Add`.
- Toiminto: avaa `DependantActivity` valitulle riippuvaiselle.

3. `dependantText` (`TextView`)
- Rooli: nayttaa valitun riippuvaisen `CounterEstimate` arvon.
- Data: `mDependantItem.CalculateCounterEstimate()` -> `mDependantItem.CounterEstimate`.

4. `dependantlistview` (`ListView`)
- Adapteri: `DependantListAdapter`.
- Item-kentat: note title/description/hash.
- Item click: avaa note-editorin (`NoteActivity`) valitulle notelle.

## Datakytkenta ja flow
- `OnCreateView` lataa DataManagerin applikaatiosta.
- Ensimmainen riippuvainen valitaan `dependants.FirstOrDefault()` arvolla.
- `RefresfListViewData` hakee valitun riippuvaisen ja rakentaa notes-listan.
- `OnDialogClose` paivittaa spinnerin datan uudelleen.

## Havaitut puutteet
- `Where(...).First()` aiheuttaa kaatumisriskin jos nimea ei loydy.
- `FirstOrDefault()` tulos voi olla null ensivalinnassa.
- Toast naytetaan jokaisesta spinner-vaihdosta.
- Empty-state puuttuu kun riippuvaisia tai noteja ei ole.

## Riskit
- Crash-riski tyhjalla datalla.
- Virheellinen noten avaus jos state ei paivity synkassa.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Korvaa `First()` turvatulla haulla.
2. Lisaa empty-state spinnerille ja listalle.
3. Poista ylimaaraiset toastit tai tee niista debug-only.
