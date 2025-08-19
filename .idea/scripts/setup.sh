#!/bin/bash

# Mobile Task Assignment Application - Setup Script
# This script sets up the development environment for the mobile task assignment application

set -e

echo "🚀 Setting up Mobile Task Assignment Application..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Docker and Docker Compose are installed"
}

# Check if Java is installed
check_java() {
    if ! command -v java &> /dev/null; then
        print_warning "Java is not installed. Please install Java 17 or higher."
        return 1
    fi
    
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [ "$JAVA_VERSION" -lt 17 ]; then
        print_warning "Java version $JAVA_VERSION detected. Java 17 or higher is recommended."
        return 1
    fi
    
    print_success "Java $JAVA_VERSION is installed"
    return 0
}

# Check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_warning "Flutter is not installed. Please install Flutter 3.16.5 or higher."
        return 1
    fi
    
    print_success "Flutter is installed"
    return 0
}

# Start PostgreSQL database
start_database() {
    print_status "Starting PostgreSQL database..."
    
    # Check if postgres container is already running
    if docker ps | grep -q "task-app-postgres"; then
        print_status "PostgreSQL container is already running"
        return 0
    fi
    
    # Start postgres container
    docker-compose up postgres -d
    
    # Wait for database to be ready
    print_status "Waiting for database to be ready..."
    sleep 10
    
    # Check if database is accessible
    if docker exec task-app-postgres pg_isready -U postgres; then
        print_success "PostgreSQL database is ready"
    else
        print_error "Failed to start PostgreSQL database"
        exit 1
    fi
}

# Build and start backend
start_backend() {
    print_status "Building and starting backend..."
    
    cd backend
    
    # Check if Maven wrapper exists
    if [ ! -f "./mvnw" ]; then
        print_status "Maven wrapper not found, using system Maven..."
        mvn clean install -DskipTests
    else
        ./mvnw clean install -DskipTests
    fi
    
    # Start the application in background
    if [ -f "./mvnw" ]; then
        ./mvnw spring-boot:run > ../logs/backend.log 2>&1 &
    else
        mvn spring-boot:run > ../logs/backend.log 2>&1 &
    fi
    
    BACKEND_PID=$!
    echo $BACKEND_PID > ../logs/backend.pid
    
    cd ..
    
    # Wait for backend to start
    print_status "Waiting for backend to start..."
    sleep 30
    
    # Check if backend is responding
    if curl -f http://localhost:8080/api/actuator/health > /dev/null 2>&1; then
        print_success "Backend is running on http://localhost:8080"
    else
        print_warning "Backend may not be fully started yet. Check logs/backend.log for details."
    fi
}

# Setup Flutter frontend
setup_frontend() {
    print_status "Setting up Flutter frontend..."
    
    cd frontend
    
    # Get Flutter dependencies
    flutter pub get
    
    # Check if Flutter doctor passes
    if flutter doctor; then
        print_success "Flutter setup completed"
    else
        print_warning "Flutter doctor reported issues. Please resolve them manually."
    fi
    
    cd ..
}

# Create necessary directories
create_directories() {
    print_status "Creating necessary directories..."
    
    mkdir -p logs
    mkdir -p database/migrations
    mkdir -p frontend/assets/images
    mkdir -p frontend/assets/icons
    mkdir -p frontend/assets/fonts
    
    print_success "Directories created"
}

# Display setup information
display_info() {
    echo ""
    echo "🎉 Setup completed successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Backend API: http://localhost:8080"
    echo "2. Database: PostgreSQL on localhost:5432"
    echo "3. Frontend: Run 'cd frontend && flutter run'"
    echo ""
    echo "📚 Useful commands:"
    echo "- View backend logs: tail -f logs/backend.log"
    echo "- Stop backend: kill \$(cat logs/backend.pid)"
    echo "- Restart database: docker-compose restart postgres"
    echo "- View all logs: docker-compose logs -f"
    echo ""
    echo "📖 Documentation:"
    echo "- Development Guide: DEVELOPMENT_GUIDE.md"
    echo "- API Documentation: http://localhost:8080/swagger-ui.html"
    echo ""
}

# Main setup function
main() {
    print_status "Starting setup process..."
    
    # Create directories first
    create_directories
    
    # Check prerequisites
    check_docker
    check_java
    check_flutter
    
    # Start services
    start_database
    start_backend
    setup_frontend
    
    # Display information
    display_info
}

# Run main function
main "$@"
