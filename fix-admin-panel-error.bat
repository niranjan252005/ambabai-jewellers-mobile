@echo off
echo ========================================
echo   FIX ADMIN PANEL ERROR
echo   Ambabai Jewellers - Network Error Fix
echo ========================================
echo.
echo Issue: "Network error: Unexpected token '<', '"
echo This happens when server returns HTML instead of JSON
echo.
echo.
echo STEP 1: Check if server is running
echo ========================================
echo.
echo Checking server status...
curl -s http://localhost:3000/api/health
if %errorlevel% neq 0 (
    echo ❌ Server is not running locally
    echo.
    echo Checking live server...
    curl -s https://ambabai-jewellers.onrender.com/api/health
    if %errorlevel% neq 0 (
        echo ❌ Live server is also not responding
        echo.
        echo SOLUTION: Start the backend server
        echo Run: cd backend && npm start
    ) else (
        echo ✅ Live server is running
        echo Issue might be with API endpoints
    )
) else (
    echo ✅ Local server is running
)
echo.
echo.
echo STEP 2: Test admin API endpoints
echo ========================================
echo.
echo Testing user management API...
curl -s https://ambabai-jewellers.onrender.com/api/debug/pending-users
echo.
echo.
echo STEP 3: Restart backend server
echo ========================================
echo.
echo If server is running but still showing errors:
echo.
echo 1. Stop the server (Ctrl+C)
echo 2. Restart with: npm start
echo 3. Check for any error messages
echo.
echo.
echo STEP 4: Check server logs
echo ========================================
echo.
echo Look for these error patterns in server console:
echo - Database connection errors
echo - JWT token errors  
echo - CORS errors
echo - Route not found errors
echo.
echo.
echo STEP 5: Alternative - Use debug endpoints
echo ========================================
echo.
echo Try these debug URLs in browser:
echo.
echo https://ambabai-jewellers.onrender.com/api/debug/pending-users
echo https://ambabai-jewellers.onrender.com/api/debug/all-users
echo.
echo These don't require authentication and will show if server is working.
echo.
echo.
echo ========================================
echo   COMMON SOLUTIONS:
echo ========================================
echo.
echo 1. SERVER NOT RUNNING:
echo    - cd backend
echo    - npm start
echo.
echo 2. CORS ISSUES:
echo    - Server already has CORS enabled
echo    - Try refreshing the page
echo.
echo 3. AUTHENTICATION ISSUES:
echo    - Logout and login again
echo    - Clear browser cache
echo.
echo 4. DATABASE ISSUES:
echo    - Check if database file exists
echo    - Restart server to recreate tables
echo.
echo.
echo ========================================
echo   QUICK FIX:
echo ========================================
echo.
echo 1. Open new terminal
echo 2. cd backend
echo 3. npm start
echo 4. Refresh admin panel
echo 5. Try customer approval again
echo.
echo Your admin panel should work after server restart!
echo.
echo Press any key to continue...
pause > nul