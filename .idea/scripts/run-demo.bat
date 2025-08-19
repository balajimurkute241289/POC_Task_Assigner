@echo off
echo 🚀 Starting Task Assignment App Demo
echo ====================================
echo.

echo [INFO] Setting up Flutter path...
set PATH=%PATH%;C:\Users\Tiaa User\Data\Home_Practice\SW\flutter\flutter\bin

echo [INFO] Navigating to frontend directory...
cd /d "%~dp0..\frontend"

echo [INFO] Starting Flutter app in Chrome...
echo [INFO] The app will open in your browser shortly...
echo.

flutter run -d chrome

echo.
echo [INFO] Demo app started successfully!
echo [INFO] You can now showcase your mobile task assignment application.
echo.
pause
