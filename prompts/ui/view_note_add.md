# view_note_add.xml

Layout: `UpKeep-Android/Resources/layout/view_note_add.xml`
Kayttopaikka: `UpKeep-Android/ViewDependant/NoteAddDialogFragment.cs`

## Elementit ja kentat
1. `noteParentLinearLayout` (`LinearLayout`)
- Rooli: parent-container.

2. `noteNewRadioButton` (`RadioButton`)
- Teksti: `New Note`.
- Koodikytkenta: ei loytynyt aktiivista luku/tallennuslogiikkaa.

## Datakytkenta ja flow
- `NoteAddDialogFragment.OnCreateView` inflatoi taman layoutin.
- Sama metodi hakee `buttonDependantOK`-nappia, jota layoutissa ei ole.

## Havaitut puutteet
- Layout ja fragmenttikoodi eivat vastaa toisiaan.
- Dialogi ei sisalla minimikenttia noten luontiin (title/date/type).

## Riskit
- Null reference -virhe, jos fragmenttipolku suoritetaan.
- Legacy-koodi voi sekoittaa aktiivisen note-add-flow:n analyysia.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Paata poistetaanko vai viimeistellaanko tama polku.
2. Jos sailyy: yhdenmukaista kontrolli-ID:t ja fragmenttikoodi.
