# view_dependant_scheduler.xml

Layout: `UpKeep-Android/Resources/layout/view_dependant_scheduler.xml`
Kayttopaikka: `UpKeep-Android/ViewDependant/ViewDependantScheduler.cs`

## Elementit ja kentat
1. `buttonAddDependantScheduler` (`Button`)
- Teksti: `Add`.
- Koodikytkenta: ei event-handleria fragmentissa.

2. `textDependantScheduler` (`TextView`)
- Rooli: status/information text.
- Koodikytkenta: ei bindausta fragmentissa.

3. `listDependantSchedulers` (`ListView`)
- Rooli: scheduler-lista valitulle riippuvaiselle.
- Koodikytkenta: adapteria ei aseteta.

## Datakytkenta ja flow
- `OnCreateView` vain inflatoi layoutin ja palauttaa sen.
- DataManager/Dependant-kytkentaa ei ole.
- `OnDialogClose` on tyhja.

## Havaitut puutteet
- Koko scheduler-tabin businessflow puuttuu.
- Yksikaan elementti ei ole sidottu dataan.
- Empty/error/loading-tiloja ei ole.

## Riskit
- Tuotantotason UX ei voi toteutua scheduler-ominaisuudelle nykytilassa.
- Kayttaja kohtaa dead-end-nakyman.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Lisaa listan adapteri ja datahaku valitulle riippuvaiselle.
2. Kytke Add-nappi scheduler-editoriin (`ViewScheduler`).
3. Lisaa state-viestit (no schedulers, error, loading).
