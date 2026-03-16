# view_note_service.xml

Layout: `UpKeep-Android/Resources/layout/view_note_service.xml`
Kayttopaikka: lisataan runtime-aikana `ViewNoteBasic`-luokassa.

## Elementit ja kentat
1. `noteCounter` (`AppCompatEditText`, `inputType=number`)
- Rooli: huolto-/inspection-merkinnan laskuriarvo.
- Luku: `ElementSetService` <- `mNote.Counter`.
- Tallennus: `ElementSave` -> `INoteService.Counter = Convert.ToInt32(...)`.

2. `notePrice` (`AppCompatEditText`, `inputType=numberDecimal`)
- Rooli: hinta.
- Luku: `ElementSetService` <- `INoteService.Price`.
- Tallennus: `ElementSave` -> `INoteService.Price = Convert.ToDouble(...)`.

3. `noteFixer` (`AppCompatEditText`)
- Rooli: tekija/korjaaja.
- Luku: `ElementSetService` <- `INoteService.Fixer`.
- Tallennus: `ElementSave` -> `INoteService.Fixer`.

## Datakytkenta
- Kentat ovat kaytossa note-tyypeille `Service` ja `Inspection`.
- Lukeminen/tallennus tapahtuu parent-fragmentista (`ViewNoteBasic`).

## Havaitut puutteet
- Parse kutsut ilman validointia.
- Ei required-kenttien tarkistusta.
- `numberDecimal` + `Convert.ToInt32` voi aiheuttaa yllattavaa kaytosta `noteCounter`-kentassa.

## Riskit
- Runtime poikkeus virheellisella syotteella.
- Data voi tallentua eri muodossa kuin kayttaja odottaa.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Korvaa `Convert` kutsut `TryParse`-poluilla.
2. Lisaa virheviestit kenttakohtaisesti.
3. Vahvista inputType ja parserit vastaamaan toisiaan.
