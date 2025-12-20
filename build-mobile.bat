@echo off
echo ========================================
echo    Building Jewelry Mobile App
echo ========================================
echo.

echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo.
    echo ❌ Flutter is not installed!
    echo Please install Flutter from: https://flutter.dev/docs/get-started/install
    echo Then run this script again.
    pause
    exit /b 1
)

echo.
echo [1/5] Getting Flutter dependencies...
cd mobile
call flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Failed to get dependencies
    pause
    exit /b 1
)

echo.
echo [2/5] Building Android APK (Debug)...
call flutter build apk --debug
if %errorlevel% neq 0 (
    echo ❌ Failed to build debug APK
    pause
    exit /b 1
)

echo.
echo [3/5] Building Android APK (Release)...
call flutter build apk --release
if %errorlevel% neq 0 (
    echo ❌ Failed to build release APK
    pause
    exit /b 1
)

echo.
echo [4/5] Building Android App Bundle (for Play Store)...
call flutter build appbundle --release
if %errorlevel% neq 0 (
    echo ❌ Failed to build app bundle
    pause
    exit /b 1
)

echo.
echo [5/5] Building Windows Desktop App...
call flutter build windows --release
if %errorlevel% neq 0 (
    echo ⚠️ Windows build failed (may not be supported)
)

echo.
echo ========================================
echo    Build Complete! 🎉
echo ========================================
echo.
echo Built files location:
echo 📱 Android APK (Debug): mobile\build\app\outputs\flutter-apk\app-debug.apk
echo 📱 Android APK (Release): mobile\build\app\outputs\flutter-apk\app-release.apk
echo 📦 Android Bundle: mobile\build\app\outputs\bundle\release\app-release.aab
echo 💻 Windows App: mobile\build\windows\runner\Release\
echo.
echo Install instructions:
echo 1. For Android: Transfer APK to phone and install
echo 2. For Windows: Run the .exe file in the Release folder
echo.
echo Press any key to continue...
pause > nul