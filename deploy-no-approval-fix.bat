@echo off
echo ========================================
echo DEPLOY NO-APPROVAL FIX
echo Remove Approval System Completely
echo ========================================

echo.
echo 🎯 WHAT THIS DOES:
echo ✅ Removes approval system completely
echo ✅ Users can login immediately after registration
echo ✅ Admin can still delete users if needed
echo ✅ Uses SQLite (reliable, no environment variables needed)
echo.

echo Step 1: Backing up current server.js...
copy backend\server.js backend\server-firebase-backup.js
echo ✅ Backup created: server-firebase-backup.js

echo.
echo Step 2: Replacing server.js with no-approval version...
copy backend\server-no-approval.js backend\server.js
echo ✅ Server updated to remove approval system

echo.
echo Step 3: Adding files to git...
git add .

echo.
echo Step 4: Committing changes...
git commit -m "Remove approval system completely - users can login immediately"

echo.
echo Step 5: Pushing to GitHub (will trigger Render deployment)...
git push origin main

echo.
echo ========================================
echo DEPLOYMENT COMPLETE!
echo ========================================
echo.
echo ✅ Approval system REMOVED
echo ✅ Users can register and login immediately
echo ✅ Admin can still manage users (delete if needed)
echo ✅ No Firebase environment variables required
echo.
echo 🔍 VERIFY THE FIX:
echo 1. Wait 2-3 minutes for Render deployment
echo 2. Check: https://ambabai-jewellers.onrender.com/api/health
echo 3. Should show: "approvalSystem": "DISABLED"
echo 4. Test user registration and login on mobile app
echo.
echo 📱 EXPECTED RESULTS:
echo ✅ User registers → "Account created! You can login immediately"
echo ✅ User logs in → Works without approval
echo ✅ Admin sees users in manage users screen
echo ✅ Admin can delete users if needed
echo.
echo 🎉 Login issue will be completely resolved!
echo ========================================

pause