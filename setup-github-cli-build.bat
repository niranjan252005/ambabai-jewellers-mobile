@echo off
echo ========================================
echo   SETUP GITHUB CLI FOR AUTO-BUILD
echo   Ambabai Jewellers Mobile App
echo ========================================
echo.
echo This will help you set up GitHub CLI for automatic builds.
echo.
echo STEP 1: Install GitHub CLI
echo ========================================
echo.
echo Downloading GitHub CLI installer...
echo.
echo Opening download page...
start https://github.com/cli/cli/releases/latest
echo.
echo Please:
echo 1. Download "gh_*_windows_amd64.msi"
echo 2. Install with default settings
echo 3. Come back and press any key
echo.
pause
echo.
echo.
echo STEP 2: Login to GitHub
echo ========================================
echo.
echo Running GitHub CLI login...
echo.
gh auth login
echo.
if %errorlevel% neq 0 (
    echo ❌ GitHub CLI not found or login failed
    echo Please install GitHub CLI first
    pause
    exit /b 1
)
echo.
echo ✅ GitHub CLI login successful!
echo.
echo.
echo STEP 3: Trigger Build
echo ========================================
echo.
echo Triggering GitHub Actions build...
echo.
gh workflow run "Build Ambabai Jewellers APK" --repo niranjan252005/ambabai-jewellers-mobile
echo.
if %errorlevel% equ 0 (
    echo ✅ Build triggered successfully!
    echo.
    echo Monitor build progress:
    start https://github.com/niranjan252005/ambabai-jewellers-mobile/actions
    echo.
    echo Build will take 8-10 minutes.
    echo You'll get email notifications when complete.
) else (
    echo ❌ Failed to trigger build
    echo Please check your GitHub permissions
)
echo.
echo.
echo ========================================
echo   NEXT STEPS:
echo ========================================
echo.
echo 1. Monitor build at: https://github.com/niranjan252005/ambabai-jewellers-mobile/actions
echo 2. Wait 8-10 minutes for completion
echo 3. Download APK from "Artifacts" section
echo 4. Install on Android device
echo 5. Test all features
echo 6. Distribute to customers
echo.
echo.
echo 🎉 Your professional mobile app is building!
echo.
echo Press any key to exit...
pause > nul