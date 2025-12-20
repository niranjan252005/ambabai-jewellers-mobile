@echo off
echo 🧪 TESTING AMBABAI JEWELLERS DEPLOYMENT
echo ======================================

set /p RENDER_URL="📋 Enter your Render URL (e.g., https://ambabai-jewellers.onrender.com): "

echo.
echo 🧪 Testing your deployment...
echo.

echo 📋 Test 1: Health Check
echo Opening: %RENDER_URL%/api/health
start "" "%RENDER_URL%/api/health"

echo.
echo 📋 Test 2: Admin Panel
echo Opening: %RENDER_URL%
start "" "%RENDER_URL%"

echo.
echo 📋 Test 3: Test Notification
echo Opening: %RENDER_URL%/api/test-notification
start "" "%RENDER_URL%/api/test-notification"

echo.
echo ✅ TESTS OPENED IN BROWSER!
echo.
echo 📋 Expected Results:
echo.
echo Test 1 should show:
echo {
echo   "status": "OK",
echo   "server": "Ambabai Jewellers API",
echo   "adminEmails": ["barwadeniranjan@gmail.com", "ambabaijewellers@gmail.com"]
echo }
echo.
echo Test 2 should show: Admin login page
echo Login: admin@ambabaijewellers.com
echo Password: admin123
echo.
echo Test 3 should show: Test notification sent message
echo.
echo 📱 NEXT STEP: Update mobile app with your Render URL
echo Run: python update-mobile-server.py
echo.
pause