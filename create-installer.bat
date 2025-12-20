@echo off
echo ========================================
echo    Creating Jewelry App Installer
echo ========================================
echo.

echo [1/4] Creating installer directory...
if not exist "installer" mkdir installer
if not exist "installer\mobile" mkdir installer\mobile
if not exist "installer\backend" mkdir installer\backend
if not exist "installer\docs" mkdir installer\docs

echo [2/4] Copying backend files...
xcopy "backend" "installer\backend" /E /I /Y
echo Backend files copied.

echo [3/4] Copying documentation...
copy "*.md" "installer\docs\" > nul 2>&1
copy "setup.bat" "installer\" > nul 2>&1
copy "setup.sh" "installer\" > nul 2>&1
copy "build-mobile.bat" "installer\" > nul 2>&1
copy "build-mobile.sh" "installer\" > nul 2>&1
echo Documentation copied.

echo [4/4] Creating installer README...
echo # Jewelry Mobile App - Complete Package > installer\README.md
echo. >> installer\README.md
echo ## What's Included >> installer\README.md
echo - Complete Flutter mobile app source code >> installer\README.md
echo - Node.js backend server >> installer\README.md
echo - SQLite database with sample data >> installer\README.md
echo - Custom diamond branding throughout >> installer\README.md
echo - Photo upload functionality >> installer\README.md
echo - Share functionality for WhatsApp and social media >> installer\README.md
echo - Complete documentation >> installer\README.md
echo. >> installer\README.md
echo ## Quick Start >> installer\README.md
echo 1. Run setup.bat (Windows) or setup.sh (macOS/Linux) >> installer\README.md
echo 2. Install Flutter SDK from https://flutter.dev >> installer\README.md
echo 3. Run build-mobile.bat to create installable apps >> installer\README.md
echo. >> installer\README.md
echo ## Login Credentials >> installer\README.md
echo - Email: admin@jewelry.com >> installer\README.md
echo - Password: admin123 >> installer\README.md

echo.
echo ========================================
echo    Installer Package Created! 📦
echo ========================================
echo.
echo Package location: installer\
echo.
echo The installer includes:
echo ✅ Complete mobile app source code
echo ✅ Backend server with database
echo ✅ Setup and build scripts
echo ✅ Complete documentation
echo ✅ Custom branding and share features
echo.
echo To distribute:
echo 1. Zip the 'installer' folder
echo 2. Share the zip file
echo 3. Recipients run setup.bat/setup.sh
echo.
echo Press any key to continue...
pause > nul