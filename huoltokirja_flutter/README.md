# huoltokirja_flutter

Flutter-versio Huoltokirja-sovelluksesta.

## Käynnistys iPhone-simulaattorissa Macilla

1. Avaa iPhone-simulaattori komennolla `open -a Simulator`
2. Siirry projektikansioon komennolla `cd /Users/terovirtanen/github/huoltokirja/huoltokirja_flutter`
3. Hae riippuvuudet komennolla `flutter pub get`
4. Tarkista, että simulaattori näkyy Flutterille komennolla `flutter devices`
5. Käynnistä sovellus komennolla `flutter run -d ios`

## Jos haluat valita tietyn simulaattorin

- Listaa saatavilla olevat laitteet komennolla `xcrun simctl list devices`
- Käynnistä haluamasi simulaattori ja suorita sen jälkeen `flutter run`

## Jos iOS-simulaattori ei käynnisty

Tarkista Xcode-ympäristö seuraavilla komennoilla:

- `xcode-select -p`
- `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
- `sudo xcodebuild -runFirstLaunch`
- `flutter doctor`

## Lisätietoa

- Flutterin virallinen dokumentaatio: https://docs.flutter.dev/
- iOS setup Flutterille: https://docs.flutter.dev/platform-integration/ios/setup
