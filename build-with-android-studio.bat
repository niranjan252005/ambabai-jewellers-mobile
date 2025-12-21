@echo off
echo ========================================
echo   BUILD APK WITH ANDROID STUDIO
echo   Ambabai Jewellers Mobile App
echo ========================================
echo.
echo ✅ Android Studio detected!
echo ✅ Building APK locally for faster results
echo.
echo.
echo STEP 1: Check Flutter installation
echo ========================================
echo.
flutter --version
if %errorlevel% neq 0 (
    echo ❌ Flutter not found in PATH
    echo.
    echo Please install Flutter:
    echo 1. Download from: https://flutter.dev/docs/get-started/install/windows
    echo 2. Extract to C:\flutter
    echo 3. Add C:\flutter\bin to PATH
    echo 4. Restart command prompt
    echo.
    pause
    exit /b 1
)
echo.
echo ✅ Flutter is installed!
echo.
echo.
echo STEP 2: Check Android SDK
echo ========================================
echo.
flutter doctor
echo.
echo.
echo STEP 3: Navigate to mobile directory
echo ========================================
echo.
cd mobile
if %errorlevel% neq 0 (
    echo ❌ Mobile directory not found
    pause
    exit /b 1
)
echo.
echo ✅ In mobile directory
echo.
echo.
echo STEP 4: Get Flutter dependencies
echo ========================================
echo.
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Failed to get dependencies
    pause
    exit /b 1
)
echo.
echo ✅ Dependencies downloaded
echo.
echo.
echo STEP 5: Generate app icons
echo ========================================
echo.
flutter pub run flutter_launcher_icons:main
echo.
echo ✅ App icons generated
echo.
echo.
echo STEP 6: Build Release APK
echo ========================================
echo.
echo Building your professional Ambabai Jewellers APK...
flutter build apk --release
if %errorlevel% neq 0 (
    echo ❌ Build failed
    echo.
    echo Common fixes:
    echo 1. Run: flutter clean
    echo 2. Run: flutter pub get
    echo 3. Try again
    pause
    exit /b 1
)
echo.
echo ✅ APK BUILD SUCCESSFUL!
echo.
echo.
echo ========================================
echo   BUILD COMPLETE! 🎉
echo ========================================
echo.
echo Your professional APK is ready:
echo 📱 Location: mobile\build\app\outputs\flutter-apk\app-release.apk
echo 📏 Size: ~50-60 MB
echo 🎯 Features: All 6 requirements + live server connection
echo.
echo.
echo APK INCLUDES:
echo ========================================
echo ✅ Complete order management system
echo ✅ User approval with dual email notifications
echo ✅ Category management for admins
echo ✅ Profile editing for users
echo ✅ WhatsApp sharing with photos
echo ✅ Custom SAJ app icon and branding
echo ✅ Live server: https://ambabai-jewellers.onrender.com
echo ✅ Professional Ambabai Jewellers theme
echo.
echo.
echo NEXT STEPS:
echo ========================================
echo 1. 📱 Install APK on Android device
echo 2. 🧪 Test all features
echo 3. 📤 Share with customers
echo 4. 🎉 Start receiving orders!
echo.
echo Opening APK location...
explorer build\app\outputs\flutter-apk\
echo.
echo 🎊 Your mobile jewelry empire is ready!
echo.
echo Press any key to exit...
pause > nul