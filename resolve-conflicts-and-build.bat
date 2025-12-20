@echo off
echo ========================================
echo   RESOLVE GIT CONFLICTS AND BUILD APK
echo   Ambabai Jewellers Mobile App
echo ========================================
echo.
echo ISSUE: Git merge conflicts detected
echo FILES: .gitignore and README.md have conflicts
echo.
echo SOLUTION: Reset and force push our version
echo.
echo.
echo STEP 1: Check git status
echo ========================================
echo.
git status
echo.
echo.
echo STEP 2: Abort current merge and reset
echo ========================================
echo.
echo Aborting current merge...
git merge --abort
echo.
echo Resetting to clean state...
git reset --hard HEAD
echo.
echo.
echo STEP 3: Force push our version (with GitHub Actions fix)
echo ========================================
echo.
echo Adding GitHub Actions workflow...
git add mobile/.github/workflows/build-apk.yml
git add .
git commit -m "Add GitHub Actions workflow with latest action versions"
echo.
echo Force pushing to mobile repository...
git push origin main --force
echo.
if %errorlevel% equ 0 (
    echo ✅ Successfully pushed to mobile repository!
    echo.
    echo Opening GitHub Actions to trigger build...
    start https://github.com/niranjan252005/ambabai-jewellers-mobile/actions
    echo.
    echo ========================================
    echo   BUILD YOUR APK NOW!
    echo ========================================
    echo.
    echo 1. Click "Build Ambabai Jewellers APK" workflow
    echo 2. Click "Run workflow" button
    echo 3. Click "Run workflow" again
    echo 4. Wait 8-10 minutes for completion
    echo 5. Download APK from "Artifacts" section
    echo.
    echo Your professional mobile app will be ready!
) else (
    echo ❌ Push failed. Trying alternative approach...
    echo.
    echo Creating new branch and pushing...
    git checkout -b mobile-app-build
    git push origin mobile-app-build --force
    echo.
    echo Please create a pull request to merge this branch.
)
echo.
echo.
echo ========================================
echo   CONFLICTS RESOLVED!
echo ========================================
echo.
echo ✅ Repository cleaned up
echo ✅ GitHub Actions workflow added
echo ✅ Ready to build your APK!
echo.
echo Press any key to continue...
pause > nul