@echo off
echo ========================================
echo    Complete Android Studio Setup
echo ========================================
echo.

echo Looking for Android Studio installation...

REM Check common Android Studio locations
set ANDROID_STUDIO_PATH=""
if exist "C:\Program Files\Android\Android Studio" (
    set ANDROID_STUDIO_PATH=C:\Program Files\Android\Android Studio
    echo ✅ Found Android Studio at: %ANDROID_STUDIO_PATH%
) else if exist "C:\Users\%USERNAME%\AppData\Local\Android\Sdk" (
    set ANDROID_SDK_PATH=C:\Users\%USERNAME%\AppData\Local\Android\Sdk
    echo ✅ Found Android SDK at: %ANDROID_SDK_PATH%
) else (
    echo ❌ Android Studio not found in common locations
    echo Please make sure Android Studio is installed and try again
    pause
    exit /b 1
)

echo.
echo Setting up Android SDK environment...

REM Set Android SDK path
if exist "C:\Users\%USERNAME%\AppData\Local\Android\Sdk" (
    set ANDROID_HOME=C:\Users\%USERNAME%\AppData\Local\Android\Sdk
    set ANDROID_SDK_ROOT=%ANDROID_HOME%
    echo ✅ ANDROID_HOME set to: %ANDROID_HOME%
) else (
    echo ❌ Android SDK not found
    echo Please open Android Studio and install SDK through SDK Manager
    echo Then run this script again
    pause
    exit /b 1
)

echo.
echo Adding Android tools to PATH...
set PATH=%ANDROID_HOME%\tools;%ANDROID_HOME%\tools\bin;%ANDROID_HOME%\platform-tools;%PATH%

echo.
echo Checking Android SDK Manager...
if exist "%ANDROID_HOME%\cmdline-tools\latest\bin\sdkmanager.bat" (
    echo ✅ SDK Manager found
) else (
    echo ❌ Command-line tools not installed
    echo.
    echo Please follow these steps:
    echo 1. Open Android Studio
    echo 2. Go to Tools → SDK Manager
    echo 3. Go to SDK Tools tab
    echo 4. Check "Android SDK Command-line Tools (latest)"
    echo 5. Click Apply and install
    echo 6. Run this script again
    echo.
    pause
    exit /b 1
)

echo.
echo Accepting Android licenses...
call "%ANDROID_HOME%\cmdline-tools\latest\bin\sdkmanager.bat" --licenses

echo.
echo Running Flutter doctor...
flutter doctor

echo.
echo ========================================
echo    Android Setup Complete!
echo ========================================
echo.
echo If Flutter doctor shows all green checkmarks for Android,
echo you're ready to build your mobile app!
echo.
echo Next step: Run build-now.bat to build your APK
echo.
pause