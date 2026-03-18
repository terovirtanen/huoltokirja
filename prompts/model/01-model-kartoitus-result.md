# 01 Model Kartoitus - Tulos

Scope:
- `UpkeepBase/Model/**`
- `UpkeepBase/Data/DataManager.cs`
- `UpkeepBase/Data/StorageManager.cs`

Huomio nullable-oletuksesta:
- Projekti kayttaa nullable contextia, mutta useat string/list-kentat alustetaan vasta konstruktorissa tai kaytossa.
- Taulukossa tyyppi on ilmoitettu koodin mukaisena. Kaytannossa osa kentista voi olla runtime-tilassa null ennen alustusta.

## Paaentiteetit
- `Dependant`
- `DependantList`
- `NotesList`
- `Note` (base)
- `Service` (extends `Note`)
- `Inspection` (extends `Service`)
- `Scheduler`
- `Constansts`
- `DataManager`
- `StorageManager`

## Field Catalog

| Entity | Field | Type | Persisted/Computed/Transient | Notes |
|---|---|---|---|---|
| Dependant | Id | string | Persisted | Domain identifier (ei pakotettua muodostusta koodissa) |
| Dependant | Name | string | Persisted | Riippuvaisen nimi |
| Dependant | Tags | string[] | Persisted | Tagit taulukkona |
| Dependant | TagsString | string | Persisted | Tagit yhtena merkkijonona |
| Dependant | CounterUnit | string | Persisted | Esim. `km`, `h` |
| Dependant | EventTime | DateTime | Persisted | Luonti/viiteajankohta |
| Dependant | NItems | List<INote> | Persisted | Riippuvaisen notet |
| Dependant | SItems | List<IScheduler> | Persisted | Riippuvaisen schedulerit |
| Dependant | NItemsOrderByDescendingByEventTime | List<INote> | Computed | `[JsonIgnore]`, lajiteltu näkymä |
| Dependant | SItemsOrderByByEventTime | List<IScheduler> | Computed | `[JsonIgnore]`, lajiteltu näkymä |
| Dependant | CounterEstimate | string | Computed | `[JsonIgnore]`, muodostetaan laskennasta |
| DependantList | (base list items) | List<IDependant> | Persisted | Entiteetit itse listan sisalla |
| DependantList | DLName | string | Persisted | Listan nimi |
| DependantList | Items | List<IDependant> | Computed | Lajiteltu näkymä (Name/TagsString) |
| NotesList | (base list items) | List<INote> | Transient | Luokka ei kanna omaa dataa, vaan peilaa staattista varastoa |
| NotesList | Items | List<INote> | Computed | Rakennetaan `Note.Items`-staattisesta listasta |
| Note | Title | string | Persisted | Noten otsikko |
| Note | Description | string | Persisted | Noten kuvaus |
| Note | EventTime | DateTime | Persisted | Noten paivamaara |
| Note | Counter | int | Persisted | Kayttolaskuriarvo |
| Note | Status | NoteStatus | Persisted | `SCHEDULED` / `UPDATED` |
| Note | Items (static) | List<INote> | Transient | Globaali runtime-koonti kaikista noteista |
| Note | ListText | string | Computed | `[JsonIgnore]`, listateksti riippuu tyypista |
| Note | ListTextAllNotes | string | Computed | `[JsonIgnore]`, listateksti sis. ownerin |
| Note | Dependant | IDependant | Transient | `[JsonIgnore]`, runtime viittaus omistajaan |
| Service | Price | double | Persisted | Palvelun hinta |
| Service | Fixer | string | Persisted | Tekija/huoltaja |
| Service | CLASSTITLE (const) | string | Transient | Luokan oletusotsikko |
| Inspection | Pass | bool | Persisted | Tarkastuksen tila |
| Inspection | CLASSTITLE (const) | string | Transient | Luokan oletusotsikko |
| Scheduler | Title | string | Persisted | Schedulerin nimi |
| Scheduler | Description | string | Persisted | Kuvaus |
| Scheduler | NoteType | NoteTypes | Persisted | Minkalainen note generoidaan |
| Scheduler | StartTime | DateTime | Persisted | Ajastuksen aloitusaika |
| Scheduler | Annual | bool | Persisted | Vuosisääntö |
| Scheduler | Biannual | bool | Persisted | Puolivuosisääntö |
| Scheduler | Quaterly | bool | Persisted | Neljännesvuosisääntö |
| Scheduler | CustomPeriodMonths | int | Persisted | Oma kuukausijakso |
| Scheduler | CounterValue | int | Persisted | Kayttoperusteinen jakso |
| Scheduler | StartCounterValue | int | Persisted | Kayttoperusteen lahtolukema |
| Scheduler | PreviousScheduledTime | DateTime | Persisted | Viimeksi generoitu ajankohta |
| Scheduler | NextScheduleTime | DateTime | Computed | `[JsonIgnore]`, seuraava ajankohta |
| Scheduler | ListText | string | Computed | `[JsonIgnore]`, nayttoarvo |
| Scheduler | generateOfftimeInMonths | int | Transient | `[JsonIgnore]`, sisainen runtime-parametri |
| Scheduler | Dependant | IDependant | Transient | `[JsonIgnore]`, viite omistajaan |
| Constansts | CounterUnits (static readonly) | string[] | Transient | UI valintalistat |
| Constansts | NoteTypes (static readonly) | string[] | Transient | UI valintalistat |
| DataManager | dataManager (static) | DataManager | Transient | Singleton-instanssi |
| DataManager | dependantlist | DependantList | Transient | In-memory domain root |
| StorageManager | fileName | string | Transient | Tallennuspolun nimi (`storage.json`) |

## Lyhyt domain-yhteenveto
- Domainin juurena toimii `DependantList`, joka sisaltaa useita `Dependant`-olioita.
- Jokaisella `Dependant`-oliolla on notet (`NItems`) ja schedulerit (`SItems`).
- Note-hierarkia on polymorfinen: `Note` -> `Service` -> `Inspection`.
- Schedulerit generoivat uusia noteja saantojen perusteella (`GenerateNote` -> `AddNoteFromScheduler`).
- Runtime-koontia pidetaan myos globaalissa staattisessa listassa `Note.Items`, josta `NotesList` muodostaa listanakymaa.
- Nykyinen datahallinta on ensisijaisesti muistissa (`DataManager` + `TestData`), ja `StorageManager` tarjoaa JSON-serialisoinnin, mutta se ei ole aktiivisessa datavirrassa kytketty kayttoon.

## Huomiot persisted/computed/transient jaottelusta
- `[JsonIgnore]` kentat ovat kaytannossa non-persisted JSON-sarjoituksessa.
- Staattiset kentat (`Note.Items`, `DataManager.dataManager`) ovat runtime-only eivat kuulu pysyvaan domain-dokumentiinsa sellaisenaan.
- Lasketut kentat (`CounterEstimate`, `NextScheduleTime`, `ListText*`, lajitellut `Items`-propertyt) kannattaa tuottaa ajossa eika tallentaa suoraan tietokantaan.
