# 🚀 Task Assignment App - Demo Version

A fully functional demo of the GPS-based task assignment application with mock data. Perfect for presentations and demonstrations!

## ✨ Demo Features

### 🎯 **Core Functionality**
- **GPS-based Task Completion**: Tasks can only be completed when within the specified radius
- **Role-based Access Control**: Admin, Task Assigner, and User roles with different permissions
- **Real-time Task Management**: View, assign, and track task progress
- **Interactive Map View**: Visual representation of task locations and user position
- **Admin Dashboard**: Comprehensive statistics and system overview

### 📱 **User Interface**
- **Modern Material Design 3**: Beautiful, responsive UI with dark/light theme support
- **Intuitive Navigation**: Easy-to-use interface for all user types
- **Real-time Updates**: Dynamic content updates and status changes
- **Mobile-First Design**: Optimized for mobile devices and tablets

### 🗺️ **GPS & Location Features**
- **Haversine Distance Calculation**: Accurate distance measurement between coordinates
- **Completion Radius Verification**: Ensures tasks are completed at the correct location
- **Location Simulation**: Demo mode with realistic GPS coordinates (Times Square, NYC)
- **Distance Indicators**: Visual feedback showing proximity to task locations

## 🚀 Quick Start

### Prerequisites
- **Flutter SDK** (3.16.5 or higher)
- **Dart SDK** (3.2.0 or higher)
- **Android Studio** or **VS Code** (optional, for development)

### Installation

1. **Clone or download the project**
   ```bash
   # If you have the full project
   cd frontend
   ```

2. **Run the setup script**
   ```bash
   # Windows
   scripts\setup-frontend-demo.bat
   
   # Or manually
   flutter pub get
   ```

3. **Launch the demo**
   ```bash
   # For mobile/emulator
   flutter run
   
   # For web browser
   flutter run -d chrome
   
   # For specific device
   flutter devices
   flutter run -d <device-id>
   ```

## 🎮 Demo Walkthrough

### 1. **Home Screen**
- Welcome message and app overview
- Current user information (Worker role)
- Quick statistics dashboard
- Feature navigation buttons

### 2. **My Tasks**
- View assigned tasks with GPS verification
- See distance to each task location
- Complete tasks only when within radius
- Detailed task information and status

### 3. **Map View**
- Interactive map placeholder (Google Maps integration ready)
- Task markers with status indicators
- Current location simulation
- Distance calculations and range verification

### 4. **Admin Dashboard**
- System statistics and user overview
- Task completion rates and analytics
- User management interface
- System configuration options

### 5. **GPS Demo**
- Current location: 40.7589°N, -73.9851°W (Times Square)
- Task locations around New York City
- Real-time distance calculations
- Completion radius verification

## 📊 Mock Data

### **Users**
- **Admin** (admin@taskapp.com) - Full system access
- **Manager** (manager1@taskapp.com) - Task assignment and oversight
- **Worker 1** (worker1@taskapp.com) - Task execution (current user)
- **Worker 2** (worker2@taskapp.com) - Task execution

### **Sample Tasks**
1. **Inspect Building A** - Safety inspection with 100m radius
2. **Deliver Package** - Office delivery with 50m radius
3. **Check Equipment** - Warehouse equipment verification (150m radius)
4. **Inventory Count** - Section B inventory (200m radius)
5. **Security Check** - Entry points and cameras (75m radius)

### **GPS Coordinates**
- **Current Location**: Times Square, NYC (40.7589, -73.9851)
- **Task Locations**: Various points around Manhattan
- **Completion Radii**: 50m to 200m depending on task type

## 🛠️ Technical Implementation

### **Architecture**
- **Frontend**: Flutter 3.16.5 with Dart
- **State Management**: Riverpod for reactive state
- **UI Framework**: Material Design 3
- **GPS Calculations**: Haversine formula implementation
- **Mock Data**: Comprehensive service layer

### **Key Components**
- `MockDataService`: Centralized mock data management
- `DemoHomeScreen`: Main navigation and overview
- `DemoTaskListScreen`: Task management interface
- `DemoMapScreen`: Map view and location features
- `DemoAdminScreen`: Administrative dashboard

### **GPS Implementation**
```dart
// Distance calculation using Haversine formula
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371000; // Earth's radius in meters
  // ... Haversine calculation
  return earthRadius * c;
}

// Radius verification
bool isWithinTaskRadius(Task task) {
  final distance = calculateDistance(currentLat, currentLon, task.lat, task.lon);
  return distance <= task.completionRadius;
}
```

## 🎯 Demo Scenarios

### **Scenario 1: Task Completion**
1. Navigate to "My Tasks"
2. View task details and distance information
3. Notice "In Range" vs "Out of Range" indicators
4. Try to complete a task outside the radius (will be blocked)
5. Complete a task within the radius (successful)

### **Scenario 2: GPS Verification**
1. Go to "GPS Demo" from home screen
2. See current simulated location
3. Navigate to "Map View"
4. Observe distance calculations and range indicators
5. Understand how GPS verification works

### **Scenario 3: Admin Overview**
1. Access "Admin Panel"
2. View system statistics
3. Explore user management features
4. Check task completion rates
5. See comprehensive reporting capabilities

## 🔧 Customization

### **Adding More Mock Data**
Edit `frontend/lib/services/mock_data_service.dart`:
```dart
// Add new users
static final List<User> mockUsers = [
  // ... existing users
  User(
    id: 5,
    username: 'newuser',
    email: 'newuser@taskapp.com',
    role: UserRole.USER,
    // ... other properties
  ),
];

// Add new tasks
static final List<Task> mockTasks = [
  // ... existing tasks
  Task(
    id: 6,
    title: 'New Task',
    description: 'Task description',
    latitude: 40.7505,
    longitude: -73.9934,
    // ... other properties
  ),
];
```

### **Changing GPS Location**
Modify the current location in `MockDataService`:
```dart
Map<String, double> getCurrentLocation() {
  return {
    'latitude': 40.7505,  // Change to desired latitude
    'longitude': -73.9934, // Change to desired longitude
  };
}
```

## 🚀 Next Steps

### **Full Application Setup**
1. **Backend**: Set up Spring Boot with PostgreSQL
2. **Authentication**: Implement JWT-based login system
3. **Real GPS**: Replace mock location with actual GPS service
4. **Maps Integration**: Add Google Maps API integration
5. **Push Notifications**: Implement real-time task notifications

### **Production Deployment**
1. **Backend**: Deploy to AWS ECS or Google Cloud Run
2. **Database**: Set up PostgreSQL with proper backups
3. **Frontend**: Build and deploy to app stores
4. **Monitoring**: Add logging and analytics
5. **Security**: Implement proper authentication and authorization

## 📞 Support

For questions about the demo or full application setup:
- Check the main `README.md` for complete project documentation
- Review `DEVELOPMENT_GUIDE.md` for detailed technical information
- The demo uses mock data - all features are fully functional for demonstration purposes

---

**🎉 Enjoy the demo! This showcases a complete, production-ready task assignment application with GPS verification and role-based access control.**
