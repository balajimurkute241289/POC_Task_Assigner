@echo off
echo 🚀 Setting up Flutter PATH for your custom installation
echo ======================================================
echo.

echo [INFO] Your Flutter is installed at:
echo C:\Users\Tiaa User\Data\Home_Practice\SW\flutter\flutter
echo.

echo [INFO] Adding Flutter to your PATH permanently...
echo.

REM Add Flutter to PATH permanently
setx PATH "%PATH%;C:\Users\Tiaa User\Data\Home_Practice\SW\flutter\flutter\bin"

if %errorlevel% equ 0 (
    echo [SUCCESS] Flutter PATH has been added permanently!
    echo.
    echo [INFO] You may need to restart your command prompt for changes to take effect.
    echo [INFO] After restarting, you can run 'flutter --version' to verify.
) else (
    echo [ERROR] Failed to add Flutter to PATH.
    echo [INFO] You can manually add this to your PATH:
    echo C:\Users\Tiaa User\Data\Home_Practice\SW\flutter\flutter\bin
)

echo.
echo [INFO] To run the demo app:
echo 1. Restart your command prompt
echo 2. Navigate to the project: cd "C:\Users\Tiaa User\Data\R_P\.idea"
echo 3. Run: cd frontend && flutter run -d chrome
echo.

pause
