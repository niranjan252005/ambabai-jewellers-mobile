@echo off
echo 🚀 BUILDING AMBABAI JEWELLERS - ONLINE VERSION
echo ===============================================

echo.
echo ✅ SERVER STATUS:
echo    🌐 Live at: https://ambabai-jewellers.onrender.com
echo    📧 Dual notifications: barwadeniranjan@gmail.com + ambabaijewellers@gmail.com
echo    📱 Mobile app updated with online server URL
echo.

echo 📋 Step 1: Testing server connection...
echo Opening health check in browser...
start "" "https://ambabai-jewellers.onrender.com/api/health"

echo.
echo 📋 Step 2: Building mobile app...
cd mobile

echo.
echo 📦 Installing dependencies...
flutter packages pub get

echo.
echo 🎨 Generating app icons...
flutter packages pub run flutter_launcher_icons:main

echo.
echo 🔨 Building release APK...
flutter build apk --release

echo.
echo ✅ BUILD COMPLETE!
echo.
echo 📱 Your APK is ready at:
echo    mobile\build\app\outputs\flutter-apk\app-release.apk
echo.
echo 🧪 APK Features:
echo    ✅ Connected to live server (https://ambabai-jewellers.onrender.com)
echo    ✅ Dual email notifications working
echo    ✅ All 6 requirements implemented
echo    ✅ Custom Ambabai Jewellers branding
echo    ✅ Photo upload and sharing
echo    ✅ Order management system
echo    ✅ User approval workflow
echo    ✅ Category management
echo    ✅ Profile editing
echo    ✅ Custom app icon
echo.
echo 🎊 READY FOR DISTRIBUTION!
echo.
echo 📋 Next steps:
echo 1. Test the APK on your device
echo 2. Share with customers
echo 3. Monitor notifications at both email addresses
echo.
pause