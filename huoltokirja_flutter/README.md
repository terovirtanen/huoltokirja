# huoltokirja_flutter

Flutter-versio Huoltokirja-sovelluksesta.

## Käynnistys iPhone-simulaattorissa Macilla

1. Avaa iPhone-simulaattori komennolla `open -a Simulator`
2. Siirry projektikansioon komennolla `cd /Users/terovirtanen/github/huoltokirja/huoltokirja_flutter`
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

## Lisätietoa

- Flutterin virallinen dokumentaatio: https://docs.flutter.dev/
- iOS setup Flutterille: https://docs.flutter.dev/platform-integration/ios/setup
