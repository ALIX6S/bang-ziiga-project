#!/usr/bin/env bash
# Compile l'APK debug depuis /src (monté en lecture seule) vers /out.
# Le code source n'est pas modifié : on travaille sur une copie où l'URL de
# l'API est remplacée par $API_URL.
set -euo pipefail
: "${API_URL:=http://localhost:3000/api/v1}"
PROD_URL="https://bang-ziiga-project.onrender.com/api/v1"

cp -r /src /app && cd /app
mkdir -p assets/images assets/icons
rm -rf build .dart_tool android/local.properties
sed -i "s|ndkVersion = flutter.ndkVersion|ndkVersion = \"${NDK_VERSION}\"|" android/app/build.gradle.kts
grep -rl "$PROD_URL" lib | xargs sed -i "s#$PROD_URL#$API_URL#g"
flutter config --no-analytics >/dev/null
flutter pub get
flutter build apk --debug
cp build/app/outputs/flutter-apk/app-debug.apk /out/bang-ziiga.apk
echo "APK prêt : out/bang-ziiga.apk (API = $API_URL)"
