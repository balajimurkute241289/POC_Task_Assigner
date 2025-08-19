@echo off
echo 🚀 Setting up Frontend Demo...
echo.

echo [INFO] Checking Flutter installation...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed. Please install Flutter first.
    echo.
    echo To install Flutter:
    echo 1. Download from https://flutter.dev/docs/get-started/install/windows
    echo 2. Extract to C:\flutter
    echo 3. Add C:\flutter\bin to your PATH
    echo 4. Run 'flutter doctor' to verify installation
    pause
    exit /b 1
) else (
    echo [SUCCESS] Flutter is installed
)

echo.
echo [INFO] Setting up Flutter project...
cd frontend

echo [INFO] Getting Flutter dependencies...
flutter pub get

echo.
echo [INFO] Running Flutter doctor...
flutter doctor

echo.
echo [SUCCESS] Frontend demo setup complete!
echo.
echo [INFO] To run the demo:
echo 1. Make sure you're in the frontend directory
echo 2. Run: flutter run
echo 3. Or run: flutter run -d chrome (for web)
echo.
echo [INFO] Demo features available:
echo - GPS-based task completion verification
echo - Role-based access control (Admin, Manager, Worker)
echo - Interactive task management
echo - Map view with task locations
echo - Admin dashboard with statistics
echo - Modern Material Design 3 UI
echo.
pause
