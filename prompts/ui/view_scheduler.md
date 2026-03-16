# view_scheduler.xml

Layoutit:
- `UpKeep-Android/Resources/layout/view_scheduler.xml`
- `UpKeep-Android/Resources/layout/view_scheduler_timing.xml` (lisataan dynaamisesti parent-layoutiin)

Kayttopaikka:
- `UpKeep-Android/ViewScheduler/ViewScheduler.cs`
- Huomio: aktiivista kutsupolkua nykyisesta scheduler-tabista ei loytynyt.

## Nykytila (rakenne)
- Nakyma on `ScrollView` + pystysuuntainen `LinearLayout` (`schedulerParentLinearLayout`).
- Paakentat (title, description) ovat `view_scheduler.xml`-layoutissa.
- Ajastus-/saanto-kentat tulevat erillisesta `view_scheduler_timing.xml`-layoutista.
- Data sitoutuu suoraan `IScheduler`-olioon (`mScheduler`) metodeissa `ElementSet` / `ElementSave`.

## Elementit ja kentat

### A) view_scheduler.xml
1. `schedulerParentLinearLayout` (`LinearLayout`)
- Rooli: parent-container, johon timing-layout lisataan runtime-aikana.
- Koodikytkenta: `FindViewById<LinearLayout>(Resource.Id.schedulerParentLinearLayout)`.

2. `schedulerButtonCancel` (`Button`)
- Teksti: `Cancel`.
- Koodikytkenta: ei loytynyt click-handleria `ViewScheduler.cs`-luokasta.

3. `schedulerButtonSave` (`Button`)
- Teksti: `Save`.
- Koodikytkenta: ei loytynyt click-handleria `ViewScheduler.cs`-luokasta.

4. `schedulerTypeSpinner` (`AppCompatSpinner`)
- Rooli: scheduler-tyypin valinta (oletettu).
- Koodikytkenta: adapterin/bindauksen logiikka kommentoitu pois.

5. `schedulerTitle` (`AppCompatEditText`)
- Rooli: schedulerin otsikko.
- Luku: `ElementSet` asettaa arvon `mScheduler.Title`.
- Tallennus: `ElementSave` -> `mScheduler.Title = elementTitle.Text`.

6. `schedulerDescription` (`AppCompatEditText`)
- Rooli: schedulerin kuvaus.
- Luku: `ElementSet` asettaa arvon `mScheduler.Description`.
- Tallennus: `ElementSave` -> `mScheduler.Description = elementDescription.Text`.

### B) view_scheduler_timing.xml
1. `schedulerCheckboxAnnually` (`AppCompatCheckBox`)
- Rooli: vuosittainen ajastus.
- Luku: `ElementSetTiming` <- `mScheduler.Annual`.
- Tallennus: `ElementSave` -> `mScheduler.Annual`.

2. `schedulerCheckboxBiannually` (`AppCompatCheckBox`)
- Rooli: puolivuosittainen ajastus.
- Luku: `ElementSetTiming` <- `mScheduler.Biannual`.
- Tallennus: `ElementSave` -> `mScheduler.Biannual`.

3. `schedulerCheckboxQuaterly` (`AppCompatCheckBox`)
- Rooli: neljannesvuosittainen ajastus.
- Luku: `ElementSetTiming` <- `mScheduler.Quaterly`.
- Tallennus: `ElementSave` -> `mScheduler.Quaterly`.

4. `schedulerMonthPeriod` (`AppCompatEditText`, `inputType=number`)
- Rooli: custom period kuukausina.
- Luku: `ElementSetTiming` <- `mScheduler.CustomPeriodMonths`.
- Tallennus: `ElementSave` -> `Convert.ToInt32(...)` -> `mScheduler.CustomPeriodMonths`.

5. `schedulerCounterValue` (`AppCompatEditText`, `inputType=numberDecimal`)
- Rooli: kayttoon perustuva ajastusjakso.
- Luku: `ElementSetTiming` <- `mScheduler.CounterValue`.
- Tallennus: `ElementSave` -> `Convert.ToInt32(...)` -> `mScheduler.CounterValue`.

6. `schedulerStartCounterValue` (`AppCompatEditText`)
- Rooli: laskennan aloituslukema.
- Luku: `ElementSetTiming` <- `mScheduler.StartCounterValue`.
- Tallennus: `ElementSave` -> `Convert.ToInt32(...)` -> `mScheduler.StartCounterValue`.

7. `schedulerDate` (`AppCompatEditText`, date)
- Rooli: schedulerin aloituspaiva.
- Luku: `OnCreateView` asettaa `mScheduler.StartTime.ToShortDateString()`.
- Muokkaus: date picker avataan clickilla.
- Tallennus: `ElementSave` -> `DateTime.Parse(elementDate.Text)` -> `mScheduler.StartTime`.

## Dataliikenne ja lifecycle
- Alustus: `OnCreateView` -> `ElementSet(view)` + date-kentan asetus.
- Tallennus: `OnPause()` ja `OnDialogClose()` kutsuvat `ElementSave(View)`.
- Tilanhallinta: `mScheduler` on staattinen kentta.

## Havaitut puutteet (kenttataso)
1. Toimimattomat action-napit:
- `schedulerButtonCancel` ja `schedulerButtonSave` ovat layoutissa mutta ilman click-logiikkaa.

2. Tyyppikentta keskenerainen:
- `schedulerTypeSpinner` on layoutissa, mutta adapteri/valinta on kommentoitu koodissa.

3. Validointi puuttuu:
- `DateTime.Parse` ja `Convert.ToInt32` voivat kaatua virheellisella syotteella.
- Tyhjia pakollisia kenttia (esim. title) ei tarkisteta.

4. Terminologia/labelit:
- Kirjoitusvirheita: `Mounth`, `Quaterly`.
- Sekakieliset labelit voivat heikentaa UX-yhtenaisyytta.

5. State-riski:
- Staattinen `mScheduler` voi aiheuttaa virheita fragmentin uudelleenluonnissa.

## Riskit
- Runtime-kaatumiset syotemuunnoksissa.
- Kayttaja ei tieda tallentuivatko muutokset (Save nappi ei oikeasti tee mita odotetaan).
- Saantojen ristiriitainen kaytto (useat checkboxit + custom arvot) ilman selkeaa ohjausta.

## Suositus jatkoon (ei toteutettu tassa vaiheessa)
1. Kytke `Save`/`Cancel` napit eksplisiittiseen flowhun.
2. Lisaa kenttakohtainen validointi (`TryParse`, pakolliset kentat, virheviestit).
3. Paata scheduler-tyypin hallinta (`schedulerTypeSpinner` kayttoon tai pois).
4. Poista staattinen state ja siirry argumentti/ID-pohjaiseen stateen.
5. Yhdenmukaista labelit ja kieli string-resursseihin.
