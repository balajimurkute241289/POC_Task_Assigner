@echo off
echo 🚀 Quick Start - Task Assignment App Demo
echo =========================================
echo.

echo [INFO] This script will help you get the demo running quickly
echo [INFO] Choose your preferred method:
echo.

echo 1. Install Flutter and run on mobile device/emulator
echo 2. Run on web browser (requires Flutter)
echo 3. View project structure and documentation
echo 4. Exit
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto :mobile_setup
if "%choice%"=="2" goto :web_setup
if "%choice%"=="3" goto :view_project
if "%choice%"=="4" goto :exit
goto :invalid_choice

:mobile_setup
echo.
echo [MOBILE SETUP] Installing Flutter for mobile development...
echo.
echo Please follow these steps:
echo.
echo 1. Download Flutter SDK:
echo    https://docs.flutter.dev/get-started/install/windows
echo.
echo 2. Extract to C:\flutter
echo.
echo 3. Add C:\flutter\bin to your PATH
echo.
echo 4. Install Android Studio:
echo    https://developer.android.com/studio
echo.
echo 5. Run this script again after installation
echo.
pause
goto :exit

:web_setup
echo.
echo [WEB SETUP] Setting up for web browser...
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed!
    echo Please install Flutter first:
    echo https://docs.flutter.dev/get-started/install/windows
    pause
    goto :exit
)

echo [SUCCESS] Flutter is installed!
echo [INFO] Setting up web demo...

if exist "frontend" (
    cd frontend
    echo [INFO] Getting dependencies...
    flutter pub get
    
    echo [INFO] Starting web server...
    echo [INFO] The app will open in your browser shortly...
    flutter run -d chrome
) else (
    echo [ERROR] Frontend directory not found!
    echo Please make sure you're in the correct project directory.
    pause
)
goto :exit

:view_project
echo.
echo [PROJECT OVERVIEW] Task Assignment App Demo
echo ==========================================
echo.

echo 📁 Project Structure:
echo ├── frontend/                 # Flutter mobile app
echo │   ├── lib/
echo │   │   ├── models/          # Data models (User, Task, etc.)
echo │   │   ├── services/        # Mock data and GPS calculations
echo │   │   ├── screens/demo/    # Demo screens
echo │   │   ├── config/          # App configuration and themes
echo │   │   └── main.dart        # App entry point
echo │   └── pubspec.yaml         # Flutter dependencies
echo ├── backend/                 # Spring Boot backend (Gradle)
echo ├── scripts/                 # Setup and utility scripts
echo ├── docs/                    # Documentation
echo └── README.md               # Project overview
echo.

echo 🎯 Demo Features:
echo ✓ GPS-based task completion verification
echo ✓ Role-based access control (Admin, Manager, Worker)
echo ✓ Interactive task management
echo ✓ Map view with location features
echo ✓ Admin dashboard with statistics
echo ✓ Modern Material Design 3 UI
echo.

echo 📱 Mock Data:
echo - 4 users with different roles
echo - 5 sample tasks with GPS coordinates
echo - Realistic location simulation (Times Square, NYC)
echo - Distance calculations using Haversine formula
echo.

echo 🚀 Quick Commands:
echo - Run mobile: cd frontend && flutter run
echo - Run web: cd frontend && flutter run -d chrome
echo - Setup: scripts\auto-setup.bat
echo.

echo 📖 Documentation:
echo - DEMO_README.md - Complete demo guide
echo - complete-setup-guide.md - Detailed setup instructions
echo - DEVELOPMENT_GUIDE.md - Full project documentation
echo.

pause
goto :exit

:invalid_choice
echo [ERROR] Invalid choice. Please enter 1-4.
pause
goto :exit

:exit
echo.
echo [INFO] Thank you for using the Task Assignment App Demo!
echo [INFO] For help, check the documentation files.
echo.
