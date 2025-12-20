@echo off
echo ========================================
echo    Fixing and Building Jewelry App
echo ========================================
echo.

echo Setting up Flutter path...
set PATH=C:\Users\Niranjan\Downloads\flutter_windows_3.38.5-stable\flutter\bin;%PATH%

echo.
echo Checking Flutter...
flutter --version
if %errorlevel% neq 0 (
    echo ❌ Flutter not found!
    pause
    exit /b 1
)

echo.
echo [1/5] Cleaning previous builds...
cd mobile
call flutter clean

echo.
echo [2/5] Getting dependencies...
call flutter pub get

echo.
echo [3/5] Updating Gradle wrapper...
cd android
call gradlew wrapper --gradle-version=8.0
cd ..

echo.
echo [4/5] Building APK (this may take a few minutes)...
call flutter build apk --release --no-tree-shake-icons

echo.
echo [5/5] Checking build output...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ✅ APK built successfully!
    echo.
    echo 📱 Your APK is ready at:
    echo mobile\build\app\outputs\flutter-apk\app-release.apk
    echo.
    echo 📋 Next steps:
    echo 1. Transfer APK to your Android phone
    echo 2. Enable "Install from Unknown Sources" in phone settings
    echo 3. Tap APK to install
    echo 4. Launch "Jewelry Store" app
) else (
    echo ❌ APK build failed
    echo Check the error messages above
)

echo.
echo Press any key to continue...
pause > nul