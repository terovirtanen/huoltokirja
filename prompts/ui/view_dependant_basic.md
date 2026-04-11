# view_dependant_basic.xml

Layout: `UpKeep-Android/Resources/layout/view_dependant_basic.xml`
Kayttopaikka: `UpKeep-Android/ViewDependant/ViewDependantBasic.cs`

## Elementit ja kentat
1. `editDependantName` (`AppCompatEditText`)
- Rooli: riippuvaisen nimi.
- Luku: `ElementSet` <- `mDependant.Name`.
- Tallennus: `ElementSave` -> `mDependant.Name`.

2. `editDependantTag` (`AppCompatEditText`)
- Rooli: tagit merkkijonona.
- Luku: `ElementSet` <- `mDependant.TagsString`.
- Tallennus: `ElementSave` -> `mDependant.TagsString`.

3. `editDependantUnit` (`AppCompatSpinner`)
- Rooli: laskuriyksikko.
- Data: `Constansts.CounterUnits` array adapterilla.
- Luku: `ElementSet` valitsee indeksin `mDependant.CounterUnit` mukaan.
- Tallennus: `ElementSave` -> `mDependant.CounterUnit = SelectedItem.ToString()`.

## Datakytkenta ja flow
- `NewInstance` vastaanottaa riippuvaisen ja tallettaa staattiseen `mDependant`-kenttaan.
- `OnCreateView` alustaa kentat.
- Tallennus tapahtuu `OnDestroyView` ja `OnDialogClose` yhteydessa.

## Havaitut puutteet
- Pakollisia kenttia ei validoida.
- Tallennus nojaa lifecycle-eventtiin ilman explicit save-toimintoa.
- Staattinen `mDependant` kasvattaa tilavuotoriskia.

## Riskit
- Muutokset voivat menna vaaraan olioon fragmentin uudelleenluonnissa.
- Tyhjat tai virheelliset arvot voivat tallentua suoraan malliin.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Lisaa syotekenttien validointi.
2. Selkeyta tallennuksen ajankohta UI:ssa.
3. Korvaa staattinen kentta argumentti/ID-pohjaisella mallilla.
