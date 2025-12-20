@echo off
echo 🚀 DEPLOYING AMBABAI JEWELLERS ONLINE
echo ====================================

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
echo 5. Copy the repository URL (e.g., https://github.com/yourusername/ambabai-jewellers-backend.git)
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
echo 📋 Step 5: Deploy to Railway...
echo.
echo Please follow these steps:
echo 1. Go to https://railway.app
echo 2. Sign up/Login with GitHub
echo 3. Click "New Project"
echo 4. Select "Deploy from GitHub repo"
echo 5. Choose your "ambabai-jewellers-backend" repository
echo 6. Railway will automatically deploy your app!
echo.
echo 🎯 Your app will be available at: https://your-project-name.railway.app
echo.
echo 📱 NEXT STEPS AFTER DEPLOYMENT:
echo 1. Copy your Railway URL
echo 2. Run: python update-mobile-server.py
echo 3. Enter your Railway URL
echo 4. Build mobile app: cd mobile && flutter build apk --release
echo.
pause