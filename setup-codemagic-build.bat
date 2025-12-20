@echo off
echo 🚀 CODEMAGIC BUILD SETUP - AMBABAI JEWELLERS
echo ============================================

echo.
echo ✅ MOBILE APP PREPARED:
echo    📱 All source code committed to Git
echo    🎨 Custom app icon ready
echo    🌐 Connected to live server: https://ambabai-jewellers.onrender.com
echo    📧 Dual email notifications configured
echo    ⚙️ Codemagic configuration file created
echo.

echo 📋 Step 1: Create GitHub Repository for Mobile App
echo.
echo Please follow these steps:
echo.
echo 1. Go to https://github.com/new
echo 2. Repository name: ambabai-jewellers-mobile
echo 3. Make it PUBLIC (required for free Codemagic builds)
echo 4. Click "Create repository"
echo 5. Copy the repository URL
echo.
set /p MOBILE_REPO_URL="📋 Enter your mobile app GitHub repository URL: "

echo.
echo 📋 Step 2: Pushing mobile app to GitHub...
cd mobile
git remote add origin %MOBILE_REPO_URL%
git branch -M main
git push -u origin main

echo.
echo ✅ MOBILE APP PUSHED TO GITHUB!
echo.
echo 📋 Step 3: Now set up Codemagic build...
echo.
echo Please follow these steps:
echo.
echo 1. Go to https://codemagic.io
echo 2. Click "Start building for free"
echo 3. Sign up with GitHub (same account you just used)
echo 4. Click "Add application"
echo 5. Select "Flutter App"
echo 6. Choose your "ambabai-jewellers-mobile" repository
echo 7. Codemagic will detect the codemagic.yaml file automatically
echo 8. Click "Start your first build"
echo.
echo ⏰ Build time: 10-15 minutes
echo 📧 You'll get email notifications at both addresses when complete
echo 📱 Download APK from build artifacts
echo.
echo 🎯 Your APK will include:
echo    ✅ Connected to live server
echo    ✅ Dual email notifications
echo    ✅ All 6 requirements implemented
echo    ✅ Custom Ambabai Jewellers branding
echo    ✅ Professional mobile app ready for customers
echo.
echo 🎊 READY FOR CODEMAGIC BUILD!
echo.
pause