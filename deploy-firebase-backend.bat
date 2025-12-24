@echo off
echo ========================================
echo DEPLOY FIREBASE BACKEND TO RENDER
echo Ambabai Jewellers - Firebase Migration
echo ========================================

echo.
echo Step 1: Installing Firebase dependencies...
cd backend
call npm install firebase-admin
if %errorlevel% neq 0 (
    echo ❌ Failed to install Firebase dependencies
    pause
    exit /b 1
)

echo.
echo Step 2: Backing up old server.js...
if exist server.js (
    copy server.js server-sqlite-backup.js
    echo ✅ Backup created: server-sqlite-backup.js
)

echo.
echo Step 3: Replacing server.js with Firebase version...
copy server-firebase.js server.js
echo ✅ Server updated to use Firebase Firestore

echo.
echo Step 4: Adding files to git...
git add .
git commit -m "Migrate to Firebase Firestore database"

echo.
echo Step 5: Pushing to GitHub (will trigger Render deployment)...
git push origin main

echo.
echo ========================================
echo FIREBASE MIGRATION DEPLOYED!
echo ========================================
echo.
echo ✅ Backend now uses Firebase Firestore
echo ✅ Data will persist through server restarts
echo ✅ No more SQLite data loss issues
echo.
echo 🔥 Firebase Project: ambabai-jewellers
echo 🌐 Server URL: https://ambabai-jewellers.onrender.com
echo.
echo Next steps:
echo 1. Wait for Render deployment to complete (2-3 minutes)
echo 2. Test user registration on mobile app
echo 3. Verify data persists in Firebase console
echo.
pause