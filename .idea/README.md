# Mobile Task Assignment Application

A comprehensive mobile application with role-based access control for task assignment and management, featuring GPS-based task completion verification.

## Project Overview

This application supports three distinct roles:
- **Task Assigner**: Assigns tasks with descriptions and geographical locations
- **User**: Views assigned tasks and completes them only when at the specified GPS location
- **Admin**: Full access to user management, task management, and reporting

## Technology Stack

- **Backend**: Java (Spring Boot)
- **Frontend**: Flutter & Dart
- **Database**: PostgreSQL
- **Authentication**: JWT (JSON Web Tokens)
- **Deployment**: Docker containerization

## Project Structure

```
mobile-task-app/
├── backend/                 # Java Spring Boot application
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile
├── frontend/                # Flutter application
│   ├── lib/
│   ├── pubspec.yaml
│   └── Dockerfile
├── database/                # Database scripts and migrations
├── docs/                    # Documentation
├── docker-compose.yml       # Local development setup
└── README.md               # This file
```

## Quick Start Guide

### Prerequisites

1. **Java Development Kit (JDK) 17 or higher**
2. **Flutter SDK 3.0 or higher**
3. **Docker and Docker Compose**
4. **PostgreSQL 14 or higher**
5. **Git**

### Environment Setup

#### 1. Java Environment Setup
```bash
# Download and install JDK 17+ from Oracle or OpenJDK
# Verify installation
java -version
javac -version
```

#### 2. Flutter Environment Setup
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install
# Add Flutter to PATH
# Verify installation
flutter doctor
```

#### 3. Database Setup
```bash
# Using Docker (recommended)
docker run --name postgres-task-app -e POSTGRES_PASSWORD=password -e POSTGRES_DB=taskapp -p 5432:5432 -d postgres:14

# Or install PostgreSQL locally
```

### Local Development

1. **Clone and Setup**
```bash
git clone <repository-url>
cd mobile-task-app
```

2. **Start Backend**
```bash
cd backend
./gradlew bootRun
```

3. **Start Frontend**
```bash
cd frontend
flutter pub get
flutter run
```

4. **Using Docker Compose (Alternative)**
```bash
docker-compose up -d
```

## Development Guide

### Phase 1: Environment Setup and Project Structure

#### 1.1 Backend Setup (Java/Spring Boot)
- Create Spring Boot project with Gradle dependencies:
  - Spring Web
  - Spring Data JPA
  - Spring Security
  - PostgreSQL Driver
  - JWT Dependencies
  - Validation

#### 1.2 Frontend Setup (Flutter)
- Create Flutter project
- Add dependencies for:
  - HTTP requests (dio)
  - State management (provider/riverpod)
  - GPS location (geolocator)
  - Maps (google_maps_flutter)
  - Local storage (shared_preferences)

#### 1.3 Database Design
- Users table (id, username, email, password_hash, role, created_at)
- Tasks table (id, title, description, latitude, longitude, assigner_id, assignee_id, status, created_at)
- Task_Completions table (id, task_id, user_id, completed_at, gps_latitude, gps_longitude)

### Phase 2: Backend Development

#### 2.1 Authentication System
- JWT-based authentication
- Role-based authorization
- Password encryption with BCrypt
- Token refresh mechanism

#### 2.2 API Endpoints

**Authentication:**
- POST /api/auth/login
- POST /api/auth/register
- POST /api/auth/refresh

**Tasks (Task Assigner):**
- POST /api/tasks (create task)
- GET /api/tasks/assigned (get assigned tasks)
- PUT /api/tasks/{id} (update task)
- DELETE /api/tasks/{id} (delete task)

**Tasks (User):**
- GET /api/tasks/my-tasks (get user's tasks)
- POST /api/tasks/{id}/complete (complete task with GPS verification)

**Admin:**
- GET /api/admin/users (get all users)
- GET /api/admin/tasks (get all tasks)
- GET /api/admin/reports (get reports)

#### 2.3 GPS Location Verification
- Calculate distance between user's GPS and task location
- Default radius: 100 meters (configurable)
- Use Haversine formula for distance calculation

### Phase 3: Frontend Development

#### 3.1 Authentication Screens
- Login screen
- Registration screen
- Password reset

#### 3.2 Task Assigner Interface
- Dashboard with task creation form
- Task list with management options
- Map view for task locations

#### 3.3 User Interface
- Task list with completion status
- Task detail view
- GPS location verification
- Map integration

#### 3.4 Admin Interface
- User management dashboard
- Task overview
- Reporting and analytics
- System settings

### Phase 4: Testing Strategy

#### 4.1 Backend Testing
- Unit tests with JUnit 5
- Integration tests with TestContainers
- API tests with RestAssured

#### 4.2 Frontend Testing
- Widget tests
- Integration tests
- Mock GPS location testing

#### 4.3 End-to-End Testing
- Complete user workflows
- Cross-platform testing
- Performance testing

### Phase 5: Deployment

#### 5.1 Docker Containerization
- Multi-stage builds for optimization
- Environment-specific configurations
- Health checks and monitoring

#### 5.2 Cloud Deployment
- AWS/Google Cloud/Azure setup
- CI/CD pipeline configuration
- Database migration strategies

## Technical Decisions

### Database: PostgreSQL
- **Reasoning**: Robust, ACID-compliant, excellent JSON support, free and open-source
- **Schema**: Normalized design with proper indexing for GPS queries

### Authentication: JWT
- **Reasoning**: Stateless, scalable, works well with mobile apps
- **Implementation**: Access tokens (15min) + refresh tokens (7 days)

### GPS Radius: 100 meters
- **Reasoning**: Balances accuracy with usability
- **Configurability**: Admin can adjust per task or globally

### Error Handling & Logging
- Structured logging with SLF4J + Logback
- Global exception handling
- User-friendly error messages
- Audit logging for security events

### API Security
- HTTPS enforcement
- Input validation and sanitization
- Rate limiting
- CORS configuration
- SQL injection prevention

## Claude Integration

### Development Workflow
1. **Code Generation**: Use Claude for boilerplate code, API endpoints, and UI components
2. **Debugging**: Share error logs and stack traces for analysis
3. **Documentation**: Generate API documentation and code comments
4. **Testing**: Create test cases and scenarios

### Best Practices
- Provide clear context and requirements
- Review and test generated code
- Iterate on solutions
- Document decisions and trade-offs

## Reporting Features (Admin)

1. **Task Completion Reports**
   - Completion rates by user/team
   - Time-to-completion analysis
   - Location accuracy statistics

2. **User Activity Reports**
   - Login frequency
   - Task assignment patterns
   - Performance metrics

3. **System Health Reports**
   - API usage statistics
   - Error rates and types
   - Database performance metrics

## Next Steps

1. Set up the development environment
2. Create the project structure
3. Implement the database schema
4. Develop the backend API
5. Create the Flutter frontend
6. Implement GPS integration
7. Add comprehensive testing
8. Deploy and monitor

## Support and Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Flutter Documentation](https://flutter.dev/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [JWT.io](https://jwt.io/)

---

**Note**: This guide assumes development with Claude's assistance for code generation, debugging, and documentation. Each phase can be developed iteratively with continuous testing and refinement.
