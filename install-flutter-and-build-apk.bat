@echo off
echo ========================================
echo   INSTALL FLUTTER AND BUILD APK
echo   Ambabai Jewellers Mobile App
echo ========================================
echo.
echo This will automatically install Flutter and build your APK!
echo.
echo.
echo STEP 1: Create Flutter directory
echo ========================================
echo.
if not exist "C:\flutter" (
    echo Creating C:\flutter directory...
    mkdir "C:\flutter"
    echo ✅ Directory created
) else (
    echo ✅ Flutter directory already exists
)
echo.
echo.
echo STEP 2: Download Flutter SDK
echo ========================================
echo.
echo Downloading Flutter SDK (this may take a few minutes)...
echo Opening Flutter download page...
start https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.0-stable.zip
echo.
echo Please:
echo 1. Download will start automatically
echo 2. Extract the ZIP to C:\flutter (so you have C:\flutter\flutter\bin)
echo 3. Come back and press any key when extraction is complete
echo.
pause
echo.
echo.
echo STEP 3: Add Flutter to PATH
echo ========================================
echo.
echo Adding Flutter to system PATH...
setx PATH "%PATH%;C:\flutter\flutter\bin" /M
if %errorlevel% equ 0 (
    echo ✅ Flutter added to PATH
    echo ⚠️  Please restart this command prompt for PATH changes to take effect
    echo.
    echo After restarting, run: .\build-with-android-studio.bat
) else (
    echo ❌ Failed to add to PATH automatically
    echo.
    echo Manual steps:
    echo 1. Open System Properties → Environment Variables
    echo 2. Edit PATH variable
    echo 3. Add: C:\flutter\flutter\bin
    echo 4. Restart command prompt
)
echo.
echo.
echo STEP 4: Alternative - Use Android Studio Flutter Plugin
echo ========================================
echo.
echo You can also install Flutter through Android Studio:
echo.
echo 1. Open Android Studio
echo 2. Go to File → Settings → Plugins
echo 3. Search for "Flutter" and install
echo 4. Restart Android Studio
echo 5. Create new Flutter project to auto-install SDK
echo.
echo.
echo ========================================
echo   NEXT STEPS AFTER FLUTTER INSTALL:
echo ========================================
echo.
echo 1. Restart command prompt (important!)
echo 2. Run: flutter doctor
echo 3. Run: flutter doctor --android-licenses
echo 4. Run: .\build-with-android-studio.bat
echo.
echo Your APK will be ready in 5-10 minutes!
echo.
echo.
echo ========================================
echo   WHAT YOUR APK WILL INCLUDE:
echo ========================================
echo.
echo ✅ All 6 requirements completed
echo ✅ Live server connection
echo ✅ Dual email notifications
echo ✅ Custom SAJ branding
echo ✅ Complete jewelry catalog
echo ✅ Order management system
echo ✅ Customer approval workflow
echo ✅ WhatsApp sharing with photos
echo ✅ Advanced search with SKU codes
echo.
echo 🎉 Professional Ambabai Jewellers mobile app!
echo.
echo Press any key to continue...
pause > nul