#!/bin/bash

set -e


# Siirry huoltokirja-hakemistoon ja palaa lopuksi takaisin
pushd "$(dirname "$0")/huoltokirja" > /dev/null

echo "Valitse toiminto:"
echo "1) iOS simulaattori: build & run"
echo "2) iOS release build (ipa)"
echo "3) Android emulaattori: build & run"
echo "4) Android release build (apk)"
echo "q) Lopeta"
echo "c) Clean (poistaa build-välimuistit)"
read -p "Valinta: " valinta

BUILD_DATE=$(date +%F)

case $valinta in
  1)
    flutter pub get
    echo "Rakennetaan ja käynnistetään iOS-simulaattorissa..."
    open -a Simulator
    flutter run -d ios --dart-define=APP_BUILD_DATE=$BUILD_DATE
    ;;
  2)
    echo "Rakennetaan iOS release (ipa)..."
    flutter pub get
    flutter build ipa --release --dart-define=APP_BUILD_DATE=$BUILD_DATE
    echo "Valmis. Julkaistava .ipa-tiedosto löytyy polusta: huoltokirja/build/ios/ipa/"
    ;;
  3)
    echo "Rakennetaan ja käynnistetään Android-emulaattorissa..."
    flutter pub get
    flutter emulators
    flutter run -d emulator --dart-define=APP_BUILD_DATE=$BUILD_DATE
    ;;
  4)
    echo "Rakennetaan Android release (apk)..."
    flutter pub get
    flutter build apk --release --dart-define=APP_BUILD_DATE=$BUILD_DATE
    echo "Valmis. Löydät APK:n polusta build/app/outputs/flutter-apk/app-release.apk"
    ;;
  c)
    echo "Ajetaan flutter clean..."
    flutter clean
    popd > /dev/null
    exit 0
    ;;
  q)
    echo "Lopetetaan."
    popd > /dev/null
    exit 0
    ;;
  *)
    echo "Tuntematon valinta."
    popd > /dev/null
    exit 1
    ;;
esac
