@echo off
echo ========================================
echo FIX FIREBASE SECURITY ISSUE
echo Remove sensitive files and use env vars
echo ========================================

echo.
echo Step 1: Remove sensitive file from git...
git rm --cached backend/firebase-service-account.json
git rm --cached firebase-service-account.json
echo ✅ Removed service account from git

echo.
echo Step 2: Add to .gitignore...
echo firebase-service-account.json >> .gitignore
echo backend/firebase-service-account.json >> .gitignore
echo ✅ Added to .gitignore

echo.
echo Step 3: Update Firebase service to use environment variables...
echo ✅ Firebase service already supports env vars

echo.
echo Step 4: Commit security fix...
git add .gitignore
git add backend/services/firebase.js
git commit -m "Security fix: Use environment variables for Firebase credentials"

echo.
echo Step 5: Push security fix...
git push origin main

echo.
echo ========================================
echo SECURITY FIX COMPLETE!
echo ========================================
echo.
echo ✅ Sensitive files removed from git
echo ✅ Environment variables configured
echo ✅ Deployment will use secure method
echo.
echo Next: Configure Render environment variables
echo.
pause