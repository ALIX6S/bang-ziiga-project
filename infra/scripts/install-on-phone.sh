#!/usr/bin/env bash
# Installe et lance l'APK sur le téléphone branché en USB.
# `adb reverse` fait pointer localhost:3000 du téléphone vers l'API du conteneur.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
APK="$ROOT/infra/out/bang-ziiga.apk"
PKG="com.example.frontend"

[ -f "$APK" ] || { echo "APK absent. Lance d'abord : make -C infra apk"; exit 1; }

SERIAL="$(adb devices | awk '$2=="device"{print $1; exit}')"
[ -n "$SERIAL" ] || { echo "Aucun appareil autorisé. Branche le câble + autorise le débogage USB."; exit 1; }
echo "Appareil : $SERIAL ($(adb -s "$SERIAL" shell getprop ro.product.model | tr -d '\r'))"

curl -sf -m 5 http://localhost:3000/health >/dev/null || { echo "API injoignable. Lance : make -C infra up"; exit 1; }

adb -s "$SERIAL" reverse --remove-all >/dev/null 2>&1 || true
adb -s "$SERIAL" reverse tcp:3000 tcp:3000
echo "Tunnel : téléphone localhost:3000 -> API conteneur"

# La cle de debug vit dans le volume bz_android_keystore. Si un APK a ete
# signe avec une autre cle, Android refuse la mise a jour : on desinstalle.
if ! adb -s "$SERIAL" install -r -d "$APK" 2>&1 | tee /dev/stderr | grep -q "^Success"; then
  echo "Signature differente, desinstallation puis reinstallation."
  adb -s "$SERIAL" uninstall "$PKG" >/dev/null 2>&1 || true
  adb -s "$SERIAL" install "$APK"
fi
adb -s "$SERIAL" shell am start -n "$PKG/.MainActivity" >/dev/null
echo "Application lancée. Logs : adb -s $SERIAL logcat -s flutter:V"
