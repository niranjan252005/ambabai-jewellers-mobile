@echo off
echo ========================================
echo TEST SERVER STATUS
echo Checking Firebase Backend Deployment
echo ========================================

echo.
echo Testing health endpoint...
curl -s https://ambabai-jewellers.onrender.com/api/health

echo.
echo.
echo Testing debug users endpoint...
curl -s https://ambabai-jewellers.onrender.com/api/debug/users

echo.
echo.
echo ========================================
echo If you see "Firebase Firestore" above, 
echo the Firebase backend is working!
echo ========================================
pause