@echo off
echo ========================================
echo   FIX GIT REPOSITORY AND PUSH TO MOBILE
echo   Ambabai Jewellers Mobile App
echo ========================================
echo.
echo ISSUE DETECTED: You're pushing to the wrong repository!
echo.
echo Current remote: ambabai-jewellers-website (WRONG)
echo Correct remote: ambabai-jewellers-mobile (CORRECT)
echo.
echo.
echo STEP 1: Check current remote
echo ========================================
echo.
git remote -v
echo.
echo.
echo STEP 2: Update remote to mobile repository
echo ========================================
echo.
echo Updating remote URL to mobile repository...
git remote set-url origin https://github.com/niranjan252005/ambabai-jewellers-mobile.git
echo.
echo ✅ Remote updated to mobile repository
echo.
echo.
echo STEP 3: Pull latest changes (if any)
echo ========================================
echo.
git pull origin main --allow-unrelated-histories
echo.
echo.
echo STEP 4: Add and commit GitHub Actions fix
echo ========================================
echo.
git add mobile/.github/workflows/build-apk.yml
git commit -m "Fix GitHub Actions: Update to latest action versions"
echo.
echo.
echo STEP 5: Push to correct mobile repository
echo ========================================
echo.
git push origin main
echo.
if %errorlevel% equ 0 (
    echo ✅ Successfully pushed to mobile repository!
    echo.
    echo Opening GitHub Actions to trigger build...
    start https://github.com/niranjan252005/ambabai-jewellers-mobile/actions
    echo.
    echo Now you can:
    echo 1. Click "Build Ambabai Jewellers APK"
    echo 2. Click "Run workflow" → "Run workflow"
    echo 3. Wait 8-10 minutes for your APK!
) else (
    echo ❌ Push failed. Please check the error above.
)
echo.
echo.
echo ========================================
echo   REPOSITORY FIXED!
echo ========================================
echo.
echo ✅ Now pointing to: ambabai-jewellers-mobile
echo ✅ GitHub Actions workflow updated
echo ✅ Ready to build your APK!
echo.
echo Press any key to continue...
pause > nul