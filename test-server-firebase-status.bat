@echo off
echo ========================================
echo TESTING SERVER FIREBASE STATUS
echo Ambabai Jewellers - Server Check
echo ========================================

echo.
echo 🔍 Checking server health status...
echo.

curl -s https://ambabai-jewellers.onrender.com/api/health

echo.
echo.
echo ========================================
echo ANALYSIS:
echo ========================================
echo.
echo If you see "Firebase Firestore" - ✅ Firebase is working
echo If you see "SQLite" - ❌ Environment variables missing
echo.
echo If SQLite is shown, follow these steps:
echo 1. Go to: https://dashboard.render.com/
echo 2. Find: ambabai-jewellers service
echo 3. Add Firebase environment variables
echo 4. Wait for redeployment
echo.
echo See FIREBASE_ENVIRONMENT_FIX.md for detailed instructions
echo ========================================

pause