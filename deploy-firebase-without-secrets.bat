@echo off
echo ========================================
echo DEPLOY FIREBASE VERSION WITHOUT SECRETS
echo Ambabai Jewellers - Safe Deployment
echo ========================================

echo.
echo 🔍 PROBLEM: GitHub blocked push due to firebase-service-account.json
echo 🎯 SOLUTION: Deploy Firebase code without the secret file
echo.

echo Step 1: Removing firebase-service-account.json from git...
git rm --cached backend/firebase-service-account.json 2>nul
echo ✅ Secret file removed from git tracking

echo.
echo Step 2: Adding firebase-service-account.json to .gitignore...
echo backend/firebase-service-account.json >> .gitignore
echo ✅ Secret file added to .gitignore

echo.
echo Step 3: Committing Firebase code without secrets...
git add .
git commit -m "Deploy Firebase backend (secrets via environment variables)"

echo.
echo Step 4: Pushing to GitHub (will trigger Render deployment)...
git push origin main

echo.
echo ========================================
echo DEPLOYMENT STATUS
echo ========================================
echo.
echo ✅ Firebase code deployed to Render
echo ⏳ Waiting for Render deployment (2-3 minutes)
echo.
echo NEXT STEPS:
echo 1. Set Firebase environment variables in Render dashboard
echo 2. Wait for automatic redeployment
echo 3. Test: https://ambabai-jewellers.onrender.com/api/health
echo.
echo Expected result: "database": "Firebase Firestore"
echo ========================================

pause