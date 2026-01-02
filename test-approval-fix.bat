@echo off
echo ========================================
echo TEST APPROVAL SYSTEM FIX
echo Verify No-Approval System is Working
echo ========================================

echo.
echo 🔍 Testing server health endpoint...
echo.

curl -s https://ambabai-jewellers.onrender.com/api/health

echo.
echo.
echo ========================================
echo ANALYSIS:
echo ========================================
echo.
echo ✅ FIXED if you see:
echo   - "approvalSystem": "DISABLED"
echo   - "database": "SQLite (No Approval Required)"
echo.
echo ❌ NOT FIXED if you see:
echo   - Missing "approvalSystem" field
echo   - "database": "Firebase Firestore"
echo.

echo 📱 MOBILE APP TEST:
echo 1. Try registering a new user
echo 2. Should see: "Account created! You can login immediately"
echo 3. Try logging in with that user
echo 4. Should work without approval message
echo.

echo 👨‍💼 ADMIN PANEL TEST:
echo 1. Login as admin
echo 2. Go to Manage Users
echo 3. Should see all users with "Active" status
echo 4. Delete user function should work
echo.

echo ========================================
echo If tests pass, the approval issue is FIXED! ✅
echo ========================================

pause