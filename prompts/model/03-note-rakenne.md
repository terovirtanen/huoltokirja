Analysoi Note-hierarkia ja kaytettava datarakenne kenttatasolla.

Kohde:
- `UpkeepBase/Model/Note/INote.cs`
- `UpkeepBase/Model/Note/INoteService.cs`
- `UpkeepBase/Model/Note/INoteInspection.cs`
- `UpkeepBase/Model/Note/Note.cs`
- `UpkeepBase/Model/Note/Service.cs`
- `UpkeepBase/Model/Note/Inspection.cs`

Tehtava:
1) Kuvaa periytymisketju (INote -> Note -> Service -> Inspection).
2) Listaa yhteiset kentat ja tyyppikohtaiset kentat.
3) Kuvaa enumit ja niiden merkitys:
   - NoteTypes
   - NoteStatus
4) Kuvaa miten ListText/ListTextAllNotes muodostuvat eri note-tyypeissa.
5) Tunnista serialisointiin liittyvat huomautukset (JsonIgnore, static fields).

Anna tulos:
- UML-tyylinen tekstikaavio
- kenttalista per tyyppi
- JSON-esimerkit: Basic, Service, Inspection

Ala muuta koodia.
