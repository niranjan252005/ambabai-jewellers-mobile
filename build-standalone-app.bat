@echo off
echo ========================================
echo Building Standalone Jewelry Mobile App
echo ========================================
echo.

echo Checking Flutter installation...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Flutter not found in PATH
    echo Please ensure Flutter is installed and added to PATH
    echo.
    echo You can:
    echo 1. Install Flutter from https://flutter.dev/docs/get-started/install
    echo 2. Add Flutter to your PATH environment variable
    echo 3. Restart command prompt and try again
    echo.
    pause
    exit /b 1
)

echo Flutter found! Proceeding with build...
echo.

cd mobile

echo Step 1: Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to get dependencies
    pause
    exit /b 1
)

echo.
echo Step 2: Cleaning previous build...
flutter clean
if %errorlevel% neq 0 (
    echo ERROR: Failed to clean project
    pause
    exit /b 1
)

echo.
echo Step 3: Building APK (this may take a few minutes)...
flutter build apk --release
if %errorlevel% neq 0 (
    echo ERROR: Failed to build APK
    pause
    exit /b 1
)

echo.
echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo APK Location: mobile\build\app\outputs\flutter-apk\app-release.apk
echo.
echo Next Steps:
echo 1. Transfer the APK to your Android phone
echo 2. Enable "Unknown Sources" in phone settings
echo 3. Install the APK by tapping it
echo 4. Login with: admin@jewelry.com / admin123
echo.
echo Features:
echo - 100%% Offline (no internet required)
echo - Search by SKU codes
echo - Rupee currency (₹)
echo - Photo management
echo - WhatsApp sharing
echo - Complete admin panel
echo.
pause