@echo off
echo ========================================
echo    Flutter Setup Helper
echo ========================================
echo.

echo Looking for Flutter installation...
echo.

REM Check common Flutter locations
if exist "C:\flutter\bin\flutter.bat" (
    echo ✅ Found Flutter at: C:\flutter
    set FLUTTER_PATH=C:\flutter\bin
    goto :found
)

if exist "C:\src\flutter\bin\flutter.bat" (
    echo ✅ Found Flutter at: C:\src\flutter
    set FLUTTER_PATH=C:\src\flutter\bin
    goto :found
)

if exist "%USERPROFILE%\flutter\bin\flutter.bat" (
    echo ✅ Found Flutter at: %USERPROFILE%\flutter
    set FLUTTER_PATH=%USERPROFILE%\flutter\bin
    goto :found
)

if exist "D:\flutter\bin\flutter.bat" (
    echo ✅ Found Flutter at: D:\flutter
    set FLUTTER_PATH=D:\flutter\bin
    goto :found
)

echo ❌ Flutter not found in common locations.
echo.
echo Please tell me where you extracted Flutter:
echo Example locations:
echo   C:\flutter
echo   C:\src\flutter
echo   D:\flutter
echo   %USERPROFILE%\flutter
echo.
set /p FLUTTER_DIR="Enter Flutter directory path: "

if exist "%FLUTTER_DIR%\bin\flutter.bat" (
    set FLUTTER_PATH=%FLUTTER_DIR%\bin
    goto :found
) else (
    echo ❌ Flutter not found at: %FLUTTER_DIR%
    echo Please check the path and try again.
    pause
    exit /b 1
)

:found
echo.
echo ✅ Flutter found at: %FLUTTER_PATH%
echo.

echo Testing Flutter...
"%FLUTTER_PATH%\flutter.bat" --version
if %errorlevel% neq 0 (
    echo ❌ Flutter test failed
    pause
    exit /b 1
)

echo.
echo ✅ Flutter is working!
echo.

echo Adding Flutter to PATH for this session...
set PATH=%FLUTTER_PATH%;%PATH%

echo.
echo Testing Flutter in PATH...
flutter --version
if %errorlevel% neq 0 (
    echo ❌ PATH setup failed
    pause
    exit /b 1
)

echo.
echo ✅ Flutter is now available in PATH!
echo.

echo Running Flutter Doctor...
flutter doctor

echo.
echo ========================================
echo    Flutter Setup Complete!
echo ========================================
echo.
echo Flutter is now ready to use in this terminal session.
echo.
echo To make this permanent:
echo 1. Open System Properties → Environment Variables
echo 2. Add "%FLUTTER_PATH%" to your PATH
echo 3. Restart terminal
echo.
echo Ready to build your mobile app!
echo Run: build-now.bat
echo.
pause