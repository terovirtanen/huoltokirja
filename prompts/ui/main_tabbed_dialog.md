# main_tabbed_dialog.xml

Layout: `UpKeep-Android/Resources/layout/main_tabbed_dialog.xml`
Kayttopaikka: aktiivista C#-viittausta ei loytynyt.

## Elementit ja kentat
1. Otsikko-`TextView`
- Teksti: `Dependant`.

2. `tabLayout` (`TabLayout`)
- Rooli: tab-navigaatio dialogissa.

3. `dependantViewPager` (`ViewPager2`)
- Rooli: tabien sisaltoalue.

4. `buttonDependantOK` (`Button`)
- Teksti: `OK`.
- Sijainti: dialogin alareunan action-alue.

## Datakytkenta ja flow
- Tiedostosta ei loytynyt aktiivista adapteri- tai dialogiluokkaa, joka sitoo tassa layoutissa olevat tabit dataan.
- `buttonDependantOK` esiintyy `NoteAddDialogFragment`-koodissa, mutta se fragmentti inflatoi eri layoutin (`view_note_add.xml`).

## Havaitut puutteet
- Nakyma on todennakoisesti legacy tai keskenerainen.
- Layoutin kontrollit eivat ole nykyisessa UI-virrassa.

## Riskit
- Yllapitovelka ja virhetulkinnat, mita polkua sovellus oikeasti kayttaa.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Merkitse tiedosto legacyksi tai poista, jos ei tarvita.
2. Jos aiotaan kayttaa, rakenna sille oma fragmentti + adapteri + datakytkenta.
