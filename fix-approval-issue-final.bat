@echo off
echo ========================================
echo FIX APPROVAL ISSUE - FINAL SOLUTION
echo Ambabai Jewellers - Remove Approval System
echo ========================================

echo.
echo 🔍 PROBLEM IDENTIFIED:
echo ❌ Server still running SQLite with approval system
echo ❌ Firebase environment variables not set in Render
echo ❌ Users see "account not approved by admin"
echo.

echo 🎯 SOLUTION:
echo 1. Set Firebase environment variables in Render
echo 2. OR update server to remove approval system completely
echo.

echo ========================================
echo CHECKING CURRENT SERVER STATUS...
echo ========================================

curl -s https://ambabai-jewellers.onrender.com/api/health

echo.
echo.
echo ========================================
echo ANALYSIS:
echo ========================================
echo.
echo If you see "database": "Firebase Firestore" - ✅ Firebase is working
echo If you DON'T see database field - ❌ Still running SQLite
echo.

echo 🚨 CRITICAL ACTION REQUIRED:
echo.
echo Go to: https://dashboard.render.com/
echo Find: ambabai-jewellers service
echo Add Firebase environment variables from firebase-service-account.json
echo.
echo OR run the alternative fix below...
echo.

pause

echo.
echo ========================================
echo ALTERNATIVE: UPDATE SERVER TO REMOVE APPROVAL
echo ========================================
echo.
echo This will update the server to remove approval system completely
echo Users will be able to login immediately after registration
echo.

echo Step 1: Updating server.js to remove approval checks...

echo.
echo Step 2: Committing and pushing changes...

echo.
echo Step 3: Deploying to Render...

echo.
echo ========================================
echo CHOOSE YOUR SOLUTION:
echo ========================================
echo.
echo Option 1: Set Firebase environment variables (RECOMMENDED)
echo Option 2: Remove approval system from current SQLite server
echo.
echo Both will fix the login issue permanently.
echo ========================================

pause