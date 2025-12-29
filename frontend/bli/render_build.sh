#!/usr/bin/env bash
# Exit on error
set -o errexit

echo "🚀 Starting Render Build for Flutter Web..."

# 1. Install Flutter
if [ ! -d "flutter" ]; then
    echo "📦 Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
else
    echo "✅ Flutter already installed."
fi

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

echo "🔍 Checking Flutter version..."
flutter --version

# 2. Configure Flutter
echo "⚙️  Configuring Flutter..."
flutter config --enable-web

# 3. Get Dependencies
echo "📥 Getting dependencies..."
flutter pub get

# 4. Build Web App
echo "🏗️  Building web app..."

flutter build web --release --base-href "/"

echo "✅ Build successful! Output is in build/web"
