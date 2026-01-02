@echo off
echo ========================================
echo UPDATE AMBABAI JEWELLERS LOGO
echo Replace App Icon and Logo Images
echo ========================================

echo.
echo 📁 CURRENT LOGO FILES:
echo.
echo App Icon: mobile\assets\icon\app_icon.png
echo Logo Image: mobile\assets\images\logo.png
echo.

echo 🎯 TO UPDATE YOUR LOGO:
echo.
echo 1. Prepare your shop logo in PNG format
echo 2. Create two versions:
echo    - 1024x1024 pixels for app icon
echo    - 512x512 pixels for in-app logo
echo.
echo 3. Replace these files:
echo    - Copy your 1024x1024 logo to: mobile\assets\icon\app_icon.png
echo    - Copy your 512x512 logo to: mobile\assets\images\logo.png
echo.

echo 4. Test the app:
echo    - Run: flutter run (in mobile folder)
echo    - Check splash screen, headers, and app icon
echo.

echo 5. Build APK with your logo:
echo    - Run: flutter build apk --release
echo.

echo ========================================
echo LOGO LOCATIONS IN APP:
echo ========================================
echo.
echo ✅ App Icon (Phone Home Screen)
echo ✅ Splash Screen
echo ✅ App Headers and Navigation
echo ✅ Login/Register Screens  
echo ✅ Admin Panel
echo ✅ Share Messages
echo ✅ Error Screens
echo.

echo 📱 Your Ambabai Jewellers logo will appear throughout the entire app!
echo.

pause