# activity_note.xml

Layout: `UpKeep-Android/Resources/layout/activity_note.xml`
Kayttopaikka: `UpKeep-Android/ViewNote/NoteActivity.cs`

## Elementit ja kentat
1. `textNoteActivity` (`TextView`)
- Rooli: note-editorin otsikko.
- Koodikytkenta: loytyy kommentoituna; aktiivinen paivitys puuttuu.

2. `buttonNoteFinish` (`Button`)
- Teksti: `X`.
- Koodikytkenta: sulkee activityn (`Finish()`).

3. `noteTabLayout` (`TabLayout`)
- Tab-teksti: `Basic` (kovakoodattu).

4. `noteViewPager` (`ViewPager2`)
- Adapteri: `NoteActivityAdapter(itemCount: 1)`.
- Fragmentti: `ViewNoteBasic.NewInstance(mSelectedNote)`.

## Datakytkenta ja flow
- Note siirtyy activityyn staattisella kentalla `NoteActivity.mNote`.
- `mSelectedNote` syotetaan adapterin kautta fragmentille.

## Havaitut puutteet
- Otsikko ei nayta muokattavan noten nimea/tyyppia.
- Tallennus tapahtuu fragmentin lifecycleen sidottuna, ei explicit save actionia.
- Staattinen `mNote` luo state-riskeja.

## Riskit
- Vaaran note-olion muokkaus prosessin uudelleenluonnissa.
- Heikko kayttajakokemus, koska tallennuksen hetki ei ole selkea.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Nayta aktiivinen note otsikossa.
2. Selkeyta tallennusmalli (explicit Save tai autosave-indikaatio).
3. Korvaa staattinen state intent/ID-pohjaisella haulla.
