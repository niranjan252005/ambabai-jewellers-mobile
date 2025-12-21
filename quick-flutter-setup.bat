@echo off
echo ========================================
echo   QUICK FLUTTER SETUP
echo   Ambabai Jewellers Mobile App
echo ========================================
echo.
echo Since you have Android Studio, let's get Flutter installed quickly!
echo.
echo.
echo OPTION 1: Automatic Download (Recommended)
echo ========================================
echo.
echo I'll open the Flutter download for you:
echo.
start https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.0-stable.zip
echo.
echo ✅ Download started!
echo.
echo STEPS:
echo 1. Save the ZIP file to Downloads
echo 2. Extract to C:\ (so you have C:\flutter\bin)
echo 3. Add C:\flutter\bin to PATH
echo 4. Restart command prompt
echo 5. Run: .\build-with-android-studio.bat
echo.
echo.
echo OPTION 2: Through Android Studio (Alternative)
echo ========================================
echo.
echo 1. Open Android Studio
echo 2. File → Settings → Plugins
echo 3. Install "Flutter" plugin
echo 4. Restart Android Studio
echo 5. File → New → New Flutter Project
echo 6. This will auto-install Flutter SDK
echo.
echo.
echo OPTION 3: Manual PATH Setup
echo ========================================
echo.
echo After extracting Flutter:
echo 1. Press Win + R, type: sysdm.cpl
echo 2. Click "Environment Variables"
echo 3. Edit "Path" in System Variables
echo 4. Add: C:\flutter\bin
echo 5. Click OK and restart command prompt
echo.
echo.
echo ========================================
echo   VERIFICATION COMMANDS:
echo ========================================
echo.
echo After setup, run these to verify:
echo.
echo flutter --version
echo flutter doctor
echo flutter doctor --android-licenses
echo.
echo.
echo ========================================
echo   THEN BUILD YOUR APK:
echo ========================================
echo.
echo .\build-with-android-studio.bat
echo.
echo Your professional Ambabai Jewellers APK will be ready!
echo.
echo.
echo 🎯 QUICK TIP: The easiest way is through Android Studio plugin!
echo.
echo Press any key to continue...
pause > nul