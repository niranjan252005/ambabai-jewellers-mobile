@echo off
echo ========================================
echo    Installing Android Studio
echo ========================================
echo.

echo This script will help you install Android Studio for building your jewelry mobile app.
echo.

echo Step 1: Downloading Android Studio...
echo.

REM Check if we have winget (Windows Package Manager)
winget --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Found Windows Package Manager (winget)
    echo Installing Android Studio via winget...
    winget install Google.AndroidStudio
    if %errorlevel% equ 0 (
        echo ✅ Android Studio installed successfully!
        goto :setup
    ) else (
        echo ⚠️ Winget installation failed, trying manual download...
        goto :manual
    )
) else (
    echo ⚠️ Windows Package Manager not found, using manual download...
    goto :manual
)

:manual
echo.
echo 📥 Manual Download Required:
echo.
echo 1. Opening Android Studio download page...
start https://developer.android.com/studio
echo.
echo 2. Please download and install Android Studio from the opened page
echo 3. Choose "Download Android Studio" button
echo 4. Run the installer with default settings
echo 5. When installation is complete, come back and press any key
echo.
pause
goto :setup

:setup
echo.
echo ========================================
echo    Setting up Android Studio
echo ========================================
echo.

echo Checking Android Studio installation...
if exist "%LOCALAPPDATA%\Android\Sdk" (
    echo ✅ Android SDK found at: %LOCALAPPDATA%\Android\Sdk
    set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
    goto :configure
)

if exist "%PROGRAMFILES%\Android\Android Studio" (
    echo ✅ Android Studio found
    echo Setting up Android SDK...
    REM Common Android SDK locations
    if exist "C:\Users\%USERNAME%\AppData\Local\Android\Sdk" (
        set ANDROID_HOME=C:\Users\%USERNAME%\AppData\Local\Android\Sdk
        goto :configure
    )
)

echo ❌ Android SDK not found automatically.
echo.
echo Please complete Android Studio setup:
echo 1. Launch Android Studio
echo 2. Go through the setup wizard
echo 3. Install Android SDK (default location is recommended)
echo 4. Come back and press any key when done
echo.
pause

REM Try to find SDK again
if exist "%LOCALAPPDATA%\Android\Sdk" (
    set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
    goto :configure
)

echo Please enter your Android SDK path:
echo (Usually: C:\Users\%USERNAME%\AppData\Local\Android\Sdk)
set /p ANDROID_HOME="Android SDK Path: "

:configure
echo.
echo ========================================
echo    Configuring Environment
echo ========================================
echo.

echo Setting ANDROID_HOME to: %ANDROID_HOME%
setx ANDROID_HOME "%ANDROID_HOME%"

echo Adding Android tools to PATH...
set PATH=%ANDROID_HOME%\tools;%ANDROID_HOME%\tools\bin;%ANDROID_HOME%\platform-tools;%PATH%
setx PATH "%ANDROID_HOME%\tools;%ANDROID_HOME%\tools\bin;%ANDROID_HOME%\platform-tools;%PATH%"

echo.
echo ✅ Environment configured!
echo.

echo Testing Flutter with Android...
flutter doctor

echo.
echo ========================================
echo    Android Studio Setup Complete!
echo ========================================
echo.

echo Next steps:
echo 1. Accept Android licenses: flutter doctor --android-licenses
echo 2. Build your jewelry app: flutter build apk --release
echo.

echo Would you like to accept Android licenses now? (y/n)
set /p accept="Accept licenses? "
if /i "%accept%"=="y" (
    echo.
    echo Accepting Android licenses...
    flutter doctor --android-licenses
)

echo.
echo ✅ Android Studio setup complete!
echo You can now build your jewelry mobile app!
echo.
echo Run: build-now.bat
echo.
pause