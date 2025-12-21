@echo off
echo ========================================
echo   ANDROID STUDIO FLUTTER SETUP
echo   Ambabai Jewellers Mobile App
echo ========================================
echo.
echo Perfect choice! Android Studio is the best way to build Flutter apps.
echo.
echo.
echo STEP 1: Install Flutter Plugin
echo ========================================
echo.
echo 1. Open Android Studio
echo 2. Go to: File → Settings → Plugins
echo 3. Search for "Flutter" and install
echo 4. Also install "Dart" plugin (auto-installs with Flutter)
echo 5. Restart Android Studio
echo.
echo Press any key when you've completed Step 1...
pause > nul
echo.
echo.
echo STEP 2: Install Flutter SDK
echo ========================================
echo.
echo After restarting Android Studio:
echo.
echo 1. Android Studio will prompt to install Flutter SDK
echo 2. Click "Install Flutter SDK" 
echo 3. Choose location: C:\flutter
echo 4. Wait for download (5-10 minutes)
echo.
echo OR manually:
echo 1. Go to: File → Settings → Languages & Frameworks → Flutter
echo 2. Click "Install SDK" button
echo 3. Choose C:\flutter as location
echo.
echo Press any key when Flutter SDK is installed...
pause > nul
echo.
echo.
echo STEP 3: Accept Android Licenses
echo ========================================
echo.
echo In Android Studio Terminal (View → Tool Windows → Terminal):
echo.
echo Run: flutter doctor --android-licenses
echo Type: y for all prompts
echo.
echo Press any key when licenses are accepted...
pause > nul
echo.
echo.
echo STEP 4: Open Your Project
echo ========================================
echo.
echo 1. In Android Studio: File → Open
echo 2. Navigate to: D:\jewellery\mobile
echo 3. Click Open
echo 4. Wait for indexing to complete
echo.
echo Press any key when project is open...
pause > nul
echo.
echo.
echo STEP 5: Get Dependencies
echo ========================================
echo.
echo In Android Studio Terminal, run:
echo.
echo flutter pub get
echo.
echo This will download all required packages.
echo.
echo Press any key when dependencies are downloaded...
pause > nul
echo.
echo.
echo STEP 6: Generate App Icons
echo ========================================
echo.
echo In Android Studio Terminal, run:
echo.
echo flutter pub run flutter_launcher_icons:main
echo.
echo This will generate your custom SAJ app icons.
echo.
echo Press any key when icons are generated...
pause > nul
echo.
echo.
echo STEP 7: Build Your APK
echo ========================================
echo.
echo METHOD 1 (GUI):
echo 1. In Android Studio: Build → Flutter → Build APK
echo 2. Wait 5-10 minutes for build
echo.
echo METHOD 2 (Terminal):
echo Run: flutter build apk --release
echo.
echo Your APK will be at:
echo mobile\build\app\outputs\flutter-apk\app-release.apk
echo.
echo.
echo ========================================
echo   YOUR APK WILL INCLUDE:
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
echo.
echo ========================================
echo   AFTER BUILD:
echo ========================================
echo.
echo 1. 📱 Install APK on Android device
echo 2. 🧪 Test all features
echo 3. 📤 Share with customers
echo 4. 🎉 Start receiving orders!
echo.
echo Your professional Ambabai Jewellers mobile app will be ready!
echo.
echo.
echo 🎊 Ready to revolutionize your jewelry business!
echo.
echo Press any key to exit...
pause > nul