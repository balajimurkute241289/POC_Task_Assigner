@echo off
echo 🚀 Setting up Mobile Task Assignment Application (Windows)...
echo.

echo [INFO] Checking prerequisites...

REM Check Java
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Java is not installed. Please install Java 17 or higher.
    pause
    exit /b 1
) else (
    echo [SUCCESS] Java is installed
)

REM Check Gradle
gradle -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Gradle is not installed. Will use Gradle wrapper.
) else (
    echo [SUCCESS] Gradle is installed
)

echo.
echo [INFO] Creating necessary directories...
if not exist "logs" mkdir logs
if not exist "database" mkdir database
echo [SUCCESS] Directories created

echo.
echo [INFO] Setting up backend...
cd backend

REM Check if Gradle wrapper exists
if exist "gradlew.bat" (
    echo [INFO] Using Gradle wrapper...
    call gradlew.bat clean build -x test
) else (
    echo [INFO] Using system Gradle...
    gradle clean build -x test
)

if %errorlevel% neq 0 (
    echo [ERROR] Backend build failed.
    pause
    exit /b 1
)

echo [SUCCESS] Backend built successfully

echo.
echo [INFO] Setup completed successfully!
echo.
echo Next steps:
echo 1. Install PostgreSQL locally or use a cloud database
echo 2. Update backend/src/main/resources/application.yml with your database connection
echo 3. Run the backend: cd backend ^&^& gradlew.bat bootRun
echo 4. Install Flutter for frontend development
echo.
echo For Docker installation:
echo - Download Docker Desktop from https://www.docker.com/products/docker-desktop
echo - Install and restart your computer
echo - Run: docker-compose up -d
echo.
pause
