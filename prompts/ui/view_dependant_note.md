# view_dependant_note.xml

Layout: `UpKeep-Android/Resources/layout/view_dependant_note.xml`
Kayttopaikka: `UpKeep-Android/ViewDependant/ViewDependantNote.cs`

## Elementit ja kentat
1. `buttonAddDependantNote` (`Button`)
- Teksti: `Add`.
- Koodikytkenta: click-event on olemassa, mutta runko on kommentoitu (ei toimintoa).

2. `textDependantNotes` (`TextView`)
- Rooli: varattu infotekstille.
- Koodikytkenta: ei aktiivista bindausta.

3. `listDependantNotes` (`ListView`)
- Adapteri: `DependantNotesListAdapter`.
- Item-kentat: title, description, hash.
- Item click: avaa `NoteActivity` valitulla notella.

## Datakytkenta ja flow
- `mDependant` tulee `NewInstance`-kutsusta staattisena kenttana.
- `RefresfListViewData` rakentaa listan `mDependant.NItemsOrderByDescendingByEventTime` arvosta.
- `RefreshData` paivittaa listan uudelleen.

## Havaitut puutteet
- Add-nappi ei tee mita sen teksti lupaa.
- `textDependantNotes` ei ole kaytossa.
- Empty-state ja virhetila puuttuvat.
- Staattinen state (`mDependant`) kasvattaa null/lifecycle-riskia.

## Riskit
- Kayttaja olettaa voivansa lisata noten mutta toiminto puuttuu.
- Mahdollinen kaatuminen jos `mDependant` ei ole asetettu.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Kytke Add oikeaan dialogi- tai editointiflowhun.
2. Lisaa empty-state listalle.
3. Vahenna staattista tilaa fragmentissa.
