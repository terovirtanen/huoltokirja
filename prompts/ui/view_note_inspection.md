# view_note_inspection.xml

Layout: `UpKeep-Android/Resources/layout/view_note_inspection.xml`
Kayttopaikka: lisataan runtime-aikana `ViewNoteBasic`-luokassa, kun note-tyyppi on `Inspection`.

## Elementit ja kentat
1. `checkBoxInspection` (`CheckBox`)
- Teksti: `Inspected`.
- Luku: `ElementSetInspection` <- `INoteInspection.Pass`.
- Tallennus: `ElementSave` -> `INoteInspection.Pass = Checked`.

## Datakytkenta
- Kontrolli on kaksitilainen (true/false) ilman lisaselitteita.
- Arvo tallettuu suoraan mallin `Pass`-kenttaan.

## Havaitut puutteet
- Ei selkeytysta, tarkoittaako valinta hyvaksytty/tehty/muu tila.
- Ei lisakenttaa poikkeamille tai huomioille.

## Riskit
- Tarkastusdatan tulkinta vaihtelee kayttajittain.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Selkeyta label (`Passed inspection` tms.).
2. Harkitse lisakenttaa epailtaessa hylkaysta/huomiota.
