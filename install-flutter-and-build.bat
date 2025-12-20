@echo off
echo 🚀 FLUTTER INSTALLATION AND APK BUILD
echo ====================================

echo.
echo 📋 Step 1: Download Flutter SDK
echo.
echo Please follow these steps:
echo.
echo 1. Go to https://docs.flutter.dev/get-started/install/windows
echo 2. Download Flutter SDK for Windows
echo 3. Extract to C:\flutter
echo 4. Add C:\flutter\bin to your PATH environment variable
echo 5. Restart command prompt
echo 6. Run: flutter doctor
echo.
echo OR use this quick method:
echo.
echo 1. Download: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip
echo 2. Extract to C:\flutter
echo 3. Add C:\flutter\bin to PATH
echo.
pause

echo.
echo 📋 Step 2: Install Android Studio (if not installed)
echo.
echo 1. Download Android Studio: https://developer.android.com/studio
echo 2. Install with default settings
echo 3. Open Android Studio
echo 4. Install Android SDK and build tools
echo.
pause

echo.
echo 📋 Step 3: Setup Flutter
echo.
echo Run these commands after Flutter is installed:
echo.
echo flutter doctor
echo flutter doctor --android-licenses
echo.
pause

echo.
echo 📋 Step 4: Build your Ambabai Jewellers APK
echo.
cd mobile
flutter packages pub get
flutter packages pub run flutter_launcher_icons:main
flutter build apk --release

echo.
echo ✅ APK will be created at:
echo mobile\build\app\outputs\flutter-apk\app-release.apk
echo.
pause