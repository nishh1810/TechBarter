#!/bin/bash
set -o errexit

# Create .env file from Render environment variables
echo "API_URL=$API_URL" > .env
echo "STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY" >> .env

# Rest of your build script
flutter pub get
flutter build web --release