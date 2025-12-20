#!/bin/bash

echo "========================================"
echo "   Building Jewelry Mobile App"
echo "========================================"
echo

echo "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo
    echo "❌ Flutter is not installed!"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    echo "Then run this script again."
    exit 1
fi

flutter --version
echo

echo "[1/6] Getting Flutter dependencies..."
cd mobile
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ Failed to get dependencies"
    exit 1
fi

echo
echo "[2/6] Building Android APK (Debug)..."
flutter build apk --debug
if [ $? -ne 0 ]; then
    echo "❌ Failed to build debug APK"
    exit 1
fi

echo
echo "[3/6] Building Android APK (Release)..."
flutter build apk --release
if [ $? -ne 0 ]; then
    echo "❌ Failed to build release APK"
    exit 1
fi

echo
echo "[4/6] Building Android App Bundle (for Play Store)..."
flutter build appbundle --release
if [ $? -ne 0 ]; then
    echo "❌ Failed to build app bundle"
    exit 1
fi

echo
echo "[5/6] Building iOS App (macOS only)..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    flutter build ios --release
    if [ $? -ne 0 ]; then
        echo "⚠️ iOS build failed"
    fi
else
    echo "⚠️ iOS build skipped (not on macOS)"
fi

echo
echo "[6/6] Building macOS Desktop App..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    flutter build macos --release
    if [ $? -ne 0 ]; then
        echo "⚠️ macOS build failed"
    fi
else
    echo "⚠️ macOS build skipped (not on macOS)"
fi

echo
echo "========================================"
echo "    Build Complete! 🎉"
echo "========================================"
echo
echo "Built files location:"
echo "📱 Android APK (Debug): mobile/build/app/outputs/flutter-apk/app-debug.apk"
echo "📱 Android APK (Release): mobile/build/app/outputs/flutter-apk/app-release.apk"
echo "📦 Android Bundle: mobile/build/app/outputs/bundle/release/app-release.aab"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 iOS App: mobile/build/ios/iphoneos/Runner.app"
    echo "💻 macOS App: mobile/build/macos/Build/Products/Release/jewelry_app.app"
fi
echo
echo "Install instructions:"
echo "1. For Android: Transfer APK to phone and install"
echo "2. For iOS: Use Xcode to install on device"
echo "3. For macOS: Run the .app file"
echo
echo "Press Enter to continue..."
read