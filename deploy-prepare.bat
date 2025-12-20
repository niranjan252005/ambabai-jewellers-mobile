@echo off
echo 🚀 PREPARING AMBABAI JEWELLERS WEBSITE FOR DEPLOYMENT
echo ================================================

echo.
echo 📁 Creating deployment package...
echo.

REM Create deployment folder
if not exist "deployment" mkdir deployment

REM Copy all necessary files
echo ✅ Copying backend files...
xcopy "backend" "deployment\backend" /E /I /Y

echo ✅ Copying configuration files...
copy "package.json" "deployment\"
copy "vercel.json" "deployment\"
copy "netlify.toml" "deployment\"
copy "render.yaml" "deployment\"
copy "railway.json" "deployment\"
copy "Procfile" "deployment\"

echo ✅ Copying documentation...
copy "DEPLOYMENT_GUIDE.md" "deployment\"
copy "COMPLETE_WEBSITE_READY.md" "deployment\"
copy "README.md" "deployment\"

echo.
echo 🎉 DEPLOYMENT PACKAGE READY!
echo ================================
echo.
echo 📂 Your deployment files are in the 'deployment' folder
echo.
echo 🌐 NEXT STEPS:
echo 1. Go to https://railway.app (RECOMMENDED - FREE & EASY)
echo 2. Sign up with GitHub
echo 3. Create new project
echo 4. Upload the 'deployment' folder contents
echo 5. Get your live website link!
echo.
echo 📖 Read DEPLOYMENT_GUIDE.md for detailed instructions
echo.
echo 🏪 Your Ambabai Jewellers website will be live soon!
echo.
pause