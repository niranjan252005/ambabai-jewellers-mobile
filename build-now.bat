@echo off
echo ========================================
echo    Building Jewelry Mobile App NOW!
echo ========================================
echo.

echo Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo.
    echo ❌ Flutter is not in PATH!
    echo.
    echo Please add Flutter to your PATH:
    echo 1. Find where you extracted Flutter (e.g., C:\flutter)
    echo 2. Add C:\flutter\bin to your PATH environment variable
    echo 3. Restart this terminal
    echo 4. Run this script again
    echo.
    echo OR run Flutter directly:
    echo   C:\path\to\flutter\bin\flutter --version
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Flutter found! Starting build process...
echo.

echo [1/4] Navigating to mobile app directory...
cd mobile
if %errorlevel% neq 0 (
    echo ❌ Mobile directory not found!
    pause
    exit /b 1
)

echo.
echo [2/4] Getting Flutter dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Failed to get dependencies
    echo Try running: flutter clean
    pause
    exit /b 1
)

echo.
echo [3/4] Building Android APK (Release)...
call flutter build apk --release
if %errorlevel% neq 0 (
    echo ❌ Failed to build APK
    echo Check the error messages above
    pause
    exit /b 1
)

echo.
echo [4/4] Building Windows Desktop App...
call flutter build windows --release
if %errorlevel% neq 0 (
    echo ⚠️ Windows build failed (may require Visual Studio)
    echo But Android APK was built successfully!
)

echo.
echo ========================================
echo    🎉 BUILD COMPLETE!
echo ========================================
echo.
echo Your apps are ready:
echo.
echo 📱 Android APK:
echo    mobile\build\app\outputs\flutter-apk\app-release.apk
echo.
echo 💻 Windows App (if built):
echo    mobile\build\windows\runner\Release\jewelry_app.exe
echo.
echo 📋 Next Steps:
echo 1. Transfer APK to your Android phone
echo 2. Enable "Install from Unknown Sources" in phone settings
echo 3. Tap APK to install
echo 4. Launch "Jewelry Store" app
echo.
echo Press any key to continue...
pause > nul