@echo off
echo 🚀 DEPLOYING AMBABAI JEWELLERS TO RAILWAY
echo ==========================================

echo.
echo 📧 NOTIFICATION UPDATE: Approval requests will go to BOTH:
echo    - barwadeniranjan@gmail.com
echo    - ambabaijewellers@gmail.com
echo.

echo 📋 Step 1: Login to Railway...
echo Please complete login in your browser when prompted
railway login

echo.
echo 📋 Step 2: Deploying backend...
cd backend
railway init --name ambabai-jewellers
railway up

echo.
echo ✅ DEPLOYMENT COMPLETE!
echo.
echo 📱 Your server is now online!
echo 📧 Dual email notifications are configured
echo.
echo 🔧 NEXT STEPS:
echo 1. Copy your Railway URL from the output above
echo 2. Run: python update-mobile-server.py
echo 3. Enter your Railway URL when prompted
echo 4. Build mobile app: cd mobile && flutter build apk --release
echo.
echo 🧪 TEST YOUR DEPLOYMENT:
echo Visit your Railway URL to test the admin panel
echo.
pause