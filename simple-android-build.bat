@echo off
echo ========================================
echo    Simple Android APK Builder
echo ========================================
echo.

echo Setting up environment...
set PATH=C:\Users\Niranjan\Downloads\flutter_windows_3.38.5-stable\flutter\bin;%PATH%
set ANDROID_HOME=C:\Users\Niranjan\AppData\Local\Android\Sdk

echo.
echo Checking Flutter...
flutter --version
if %errorlevel% neq 0 (
    echo ❌ Flutter not found! Please install Flutter first.
    pause
    exit /b 1
)

echo.
echo Checking Android SDK...
if not exist "%ANDROID_HOME%" (
    echo ❌ Android SDK not found!
    echo Please install Android Studio and SDK first.
    pause
    exit /b 1
)

echo.
echo [1/6] Stopping any running Gradle processes...
taskkill /F /IM gradle* 2>nul
taskkill /F /IM java* 2>nul

echo.
echo [2/6] Cleaning previous builds...
cd mobile
call flutter clean

echo.
echo [3/6] Getting dependencies...
call flutter pub get

echo.
echo [4/6] Checking for compilation errors...
call flutter analyze --no-fatal-infos

echo.
echo [5/6] Building APK (Debug - faster build)...
call flutter build apk --debug --verbose

if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo.
    echo ✅ DEBUG APK built successfully!
    echo 📱 Location: mobile\build\app\outputs\flutter-apk\app-debug.apk
    echo.
    echo Building RELEASE APK (optimized)...
    call flutter build apk --release --no-tree-shake-icons
    
    if exist "build\app\outputs\flutter-apk\app-release.apk" (
        echo ✅ RELEASE APK built successfully!
        echo 📱 Location: mobile\build\app\outputs\flutter-apk\app-release.apk
    ) else (
        echo ⚠️ Release build failed, but debug APK is available
    )
) else (
    echo ❌ APK build failed
    echo.
    echo 🔧 Troubleshooting steps:
    echo 1. Install Android Studio completely
    echo 2. Open Android Studio and install SDK components
    echo 3. Run: flutter doctor --android-licenses
    echo 4. Accept all licenses
    echo 5. Try building again
)

echo.
echo [6/6] Build summary:
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo ✅ Debug APK: Ready for testing
)
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ Release APK: Ready for distribution
)

echo.
echo 📋 Next steps:
echo 1. Transfer APK to your Android phone
echo 2. Enable "Install from Unknown Sources" in Settings
echo 3. Tap APK file to install
echo 4. Launch "Jewelry Store" app
echo.
echo 🌐 Alternative: Use web app at http://localhost:3000
echo   - Same features as mobile app
echo   - Works in mobile browser
echo   - No installation needed
echo.
pause