# activity_main.xml

Layout: `UpKeep-Android/Resources/layout/activity_main.xml`
Kayttopaikka: `UpKeep-Android/ViewMain/MainActivity.cs`
Lisahuomio: toinen legacy-tyylinen MainActivity loytyy polusta `UpKeep-Android/MainActivity.cs`.

## Elementit ja kentat
1. `buttonAdd` (`Button`)
- Teksti: `Lisaa`.
- Koodikytkenta: `FindViewById<Button>(Resource.Id.buttonAdd)`.
- Toiminto: avaa `DialogNoteAddSelector`-dialogin.

2. `mainTabLayout` (`TabLayout`)
- Koodikytkenta: `FindViewById<TabLayout>(Resource.Id.mainTabLayout)`.
- Toiminto: tabit sidotaan `TabLayoutMediator`-objektilla.
- Tab-tekstit: kovakoodattu `ViewList` / `ViewDependantList` `TabFullFilterConfigurationStrategy`-luokassa.

3. `mainViewPager` (`ViewPager2`)
- Koodikytkenta: `FindViewById<ViewPager2>(Resource.Id.mainViewPager)`.
- Adapteri: `MainActivityAdapter(itemCount: 2)`.
- Fragmentit: position 0 -> `ViewList`, position 1 -> `ViewDependantList`.

## Datakytkenta ja flow
- Activity perii `ActivityBase`, joten activity-result virta tulee `_activityResultLauncher` kautta.
- `ActivityResultReceived` iteroi nykyiset fragmentit ja kutsuu `IViewRefresh.RefreshData(_note)`.
- Paanakyma ei itse sido dataa listoihin, vaan delegoi fragmenteille.

## Havaitut puutteet
- Kaksi eri MainActivity-tiedostoa kasvattaa sekaannusriskiä.
- Tab-tekstit eivat tule resourceista.
- Ei globaalia empty/loading/error tasoa paanakymaan.

## Riskit
- Legacy-polku voi paatya kayttoon vahingossa.
- Fragmentsyklin muuttuessa refresh-kutsu voi osua null-fragmenttiin.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Lukitse yksi MainActivity-toteutus.
2. Siirra tab-tekstit string-resursseihin.
3. Lisaa paanakymaan yhteinen statuskomponentti (loading/error).
