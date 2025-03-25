#!/bin/bash
set -o errexit

# Install Flutter
echo "=> Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Verify Flutter installation
flutter --version

# Install dependencies & build
echo "=> Building Flutter web..."
flutter pub get
flutter build web --release \
  --dart-define=API_URL=$API_URL \
  --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY

echo "=> Build complete!"