@echo off
echo ========================================
echo   AUTO-TRIGGER GITHUB ACTIONS BUILD
echo   Ambabai Jewellers Mobile App
echo ========================================
echo.
echo This script will help you automatically trigger the GitHub Actions build.
echo.
echo OPTION 1: Using GitHub CLI (Recommended)
echo ========================================
echo.
echo If you have GitHub CLI installed:
echo.
echo 1. Install GitHub CLI from: https://cli.github.com/
echo 2. Login: gh auth login
echo 3. Run: gh workflow run "Build Ambabai Jewellers APK" --repo niranjan252005/ambabai-jewellers-mobile
echo.
echo.
echo OPTION 2: Using curl (Advanced)
echo ========================================
echo.
echo If you have a GitHub Personal Access Token:
echo.
echo curl -X POST ^
echo   -H "Accept: application/vnd.github.v3+json" ^
echo   -H "Authorization: token YOUR_GITHUB_TOKEN" ^
echo   https://api.github.com/repos/niranjan252005/ambabai-jewellers-mobile/actions/workflows/build-apk.yml/dispatches ^
echo   -d "{\"ref\":\"main\"}"
echo.
echo.
echo OPTION 3: Browser Method (Easiest)
echo ========================================
echo.
echo Opening GitHub Actions page in browser...
start https://github.com/niranjan252005/ambabai-jewellers-mobile/actions/workflows/build-apk.yml
echo.
echo In the browser:
echo 1. Click "Run workflow" button
echo 2. Click "Run workflow" again
echo 3. Wait 8-10 minutes for build
echo 4. Download APK from Artifacts
echo.
echo.
echo ========================================
echo   WHAT HAPPENS DURING BUILD:
echo ========================================
echo.
echo ⏰ Build Time: 8-10 minutes
echo 🔧 Environment: Ubuntu Latest with Flutter 3.16.0
echo 📱 Output: Professional APK (~50-60 MB)
echo ✅ Features: All 6 requirements + live server connection
echo.
echo.
echo ========================================
echo   YOUR APK WILL INCLUDE:
echo ========================================
echo.
echo ✅ Complete order management system
echo ✅ User approval with dual email notifications
echo ✅ Category management for admins
echo ✅ Profile editing for users
echo ✅ WhatsApp sharing with photos
echo ✅ Custom SAJ app icon and branding
echo ✅ Live server connection to Render
echo ✅ Professional Ambabai Jewellers theme
echo.
echo.
echo 🎉 Ready to build your mobile jewelry empire!
echo.
echo Press any key to continue...
pause > nul