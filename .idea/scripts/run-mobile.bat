@echo off
echo 📱 Running Task Assignment App on Mobile
echo ========================================
echo.

REM Set Flutter path
set PATH=%PATH%;C:\Users\Tiaa User\Data\Home_Practice\SW\flutter\flutter\bin

echo [INFO] Checking available devices...
flutter devices

echo.
echo [INFO] Available options:
echo 1. Android Emulator (requires Android Studio setup)
echo 2. Physical Android Device (requires USB debugging)
echo 3. Web Browser (current working version)
echo.

echo [INFO] To run on mobile:
echo 1. Install Android Studio: https://developer.android.com/studio
echo 2. Create an Android Virtual Device (AVD)
echo 3. Start the emulator
echo 4. Run: flutter run
echo.

echo [INFO] To run on web (current working version):
echo flutter run -d chrome
echo.

echo [INFO] To run on physical device:
echo 1. Enable Developer Options on your phone
echo 2. Enable USB Debugging
echo 3. Connect via USB
echo 4. Run: flutter run
echo.

pause
