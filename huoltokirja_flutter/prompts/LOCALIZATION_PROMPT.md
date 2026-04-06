# Flutter localization prompt

Tavoite: siirrä kaikki käyttäjälle näkyvät Flutter-UI-tekstit keskitettyyn lokalisointiin.

Vaatimukset:
- käytä `lib/l10n/app_fi.arb` ja `lib/l10n/app_en.arb`
- oletuskieli on suomi
- englanti toimii tuettuna toisena kielenä
- älä jätä näkyviä tekstejä kovakoodattuina widgetteihin
- käytä `AppLocalizations.of(context)!` tai `context.l10n`
- pidä termit johdonmukaisina koko sovelluksessa
- päivitä myös virhe-, tyhjätila- ja snackbar-tekstit
- käytä termiä `kohde` vanhan `riippuvainen`-termin sijasta
- muistiinpanoihin liittyvät toiminnalliset vaatimukset on kuvattu tiedostossa `prompts/NOTES_PROMPT.md`

Tarkistus:
- `flutter pub get`
- `flutter gen-l10n` (tai automaattinen generointi)
- `flutter analyze`
- `flutter test`
