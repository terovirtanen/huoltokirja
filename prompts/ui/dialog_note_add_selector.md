# dialog_note_add_selector.xml

Layout: `UpKeep-Android/Resources/layout/dialog_note_add_selector.xml`
Kayttopaikka: `UpKeep-Android/ViewMain/DialogNoteAddSelector.cs`

## Elementit ja kentat
1. `noteSelectorDependantSpinner` (`AppCompatSpinner`)
- Data: riippuvaisten nimet DataManagerista.
- Event: `spinner_ItemSelected` paivittaa `mSelectedDependant`.

2. `noteSelectorTypesRadioGroup` (`RadioGroup`)
- Vaihtoehdot:
	- `noteSelectorBaseRadioButton`
	- `noteSelectorServiceRadioButton`
	- `noteSelectorInspectionRadioButton`
- Toiminto: valittu tyyppi ohjaa `AddNote` / `AddService` / `AddInspection` kutsua.

3. `noteAddTitle` (`AppCompatEditText`)
- Rooli: uuden noten otsikko.
- Validointi: vain tyhja merkkijono tarkistetaan.

4. `noteAddDate` (`AppCompatEditText`)
- Rooli: paivamaara.
- Alustus: `DateTime.Now.ToString()`.
- Muokkaus: date picker clickilla.
- Tallennus: `note.EventTime = DateTime.Parse(elementDate.Text)`.

5. `noteSelectorCancelButton` (`Button`)
- Toiminto: `Dismiss()`.

6. `noteSelectorAddButton` (`Button`)
- Toiminto: luo noten, avaa `NoteActivity`, sulkee dialogin.

## Datakytkenta ja flow
- Dialogi kayttaa staattista `mContext`-kenttaa.
- `SpinnerData` lataa riippuvaiset applikaation DataManagerista.
- Luotu note asetetaan `NoteActivity.mNote`-staattikenttaan.
- Activity result launcher kaynnistaa editorin.

## Havaitut puutteet
- Useita null-polkuja ilman guardeja (spinner, radioGroup, mContext, activity).
- Date parse ilman virhekasittelya.
- Staattinen `mContext` voi aiheuttaa memory leakin.

## Riskit
- Crash-riski virheellisella syotteella tai null-kontekstilla.
- Vaikea testattavuus staattisen state-kytkennän vuoksi.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Poista staattinen context ja kayta turvallista fragment-contextia.
2. Lisaa `TryParse` + null-guardit.
3. Tee validointi kaikille pakollisille syotteille.
