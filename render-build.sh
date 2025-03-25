#!/usr/bin/env bash

# Set Flutter version (modify as needed)
FLUTTER_VERSION="3.27.3"

# Install Flutter
echo "Installing Flutter $FLUTTER_VERSION..."
curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz
tar xf flutter.tar.xz
export PATH="$PWD/flutter/bin:$PATH"

# Enable Flutter web
flutter config --enable-web

# Install dependencies
flutter pub get

# Build the Flutter web app
flutter build web
