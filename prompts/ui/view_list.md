# view_list.xml

Layout: `UpKeep-Android/Resources/layout/view_list.xml`
Kayttopaikka: `UpKeep-Android/ViewMain/ViewList.cs`

## Elementit ja kentat
1. `mainlistview` (`ListView`)
- Rooli: nayttaa kaikkien notien koontilistan.
- Adapteri: `MainListAdapter`.
- Item-kentat: `Title`, `Description`, `ItemHashCode`.

## Datakytkenta ja flow
- `RefreshListViewData` luo `NotesList`-instanssin.
- `ConvertToMainList` mapittaa `NotesList.Items` -> `MainListItems`.
- Item click:
	- hakee note-olion hash-koodilla
	- asettaa `NoteActivity.mNote`
	- kaynnistaa `NoteActivity` activity result launcherilla.
- `OnResume` paivittaa listan aina uudelleen.

## Havaitut puutteet
- Empty-state puuttuu kokonaan.
- Null-guardit context/activity-castauksissa puuttuvat.
- Hash-koodiin perustuva haku on hauras identiteettipohja.

## Riskit
- Tyhja lista nayttaa virhetilalta.
- Mahdollinen vaaran noten avaus hash-koodin muuttuessa.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Lisaa empty-state teksti/komponentti.
2. Lisaa guardit context-castauksiin.
3. Siirry vakaaseen note-ID:hen hash-koodin sijaan.
