# activity_row_main.xml

Layout: `UpKeep-Android/Resources/layout/activity_row_main.xml`
Kayttopaikka:
- `UpKeep-Android/ViewMain/MainListAdapter.cs`
- `UpKeep-Android/ViewMain/DependantListAdapter.cs`
- `UpKeep-Android/ViewMain/DependantNotesListAdapter.cs`

## Elementit ja kentat
1. `textView1` (`TextView`)
- Rooli: itemin otsikko.
- Koodikytkenta: adapterit asettavat `Title` arvon.

2. `textView2` (`TextView`)
- Rooli: itemin kuvaus/listText.
- Koodikytkenta: adapterit asettavat `Description` arvon.

## Datakytkenta ja renderointi
- Kaikki kolme adapteria inflatoivat taman saman layoutin `GetView`-metodissa.
- Adapterit kayttavat `convertView`-uudelleenkayttoa.
- Poikkeukset niellaan `try/catch` lohkossa debug-logiin.

## Havaitut puutteet
- Ei erottele visuaalisesti eri item-tyyppeja.
- Ei nayta tilatietoa (scheduled/updated/late).
- Ei null-guardia `FindViewById`-hakuihin.

## Riskit
- Lista voi olla vaikea lukea pitkillla riveilla.
- Hiljainen poikkeusten nieleminen voi peittaa oikeat renderointivirheet.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Lisaa status-indikaattori (vari/ikoni).
2. Tarkenna virhekasittelya adaptereissa.
3. Harkitse ViewHolder-kaavaa suorituskyvyn ja selkeyden vuoksi.
