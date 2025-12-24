@echo off
echo ========================================
echo   LOCALHOST DEMO - AMBABAI JEWELLERS
echo   No-Approval System Demo
echo ========================================
echo.
echo Starting local server to demonstrate the updated system...
echo.
echo.
echo STEP 1: Navigate to backend directory
echo ========================================
echo.
cd backend
if %errorlevel% neq 0 (
    echo ❌ Backend directory not found
    echo Make sure you're in the correct project directory
    pause
    exit /b 1
)
echo.
echo ✅ In backend directory
echo.
echo.
echo STEP 2: Install dependencies (if needed)
echo ========================================
echo.
echo Checking if node_modules exists...
if not exist "node_modules" (
    echo Installing dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo ❌ Failed to install dependencies
        pause
        exit /b 1
    )
    echo ✅ Dependencies installed
) else (
    echo ✅ Dependencies already installed
)
echo.
echo.
echo STEP 3: Start the server
echo ========================================
echo.
echo 🚀 Starting Ambabai Jewellers server...
echo.
echo Server will start on: http://localhost:3000
echo.
echo ========================================
echo   DEMO FEATURES TO TEST:
echo ========================================
echo.
echo 🧪 Customer Registration:
echo 1. Go to: http://localhost:3000
echo 2. Click "New Customer" tab
echo 3. Register a test account
echo 4. Should show "You can login immediately!"
echo 5. Try logging in right away - should work!
echo.
echo 👑 Admin Panel:
echo 1. Login as admin: admin@jewelry.com / admin123
echo 2. Go to "Manage Users" (updated from "Manage Customer Approvals")
echo 3. Should see all users with "Delete User" buttons
echo 4. No more approval workflow needed
echo.
echo 💎 Jewelry Features:
echo 1. Browse jewelry catalog
echo 2. Search with SKU codes
echo 3. Add items to cart
echo 4. Place orders
echo 5. WhatsApp sharing
echo.
echo 📱 Mobile-Responsive:
echo 1. Resize browser window
echo 2. Test on mobile device
echo 3. All features work on mobile
echo.
echo.
echo ========================================
echo   ADMIN CREDENTIALS:
echo ========================================
echo.
echo Email: admin@jewelry.com
echo Password: admin123
echo.
echo OR create new admin:
echo Email: barwadeniranjan@gmail.com
echo Password: admin123
echo.
echo.
echo ========================================
echo   WHAT'S NEW IN THIS VERSION:
echo ========================================
echo.
echo ✅ No user approval required
echo ✅ Immediate login after registration
echo ✅ Admin can delete users instead of approving
echo ✅ Simplified user experience
echo ✅ Better customer satisfaction
echo ✅ Streamlined admin workflow
echo.
echo.
echo Press Ctrl+C to stop the server when done testing
echo.
echo Starting server now...
echo.
npm start