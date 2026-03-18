Analysoi entiteettien valiset suhteet ja omistajuus nykykoodista.

Kohde:
- `UpkeepBase/Model/Dependant.cs`
- `UpkeepBase/Model/DependantList.cs`
- `UpkeepBase/Model/NotesList.cs`
- `UpkeepBase/Model/Note/*.cs`
- `UpkeepBase/Model/Scheduler/*.cs`

Tehtava:
1) Kuvaa suhteet (1..1, 1..N, N..N jos on).
2) Kuvaa omistajuus:
   - kuka omistaa notet
   - kuka omistaa schedulerit
   - miten viittaukset asetetaan (esim. note.Dependant)
3) Tunnista globaalit/staattiset rakenteet ja vaikutus datan elinkaareen.
4) Piirra tekstimuotoinen ER-kuvaus.

Kayta formaattia:
- Relation: A -> B
- Cardinality:
- Ownership:
- Navigation properties:
- Risks:

Lopuksi anna yksi Mermaid ER -kaavio.
