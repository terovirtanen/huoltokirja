# view_note.xml

Layout: `UpKeep-Android/Resources/layout/view_note.xml`
Kayttopaikka: `UpKeep-Android/ViewNote/ViewNoteBasic.cs`

## Elementit ja kentat
1. `noteParentLinearLayout` (`LinearLayout`)
- Rooli: parent, johon service/inspection-lisakentat liitetaan dynaamisesti.

2. `noteTypeSpinner` (`AppCompatSpinner`)
- Rooli: note-tyypin valinta (oletus).
- Koodikytkenta: spinner-logiikka on kommentoitu pois.

3. `noteTitle` (`AppCompatEditText`)
- Luku: `ElementSet` <- `mNote.Title`.
- Tallennus: `ElementSave` -> `mNote.Title`.

4. `noteDate` (`AppCompatEditText`, date)
- Luku: `OnCreateView` <- `mNote.EventTime.ToShortDateString()`.
- Muokkaus: click avaa `DatePickerFragment`.
- Tallennus: `ElementSave` -> `DateTime.Parse(elementDate.Text)`.

5. `noteDescription` (`AppCompatEditText`)
- Luku: `ElementSet` <- `mNote.Description`.
- Tallennus: `ElementSave` -> `mNote.Description`.

## Dynaamiset alikentat
- Jos note tyyppi on `Inspection`: lisataan `view_note_inspection`.
- Jos note tyyppi on `Service` tai `Inspection`: lisataan `view_note_service`.

## Datakytkenta ja flow
- `mNote` tulee staattisena kenttana `NewInstance`-kutsusta.
- `OnPause` kutsuu `ElementSave`.
- `OnDialogClose` kutsuu `ElementSave`.

## Havaitut puutteet
- `noteTypeSpinner` on layoutissa mutta ei aktiivisessa kaytossa.
- Paiva- ja numeromuunnokset tehdaan ilman suojia.
- Staattinen `mNote` kasvattaa state-riskeja.

## Riskit
- Crash-riski parse-virheissa.
- Vaaran olion paivitys prosessin uudelleenluonnissa.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Ota tyyppispinner kayttoon tai poista se.
2. Lisaa `TryParse`-pohjainen validointi.
3. Korvaa staattinen note-state ID-pohjaisella haulla.
