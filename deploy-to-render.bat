@echo off
echo 🚀 DEPLOYING AMBABAI JEWELLERS TO RENDER
echo ========================================

echo.
echo 📧 DUAL EMAIL NOTIFICATIONS CONFIGURED:
echo    ✅ barwadeniranjan@gmail.com
echo    ✅ ambabaijewellers@gmail.com
echo.

echo 📋 Step 1: Preparing for deployment...
cd backend

echo.
echo 📋 Step 2: Initializing Git repository...
git init
git add .
git commit -m "Deploy Ambabai Jewellers - Complete jewelry store app"

echo.
echo 📋 Step 3: Creating GitHub repository...
echo Please follow these steps:
echo.
echo 1. Go to https://github.com/new
echo 2. Repository name: ambabai-jewellers-backend
echo 3. Make it Public
echo 4. Click "Create repository"
echo 5. Copy the repository URL
echo.
set /p REPO_URL="Enter your GitHub repository URL: "

echo.
echo 📋 Step 4: Pushing to GitHub...
git remote add origin %REPO_URL%
git branch -M main
git push -u origin main

echo.
echo ✅ CODE PUSHED TO GITHUB!
echo.
echo 📋 Step 5: Deploy to Render (FREE)...
echo.
echo Please follow these steps:
echo 1. Go to https://render.com
echo 2. Sign up with GitHub
echo 3. Click "New Web Service"
echo 4. Connect your GitHub repository
echo 5. Use these settings:
echo    - Name: ambabai-jewellers
echo    - Build Command: cd backend && npm install
echo    - Start Command: cd backend && npm start
echo    - Environment: Node
echo 6. Click "Create Web Service"
echo.
echo 🎯 Your app will be available at: https://ambabai-jewellers.onrender.com
echo.
echo 📱 NEXT STEPS AFTER DEPLOYMENT:
echo 1. Copy your Render URL
echo 2. Run: python update-mobile-server.py
echo 3. Enter your Render URL
echo 4. Build mobile app
echo.
pause