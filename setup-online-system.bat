@echo off
echo ========================================
echo   Ambabai Jewellers - Online System Setup
echo ========================================
echo.

echo [1/5] Installing backend dependencies...
cd backend
call npm install
if %errorlevel% neq 0 (
    echo ❌ Failed to install backend dependencies
    pause
    exit /b 1
)

echo.
echo [2/5] Setting up database...
call npm run setup
if %errorlevel% neq 0 (
    echo ❌ Failed to setup database
    pause
    exit /b 1
)

echo.
echo [3/5] Starting backend server...
start "Ambabai Jewellers Server" cmd /k "npm start"
timeout /t 3

echo.
echo [4/5] Installing mobile app dependencies...
cd ..\mobile
set PATH=C:\Users\Niranjan\Downloads\flutter_windows_3.38.5-stable\flutter\bin;%PATH%
call flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Failed to install mobile dependencies
    pause
    exit /b 1
)

echo.
echo [5/5] Building updated mobile app...
call flutter build apk --release
if %errorlevel% neq 0 (
    echo ⚠️ Mobile build failed, but server is running
)

echo.
echo ✅ ONLINE SYSTEM SETUP COMPLETE!
echo.
echo 🌐 Backend Server: http://localhost:3000
echo 📱 Admin Panel: http://localhost:3000
echo 📧 Admin Email: admin@ambabaijewellers.com
echo 🔑 Admin Password: admin123
echo.
echo 📋 FEATURES ENABLED:
echo ✅ Online user registration with admin notifications
echo ✅ Photo sharing with actual images
echo ✅ Web-based jewelry sharing links
echo ✅ Email notifications to admin
echo ✅ Hybrid online/offline mode
echo.
echo 📞 ADMIN NOTIFICATIONS:
echo • New customer registrations will be sent to: ambabaijewellers@gmail.com
echo • Configure email settings in backend/server.js
echo • Phone notifications can be added via SMS service
echo.
echo 🎯 NEXT STEPS:
echo 1. Configure email settings in backend/server.js
echo 2. Test customer registration → admin notification
echo 3. Share jewelry items with photos
echo 4. Distribute updated APK to customers
echo.
pause