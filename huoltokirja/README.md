# Käynnistys Android-emulaattorilla ja release-version teko

## Android-emulaattorin käynnistys komentoriviltä

1. Listaa asennetut emulaattorit: emulator list avd
2. Käynnistä emulaattori: emulator -avd <emulaattorin_nimi>
3. Varmista, että laite näkyy Flutterille: flutter devices

## Sovelluksen ajaminen emulaattorissa

1. Siirry projektin juureen: cd huoltokirja/huoltokirja
2. Hae riippuvuudet: flutter pub get
3. Käynnistä sovellus: flutter run -d android

## Release-version teko ja asennus puhelimeen

1. Rakenna release APK: flutter build apk --release
  - Löydät valmiin APK-tiedoston polusta build/app/outputs/flutter-apk/app-release.apk
2. Siirrä APK puhelimeen (esim. USB, sähköposti, pilvipalvelu)
3. Asenna APK puhelimeen (esim. tiedostonhallinnalla tai komennolla adb install build/app/outputs/flutter-apk/app-release.apk)

Jos haluat tehdä allekirjoitetun ja Play-kauppaan sopivan AAB-paketin:

1. flutter build appbundle --release
  - Tiedosto löytyy polusta build/app/outputs/bundle/release/app-release.aab

## iOS release-paketin (ipa) sijainti

Kun ajat iOS release buildin komennolla:
    flutter build ios --release --dart-define=APP_BUILD_DATE=$(date +%F)
Julkaistava .ipa-tiedosto löytyy polusta:
    huoltokirja/build/ios/ipa/

Lisätietoa: https://docs.flutter.dev/deployment/android
# huoltokirja

Flutter-versio Huoltokirja-sovelluksesta.

## Käynnistys iPhone-simulaattorissa Macilla

1. Avaa iPhone-simulaattori komennolla `open -a Simulator`
2. Siirry projektikansioon komennolla `cd /Users/terovirtanen/github/huoltokirja/huoltokirja`
3. Hae riippuvuudet komennolla `flutter pub get`
4. Tarkista, että simulaattori näkyy Flutterille komennolla `flutter devices`
5. Käynnistä sovellus komennolla `flutter run -d ios`

## Debuggaus

### Terminaalista

- Käynnistä debugissa komennolla `flutter run -d ios`
- Kun sovellus on käynnissä:
  - `r` = hot reload
  - `R` = hot restart
  - `q` = lopeta

### VS Codessa

- Valitse alareunasta tai Run and Debug -näkymästä iPhone-simulaattori kohdelaitteeksi
- Käynnistä debug painamalla `F5`

## Jos haluat valita tietyn simulaattorin

- Listaa saatavilla olevat laitteet komennolla `xcrun simctl list devices`
- Tarkista Flutterin näkemät laitteet komennolla `flutter devices`
- Käynnistä haluamallasi laitteella esimerkiksi komennolla `flutter run -d "iPhone 16 Pro"`

## Simulaattorin tyhjennys

Jos haluat poistaa kaikki simulaattoriin asennetut sovellukset ja datan:

- `xcrun simctl erase all`

Jos haluat tyhjentää vain yhden simulaattorin:

1. Listaa laitteet komennolla `xcrun simctl list devices`
2. Tyhjennä haluttu laite komennolla `xcrun simctl erase <DEVICE_ID>`

Jos haluat poistaa vain yhden sovelluksen käynnissä olevasta simulaattorista:

- `xcrun simctl uninstall booted <bundle-id>`

## Jos iOS-simulaattori ei käynnisty

Tarkista Xcode-ympäristö seuraavilla komennoilla:

- `xcode-select -p`
- `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
- `sudo xcodebuild -runFirstLaunch`
- `flutter doctor`

## Build-metatieto

Jos haluat asettaa build-päivämäärän dynaamisesti buildin aikana, anna se `--dart-define`-parametrilla:

- `flutter build apk --dart-define=APP_BUILD_DATE=$(date +%F)`
- `flutter build ios --dart-define=APP_BUILD_DATE=$(date +%F)`

## Lisätietoa

- Flutterin virallinen dokumentaatio: https://docs.flutter.dev/
- iOS setup Flutterille: https://docs.flutter.dev/platform-integration/ios/setup
