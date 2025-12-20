@echo off
echo 🚀 DEPLOYING AMBABAI JEWELLERS TO RENDER
echo ========================================

echo.
echo 📧 DUAL EMAIL NOTIFICATIONS CONFIGURED:
echo    ✅ barwadeniranjan@gmail.com
echo    ✅ ambabaijewellers@gmail.com
echo.

echo 📋 Step 1: Your code is already prepared and committed!
echo ✅ Git repository initialized
echo ✅ Code committed with dual email notifications
echo ✅ .gitignore configured
echo.

echo 📋 Step 2: Now we need to push to GitHub...
echo.
echo Please follow these steps:
echo.
echo 1. Go to https://github.com/new
echo 2. Repository name: ambabai-jewellers-backend
echo 3. Make it PUBLIC (important for free deployment)
echo 4. Click "Create repository"
echo 5. Copy the repository URL
echo.
set /p REPO_URL="📋 Enter your GitHub repository URL: "

echo.
echo 📋 Step 3: Pushing code to GitHub...
cd backend
git remote add origin %REPO_URL%
git branch -M main
git push -u origin main

echo.
echo ✅ CODE PUSHED TO GITHUB SUCCESSFULLY!
echo.
echo 📋 Step 4: Now let's deploy to Render...
echo.
echo Please follow these steps:
echo.
echo 1. Go to https://render.com
echo 2. Click "Get Started for Free"
echo 3. Sign up with GitHub
echo 4. Click "New Web Service"
echo 5. Click "Connect account" next to GitHub
echo 6. Find and select your "ambabai-jewellers-backend" repository
echo 7. Use these EXACT settings:
echo.
echo    Name: ambabai-jewellers
echo    Build Command: npm install
echo    Start Command: npm start
echo    Environment: Node
echo.
echo 8. Click "Create Web Service"
echo 9. Wait 3-5 minutes for deployment
echo.
echo 🎯 Your app will be live at: https://ambabai-jewellers.onrender.com
echo.
echo 📱 AFTER DEPLOYMENT:
echo 1. Copy your Render URL
echo 2. Run: python update-mobile-server.py
echo 3. Enter your Render URL
echo 4. Test: https://your-app.onrender.com/api/health
echo.
pause