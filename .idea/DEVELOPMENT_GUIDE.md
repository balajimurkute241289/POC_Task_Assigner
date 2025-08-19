# Mobile Task Assignment Application - Development Guide

## Table of Contents

1. [Project Overview](#project-overview)
2. [Technical Decisions](#technical-decisions)
3. [Environment Setup](#environment-setup)
4. [Backend Development](#backend-development)
5. [Frontend Development](#frontend-development)
6. [Testing Strategy](#testing-strategy)
7. [Deployment](#deployment)
8. [Claude Integration](#claude-integration)
9. [Troubleshooting](#troubleshooting)

## Project Overview

This guide provides comprehensive instructions for developing a mobile task assignment application with role-based access control and GPS-based task completion verification. The application supports three distinct roles:

- **Task Assigner**: Creates and assigns tasks with geographical locations
- **User**: Views assigned tasks and completes them only when at the specified GPS location
- **Admin**: Full access to user management, task management, and reporting

### Technology Stack

- **Backend**: Java 17 + Spring Boot 3.2.0
- **Frontend**: Flutter 3.16.5 + Dart
- **Database**: PostgreSQL 14
- **Authentication**: JWT (JSON Web Tokens)
- **Deployment**: Docker + Docker Compose
- **GPS**: Haversine formula for distance calculations

## Technical Decisions

### 1. Database Selection: PostgreSQL

**Decision**: PostgreSQL 14
**Reasoning**:
- **ACID Compliance**: Ensures data integrity for critical task assignments
- **JSON Support**: Excellent support for storing additional task metadata
- **Spatial Extensions**: Built-in support for geographical queries (PostGIS extension available)
- **Performance**: Optimized for complex queries and large datasets
- **Open Source**: Free and community-driven
- **Scalability**: Handles concurrent users efficiently

**Schema Design**:
```sql
-- Users table with role-based access
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'TASK_ASSIGNER', 'USER')),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tasks table with geographical coordinates
CREATE TABLE tasks (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    completion_radius DOUBLE PRECISION DEFAULT 100.0,
    status VARCHAR(20) DEFAULT 'PENDING',
    assigner_id BIGINT REFERENCES users(id),
    assignee_id BIGINT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Task completions with GPS verification
CREATE TABLE task_completions (
    id BIGSERIAL PRIMARY KEY,
    task_id BIGINT REFERENCES tasks(id),
    user_id BIGINT REFERENCES users(id),
    gps_latitude DOUBLE PRECISION NOT NULL,
    gps_longitude DOUBLE PRECISION NOT NULL,
    distance_from_target DOUBLE PRECISION,
    completion_verified BOOLEAN DEFAULT false,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verification_notes TEXT
);

-- Indexes for performance
CREATE INDEX idx_tasks_assignee ON tasks(assignee_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_location ON tasks USING GIST (point(latitude, longitude));
CREATE INDEX idx_completions_task ON task_completions(task_id);
CREATE INDEX idx_completions_user ON task_completions(user_id);
```

### 2. Authentication Method: JWT

**Decision**: JWT (JSON Web Tokens)
**Reasoning**:
- **Stateless**: No server-side session storage required
- **Scalability**: Works well with microservices architecture
- **Mobile-Friendly**: Ideal for mobile applications
- **Security**: Can include user roles and permissions in tokens
- **Performance**: Reduces database queries for authentication

**Implementation**:
- **Access Token**: 15-minute expiration for security
- **Refresh Token**: 7-day expiration for user convenience
- **Token Claims**: User ID, username, role, and permissions
- **Secure Storage**: Encrypted storage on mobile devices

### 3. GPS Radius: 100 meters

**Decision**: 100 meters default radius
**Reasoning**:
- **Accuracy**: Balances GPS accuracy with usability
- **Flexibility**: Admin can adjust per task (10-1000 meters)
- **User Experience**: Not too restrictive for outdoor tasks
- **Indoor Consideration**: Accounts for building entry points

**Configuration**:
```yaml
gps:
  default-radius: 100 # meters
  max-radius: 1000 # meters
  min-radius: 10 # meters
```

### 4. Reporting Features (Admin)

**Required Reports**:
1. **Task Completion Reports**
   - Completion rates by user/team
   - Time-to-completion analysis
   - Location accuracy statistics
   - Task assignment patterns

2. **User Activity Reports**
   - Login frequency and patterns
   - Task assignment distribution
   - Performance metrics
   - User engagement analytics

3. **System Health Reports**
   - API usage statistics
   - Error rates and types
   - Database performance metrics
   - GPS accuracy trends

### 5. Deployment Environment: Docker

**Decision**: Docker containerization with cloud deployment options
**Reasoning**:
- **Consistency**: Same environment across development and production
- **Scalability**: Easy horizontal scaling
- **Portability**: Works on any cloud platform
- **Security**: Isolated containers with minimal attack surface

**Target Platforms**:
- **Development**: Docker Compose (localhost)
- **Production**: AWS ECS, Google Cloud Run, or Azure Container Instances
- **Database**: Managed PostgreSQL service (RDS, Cloud SQL, Azure Database)

### 6. Error Handling & Logging

**Implementation**:
- **Structured Logging**: SLF4J + Logback with JSON format
- **Global Exception Handling**: Centralized error management
- **User-Friendly Messages**: Clear error messages for end users
- **Audit Logging**: Security event tracking
- **Performance Monitoring**: Request/response time tracking

### 7. API Security

**Security Measures**:
- **HTTPS Enforcement**: All API communications encrypted
- **Input Validation**: Comprehensive request validation
- **Rate Limiting**: Prevent abuse and DDoS attacks
- **CORS Configuration**: Controlled cross-origin access
- **SQL Injection Prevention**: Parameterized queries
- **Authentication**: JWT token validation on all protected endpoints

## Environment Setup

### Prerequisites

1. **Java Development Kit (JDK) 17**
   ```bash
   # Download from Oracle or OpenJDK
   java -version
   javac -version
   ```

2. **Flutter SDK 3.16.5**
   ```bash
   # Download from https://flutter.dev/docs/get-started/install
   flutter doctor
   ```

3. **Docker and Docker Compose**
   ```bash
   docker --version
   docker-compose --version
   ```

4. **PostgreSQL 14** (or use Docker)
   ```bash
   # Using Docker (recommended)
   docker run --name postgres-task-app \
     -e POSTGRES_PASSWORD=password \
     -e POSTGRES_DB=taskapp \
     -p 5432:5432 \
     -d postgres:14
   ```

5. **Git**
   ```bash
   git --version
   ```

### Local Development Setup

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd mobile-task-app
   ```

2. **Start Database**
   ```bash
   docker-compose up postgres -d
   ```

3. **Start Backend**
   ```bash
   cd backend
   ./mvnw spring-boot:run
   ```

4. **Start Frontend**
   ```bash
   cd frontend
   flutter pub get
   flutter run
   ```

5. **Using Docker Compose (Alternative)**
   ```bash
   docker-compose up -d
   ```

## Backend Development

### Project Structure

```
backend/
├── src/main/java/com/taskapp/
│   ├── MobileTaskBackendApplication.java
│   ├── config/
│   │   ├── SecurityConfig.java
│   │   ├── CorsConfig.java
│   │   └── SwaggerConfig.java
│   ├── controller/
│   │   ├── AuthController.java
│   │   ├── TaskController.java
│   │   ├── UserController.java
│   │   └── AdminController.java
│   ├── service/
│   │   ├── AuthService.java
│   │   ├── TaskService.java
│   │   ├── UserService.java
│   │   ├── GpsService.java
│   │   └── JwtService.java
│   ├── repository/
│   │   ├── UserRepository.java
│   │   ├── TaskRepository.java
│   │   └── TaskCompletionRepository.java
│   ├── entity/
│   │   ├── User.java
│   │   ├── Task.java
│   │   ├── TaskCompletion.java
│   │   ├── UserRole.java
│   │   └── TaskStatus.java
│   ├── dto/
│   │   ├── LoginRequest.java
│   │   ├── LoginResponse.java
│   │   ├── TaskRequest.java
│   │   └── TaskResponse.java
│   └── exception/
│       ├── GlobalExceptionHandler.java
│       └── CustomExceptions.java
├── src/main/resources/
│   ├── application.yml
│   └── db/migration/
├── src/test/
├── pom.xml
└── Dockerfile
```

### Key Components

1. **Entity Models**: JPA entities with proper relationships
2. **Repositories**: Spring Data JPA repositories for data access
3. **Services**: Business logic implementation
4. **Controllers**: REST API endpoints
5. **Security**: JWT-based authentication and authorization
6. **GPS Service**: Distance calculation and location verification

### API Endpoints

#### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/refresh` - Token refresh
- `POST /api/auth/logout` - User logout

#### Tasks (Task Assigner)
- `POST /api/tasks` - Create new task
- `GET /api/tasks/assigned` - Get assigned tasks
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task

#### Tasks (User)
- `GET /api/tasks/my-tasks` - Get user's tasks
- `POST /api/tasks/{id}/complete` - Complete task with GPS verification

#### Admin
- `GET /api/admin/users` - Get all users
- `GET /api/admin/tasks` - Get all tasks
- `GET /api/admin/reports` - Get reports
- `PUT /api/admin/users/{id}` - Update user
- `DELETE /api/admin/users/{id}` - Delete user

### GPS Implementation

The GPS service uses the Haversine formula to calculate distances:

```java
public double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    double lat1Rad = Math.toRadians(lat1);
    double lon1Rad = Math.toRadians(lon1);
    double lat2Rad = Math.toRadians(lat2);
    double lon2Rad = Math.toRadians(lon2);
    
    double deltaLat = lat2Rad - lat1Rad;
    double deltaLon = lon2Rad - lon1Rad;
    
    double a = Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
               Math.cos(lat1Rad) * Math.cos(lat2Rad) *
               Math.sin(deltaLon / 2) * Math.sin(deltaLon / 2);
    
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    
    return EARTH_RADIUS * c; // 6371000 meters
}
```

## Frontend Development

### Project Structure

```
frontend/
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── app_config.dart
│   │   └── theme.dart
│   ├── models/
│   │   ├── user.dart
│   │   ├── task.dart
│   │   └── api_response.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── location_service.dart
│   │   └── storage_service.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── task_provider.dart
│   │   └── location_provider.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── task_assigner/
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── create_task_screen.dart
│   │   │   └── task_list_screen.dart
│   │   ├── user/
│   │   │   ├── task_list_screen.dart
│   │   │   ├── task_detail_screen.dart
│   │   │   └── map_screen.dart
│   │   └── admin/
│   │       ├── dashboard_screen.dart
│   │       ├── user_management_screen.dart
│   │       └── reports_screen.dart
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── loading_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   └── custom_button.dart
│   │   ├── task/
│   │   │   ├── task_card.dart
│   │   │   └── task_form.dart
│   │   └── map/
│   │       ├── task_map.dart
│   │       └── location_picker.dart
│   └── utils/
│       ├── constants.dart
│       ├── validators.dart
│       └── helpers.dart
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── pubspec.yaml
└── Dockerfile
```

### Key Features

1. **Role-Based UI**: Different interfaces for each user role
2. **GPS Integration**: Real-time location tracking and verification
3. **Offline Support**: Local storage for offline task viewing
4. **Push Notifications**: Task assignment and completion notifications
5. **Map Integration**: Google Maps for task location visualization

### State Management

Using Riverpod for state management:

```dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier(ref.read(taskServiceProvider));
});

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier(ref.read(locationServiceProvider));
});
```

### GPS Implementation

```dart
class LocationService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException();
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static double calculateDistance(
    double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
```

## Testing Strategy

### Backend Testing

1. **Unit Tests** (JUnit 5)
   ```java
   @Test
   void testGpsDistanceCalculation() {
       GpsService gpsService = new GpsService();
       double distance = gpsService.calculateDistance(40.7128, -74.0060, 40.7589, -73.9851);
       assertThat(distance).isBetween(4000.0, 5000.0); // NYC to Times Square
   }
   ```

2. **Integration Tests** (TestContainers)
   ```java
   @Testcontainers
   @SpringBootTest
   class TaskControllerIntegrationTest {
       @Container
       static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:14");
   }
   ```

3. **API Tests** (RestAssured)
   ```java
   @Test
   void testCreateTask() {
       given()
           .header("Authorization", "Bearer " + token)
           .contentType(ContentType.JSON)
           .body(taskRequest)
       .when()
           .post("/api/tasks")
       .then()
           .statusCode(201)
           .body("title", equalTo("Test Task"));
   }
   ```

### Frontend Testing

1. **Widget Tests**
   ```dart
   testWidgets('Task card displays correctly', (WidgetTester tester) async {
     await tester.pumpWidget(TaskCard(task: mockTask));
     expect(find.text('Test Task'), findsOneWidget);
     expect(find.text('Pending'), findsOneWidget);
   });
   ```

2. **Integration Tests**
   ```dart
   testWidgets('Complete task flow', (WidgetTester tester) async {
     await tester.pumpWidget(MyApp());
     await tester.tap(find.text('Complete Task'));
     await tester.pump();
     expect(find.text('Task completed!'), findsOneWidget);
   });
   ```

3. **Mock GPS Testing**
   ```dart
   test('GPS location verification', () async {
     when(mockLocationService.getCurrentLocation())
         .thenAnswer((_) async => Position(
               latitude: 40.7128,
               longitude: -74.0060,
               timestamp: DateTime.now(),
               accuracy: 10.0,
               altitude: 0.0,
               heading: 0.0,
               speed: 0.0,
               speedAccuracy: 0.0,
             ));
   });
   ```

### End-to-End Testing

1. **Complete User Workflows**
   - Task assignment and completion flow
   - GPS verification process
   - Role-based access control
   - Offline functionality

2. **Cross-Platform Testing**
   - Android and iOS compatibility
   - Different screen sizes
   - Various GPS accuracy levels

3. **Performance Testing**
   - API response times
   - GPS update frequency
   - Memory usage optimization

## Deployment

### Docker Deployment

1. **Build Images**
   ```bash
   docker-compose build
   ```

2. **Start Services**
   ```bash
   docker-compose up -d
   ```

3. **Check Health**
   ```bash
   docker-compose ps
   curl http://localhost:8080/api/actuator/health
   ```

### Cloud Deployment

#### AWS Deployment

1. **ECS Fargate**
   ```yaml
   # task-definition.json
   {
     "family": "task-app",
     "networkMode": "awsvpc",
     "requiresCompatibilities": ["FARGATE"],
     "cpu": "256",
     "memory": "512",
     "containerDefinitions": [
       {
         "name": "backend",
         "image": "task-app-backend:latest",
         "portMappings": [{"containerPort": 8080}]
       }
     ]
   }
   ```

2. **RDS PostgreSQL**
   - Multi-AZ deployment for high availability
   - Automated backups and point-in-time recovery
   - Security groups for network isolation

#### Google Cloud Deployment

1. **Cloud Run**
   ```bash
   gcloud run deploy task-app-backend \
     --image gcr.io/PROJECT_ID/task-app-backend \
     --platform managed \
     --region us-central1 \
     --allow-unauthenticated
   ```

2. **Cloud SQL**
   - High availability configuration
   - Automated backups
   - Private IP connectivity

### CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Backend Tests
        run: cd backend && ./mvnw test
      - name: Run Frontend Tests
        run: cd frontend && flutter test

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Cloud
        run: |
          docker-compose -f docker-compose.prod.yml up -d
```

## Claude Integration

### Development Workflow

1. **Code Generation**
   - Use Claude for boilerplate code generation
   - API endpoint implementation
   - UI component creation
   - Database schema design

2. **Debugging Assistance**
   - Share error logs and stack traces
   - Request code review and optimization
   - Performance analysis and suggestions

3. **Documentation**
   - Generate API documentation
   - Create code comments
   - Write user guides and tutorials

4. **Testing**
   - Generate test cases
   - Create mock data
   - Design test scenarios

### Best Practices

1. **Clear Context**: Provide detailed requirements and constraints
2. **Iterative Development**: Build and test incrementally
3. **Code Review**: Always review generated code before implementation
4. **Documentation**: Document decisions and trade-offs
5. **Testing**: Test thoroughly before deployment

### Example Claude Prompts

```
"Generate a Spring Boot controller for task management with the following requirements:
- CRUD operations for tasks
- GPS location validation
- Role-based access control
- Proper error handling
- Swagger documentation"
```

```
"Create a Flutter widget for displaying task information with:
- Task title and description
- Location coordinates
- Completion status
- GPS distance indicator
- Material Design 3 styling"
```

## Troubleshooting

### Common Issues

1. **GPS Permission Denied**
   - Check location permissions in device settings
   - Implement proper permission request flow
   - Handle permission denial gracefully

2. **JWT Token Expired**
   - Implement automatic token refresh
   - Redirect to login on authentication failure
   - Clear stored tokens on logout

3. **Database Connection Issues**
   - Verify PostgreSQL service is running
   - Check connection string configuration
   - Ensure proper network connectivity

4. **Flutter Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Check Flutter SDK version compatibility
   - Verify all dependencies are compatible

### Performance Optimization

1. **Backend**
   - Implement database connection pooling
   - Add appropriate indexes for GPS queries
   - Use caching for frequently accessed data
   - Optimize JPA queries

2. **Frontend**
   - Implement lazy loading for task lists
   - Cache GPS location data
   - Optimize image loading and caching
   - Use efficient state management

### Security Considerations

1. **API Security**
   - Validate all input parameters
   - Implement rate limiting
   - Use HTTPS in production
   - Regular security audits

2. **Data Protection**
   - Encrypt sensitive data at rest
   - Implement proper user authentication
   - Regular backup and recovery testing
   - GDPR compliance considerations

## Conclusion

This development guide provides a comprehensive roadmap for building the mobile task assignment application. The modular architecture allows for easy maintenance and future enhancements. The use of modern technologies ensures scalability, security, and performance.

Key success factors:
- Thorough testing at all levels
- Proper error handling and logging
- Security-first approach
- User experience optimization
- Regular code reviews and documentation

For additional support or questions, refer to the project documentation or contact the development team.
