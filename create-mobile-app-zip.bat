@echo off
echo 📱 CREATING AMBABAI JEWELLERS MOBILE APP ZIP PACKAGE
echo ===================================================

echo.
echo 📁 Creating mobile app package...
echo.

REM Create mobile app package folder
if not exist "ambabai-jewellers-mobile-app" mkdir "ambabai-jewellers-mobile-app"

REM Copy mobile app files
echo ✅ Copying Flutter mobile app...
xcopy "mobile" "ambabai-jewellers-mobile-app\mobile" /E /I /Y

REM Copy backend for mobile app
echo ✅ Copying backend server...
xcopy "backend" "ambabai-jewellers-mobile-app\backend" /E /I /Y

REM Copy build scripts
echo ✅ Copying build scripts...
copy "build-mobile.bat" "ambabai-jewellers-mobile-app\"
copy "build-mobile.sh" "ambabai-jewellers-mobile-app\"
copy "simple-android-build.bat" "ambabai-jewellers-mobile-app\"
copy "setup-flutter.bat" "ambabai-jewellers-mobile-app\"

REM Copy documentation
echo ✅ Copying documentation...
copy "MOBILE_APP_COMPLETE.md" "ambabai-jewellers-mobile-app\"
copy "APK_BUILD_SUCCESS.md" "ambabai-jewellers-mobile-app\"
copy "FLUTTER_SETUP.md" "ambabai-jewellers-mobile-app\"
copy "BUILD_GUIDE.md" "ambabai-jewellers-mobile-app\"
copy "ANDROID_STUDIO_SETUP.md" "ambabai-jewellers-mobile-app\"

REM Create mobile app specific README
echo ✅ Creating mobile app README...
echo # 📱 Ambabai Jewellers Mobile App > "ambabai-jewellers-mobile-app\README.md"
echo. >> "ambabai-jewellers-mobile-app\README.md"
echo **श्री अंबाबाई ज्वेलर्स** - Complete Flutter Mobile Application >> "ambabai-jewellers-mobile-app\README.md"
echo. >> "ambabai-jewellers-mobile-app\README.md"
echo ## 🏪 Shop Information >> "ambabai-jewellers-mobile-app\README.md"
echo - **Name:** Ambabai Jewellers >> "ambabai-jewellers-mobile-app\README.md"
echo - **Address:** Vishal Nagar, Hupari - 416203 >> "ambabai-jewellers-mobile-app\README.md"
echo - **Phone:** +91 7666993107 >> "ambabai-jewellers-mobile-app\README.md"
echo - **Email:** ambabaijewellers@gmail.com >> "ambabai-jewellers-mobile-app\README.md"
echo - **Owner:** Niranjan Barwade >> "ambabai-jewellers-mobile-app\README.md"
echo. >> "ambabai-jewellers-mobile-app\README.md"
echo ## 🚀 Quick Start >> "ambabai-jewellers-mobile-app\README.md"
echo 1. Install Flutter SDK >> "ambabai-jewellers-mobile-app\README.md"
echo 2. Run: flutter pub get >> "ambabai-jewellers-mobile-app\README.md"
echo 3. Run: flutter run >> "ambabai-jewellers-mobile-app\README.md"
echo. >> "ambabai-jewellers-mobile-app\README.md"
echo ## 📱 Build APK >> "ambabai-jewellers-mobile-app\README.md"
echo Run: build-mobile.bat >> "ambabai-jewellers-mobile-app\README.md"

REM Create PowerShell script to create ZIP
echo ✅ Creating ZIP file...
powershell -Command "Compress-Archive -Path 'ambabai-jewellers-mobile-app' -DestinationPath 'ambabai-jewellers-mobile-app.zip' -Force"

if exist "ambabai-jewellers-mobile-app.zip" (
    echo.
    echo 🎉 MOBILE APP ZIP PACKAGE CREATED SUCCESSFULLY!
    echo ===============================================
    echo.
    echo 📦 Package: ambabai-jewellers-mobile-app.zip
    echo 📁 Size: 
    for %%A in ("ambabai-jewellers-mobile-app.zip") do echo    %%~zA bytes
    echo.
    echo 📱 WHAT'S INCLUDED:
    echo ==================
    echo ✅ Complete Flutter mobile app
    echo ✅ Backend server for API
    echo ✅ Build scripts for Android/iOS
    echo ✅ Complete documentation
    echo ✅ Setup guides and tutorials
    echo.
    echo 🚀 FEATURES:
    echo ============
    echo ✅ Ambabai Jewellers branding
    echo ✅ Admin panel for jewelry management
    echo ✅ Customer registration with approval
    echo ✅ Gold and Silver jewelry collections
    echo ✅ Photo upload and sharing
    echo ✅ Search functionality
    echo ✅ WhatsApp integration
    echo ✅ Offline capability
    echo.
    echo 📋 NEXT STEPS:
    echo ==============
    echo 1. Extract the ZIP file
    echo 2. Install Flutter SDK
    echo 3. Run: flutter pub get
    echo 4. Run: flutter run
    echo 5. Build APK: build-mobile.bat
    echo.
    echo 📖 Read README.md in the package for detailed instructions
    echo.
) else (
    echo ❌ Failed to create ZIP file
)

REM Clean up temporary folder
echo 🧹 Cleaning up...
rmdir /s /q "ambabai-jewellers-mobile-app"

echo.
echo 📱 Your Ambabai Jewellers Mobile App is ready!
echo.
pause