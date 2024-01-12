FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3
RUN apt-get clean

ENV DEBIAN_FRONTEND=dialog
ENV PUB_HOSTED_URL=https://pub.flutter-io.cn
ENV FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

RUN mkdir -p /home/appuser
RUN useradd -d /home/appuser -r -u 1001 appuser
RUN mkdir -p /usr/local/flutter
RUN chown appuser:appuser /usr/local/flutter

RUN mkdir /home/appuser/app
RUN chown -R appuser:appuser /home/appuser

USER appuser

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

ENV HTTP_TIMEOUT=5000

RUN flutter precache --no-universal --no-linux --no-ios --no-android --no-macos --web
RUN flutter doctor
RUN flutter config --enable-web

WORKDIR /home/appuser/app