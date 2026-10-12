#!/bin/bash

set -e


# Siirry huoltokirja-hakemistoon ja palaa lopuksi takaisin
pushd "$(dirname "$0")/huoltokirja" > /dev/null

echo "Valitse toiminto:"
echo "1) iOS simulaattori: build & run"
echo "2) iOS release build (ipa)"
echo "3) Android emulaattori: build & run"
echo "4) Android release build (apk)"
echo "5) Android release build (aab, Google Play)"
echo "q) Lopeta"
echo "c) Clean (poistaa build-välimuistit)"
read -p "Valinta: " valinta

BUILD_DATE=$(date +%F)

case $valinta in
  1)
    flutter pub get
    echo "Rakennetaan ja käynnistetään iOS-simulaattorissa..."
    open -a Simulator 2>/dev/null || open -a "DeviceHub" 2>/dev/null || true
    IOS_DEVICE_ID=$(flutter devices --machine 2>/dev/null | grep -B4 '"targetPlatform": "ios"' | grep '"id"' | head -1 | sed -E 's/.*"id": "([^"]+)".*/\1/')
    if [ -z "$IOS_DEVICE_ID" ]; then
      IOS_DEVICE_ID=ios
    fi
    flutter run -d "$IOS_DEVICE_ID" --dart-define=APP_BUILD_DATE=$BUILD_DATE
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
    APK=build/app/outputs/flutter-apk/app-release.apk
    echo "Valmis. Löydät APK:n polusta huoltokirja/$APK"
    echo "Allekirjoitus:"
    keytool -printcert -jarfile "$APK"
    ;;
  5)
    echo "Rakennetaan Android release (aab, Google Play)..."
    flutter pub get
    flutter build appbundle --release --dart-define=APP_BUILD_DATE=$BUILD_DATE
    AAB=build/app/outputs/bundle/release/app-release.aab
    echo "Valmis. Löydät AAB:n polusta huoltokirja/$AAB"
    echo "Allekirjoitus:"
    SIG=$(keytool -printcert -jarfile "$AAB")
    echo "$SIG"
    if echo "$SIG" | grep -q "Android Debug"; then
      echo "VIRHE: AAB on allekirjoitettu debug-avaimella! Tarkista huoltokirja/android/key.properties. Älä lataa tätä Google Playhin."
      popd > /dev/null
      exit 1
    fi
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
