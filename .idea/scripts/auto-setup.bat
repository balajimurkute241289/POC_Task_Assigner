@echo off
echo 🚀 Automated Flutter Mobile Setup Guide
echo ======================================
echo.

echo [INFO] This script will help you set up Flutter for mobile development
echo [INFO] Please follow the prompts and instructions carefully
echo.

set /p choice="Do you want to proceed with Flutter setup? (y/n): "
if /i "%choice%" neq "y" (
    echo Setup cancelled.
    pause
    exit /b 0
)

echo.
echo [STEP 1] Checking current system...
echo.

REM Check if Flutter is already installed
flutter --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] Flutter is already installed!
    goto :check_android
) else (
    echo [INFO] Flutter is not installed. Let's install it.
)

echo.
echo [STEP 2] Flutter Installation Instructions
echo ==========================================
echo.
echo Please follow these steps to install Flutter:
echo.
echo 1. Download Flutter SDK:
echo    - Go to: https://docs.flutter.dev/get-started/install/windows
echo    - Click "Flutter SDK" download button
echo    - Save the zip file to your Downloads folder
echo.
echo 2. Extract Flutter:
echo    - Extract the zip file to C:\flutter
echo    - Make sure the path is: C:\flutter\bin\flutter.bat
echo.
echo 3. Add to PATH:
echo    - Press Win + R, type "sysdm.cpl", press Enter
echo    - Click "Environment Variables"
echo    - Under "System Variables", find "Path", click "Edit"
echo    - Click "New", add: C:\flutter\bin
echo    - Click "OK" on all dialogs
echo.
echo 4. Restart your command prompt
echo.

set /p flutter_installed="Have you completed the Flutter installation? (y/n): "
if /i "%flutter_installed%" neq "y" (
    echo Please complete the Flutter installation first.
    echo You can run this script again when ready.
    pause
    exit /b 1
)

:check_android
echo.
echo [STEP 3] Checking Android Studio...
echo.

REM Check if Android Studio is installed
where adb >nul 2>&1
if %errorlevel% equ 0 (
    echo [SUCCESS] Android SDK is available!
) else (
    echo [INFO] Android Studio/SDK not found.
    echo.
    echo Please install Android Studio:
    echo 1. Go to: https://developer.android.com/studio
    echo 2. Download and install Android Studio
    echo 3. During installation, make sure to install Android SDK
    echo 4. Set ANDROID_HOME environment variable to:
    echo    C:\Users\%USERNAME%\AppData\Local\Android\Sdk
    echo.
    set /p android_installed="Have you installed Android Studio? (y/n): "
    if /i "%android_installed%" neq "y" (
        echo Please install Android Studio first.
        pause
        exit /b 1
    )
)

echo.
echo [STEP 4] Running Flutter Doctor...
echo.

REM Check Flutter installation
flutter doctor

echo.
echo [STEP 5] Setting up the demo project...
echo.

REM Navigate to frontend directory
if exist "frontend" (
    cd frontend
    echo [INFO] Getting Flutter dependencies...
    flutter pub get
    
    echo.
    echo [STEP 6] Available devices...
    echo.
    flutter devices
    
    echo.
    echo [SUCCESS] Setup complete!
    echo.
    echo [INFO] To run the demo app:
    echo 1. Make sure you have an emulator running or device connected
    echo 2. Run: flutter run
    echo 3. For web: flutter run -d chrome
    echo.
    echo [INFO] Demo features:
    echo - GPS-based task completion verification
    echo - Role-based access control
    echo - Interactive task management
    echo - Map view with locations
    echo - Admin dashboard with statistics
    echo.
    
    set /p run_demo="Do you want to run the demo now? (y/n): "
    if /i "%run_demo%" equ "y" (
        echo [INFO] Starting demo app...
        flutter run
    )
) else (
    echo [ERROR] Frontend directory not found!
    echo Please make sure you're in the correct project directory.
)

echo.
echo [INFO] Setup process completed!
echo [INFO] Check the complete-setup-guide.md for detailed instructions.
echo.
pause
