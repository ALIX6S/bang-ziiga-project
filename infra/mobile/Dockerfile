# Chaîne de build Android/Flutter. Le projet est compilé au `run`, pas au `build`
# (voir infra/mobile/build-apk.sh), pour garder les caches Gradle/pub/keystore
# dans des volumes et obtenir une signature stable entre deux builds.
FROM ghcr.io/cirruslabs/flutter:stable

# AGP exige le NDK pour stripper libflutter.so, même sans code natif. curl avec
# reprise : le téléchargement par sdkmanager cale souvent.
ARG NDK_VERSION=27.0.12077973
ARG NDK_ZIP=android-ndk-r27-linux.zip
ARG NDK_DIR=android-ndk-r27
RUN set -eux; \
    curl -fL -C - --retry 200 --retry-delay 5 --retry-all-errors \
      -o /tmp/ndk.zip https://dl.google.com/android/repository/${NDK_ZIP}; \
    mkdir -p /tmp/ndk /opt/android-sdk-linux/ndk; \
    unzip -q /tmp/ndk.zip -d /tmp/ndk; \
    mv /tmp/ndk/${NDK_DIR} /opt/android-sdk-linux/ndk/${NDK_VERSION}; \
    rm -rf /tmp/ndk /tmp/ndk.zip
ENV NDK_VERSION=${NDK_VERSION}

COPY build-apk.sh /usr/local/bin/build-apk
RUN chmod +x /usr/local/bin/build-apk
CMD ["build-apk"]
