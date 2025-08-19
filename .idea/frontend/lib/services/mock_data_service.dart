import 'dart:math';
import '../models/user.dart';
import '../models/task.dart';
import '../models/task_completion.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock users
  static final List<User> mockUsers = [
    User(
      id: 1,
      username: 'admin',
      email: 'admin@taskapp.com',
      role: UserRole.ADMIN,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: 2,
      username: 'manager1',
      email: 'manager1@taskapp.com',
      role: UserRole.TASK_ASSIGNER,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    User(
      id: 3,
      username: 'worker1',
      email: 'worker1@taskapp.com',
      role: UserRole.USER,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    User(
      id: 4,
      username: 'worker2',
      email: 'worker2@taskapp.com',
      role: UserRole.USER,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  // Mock tasks with realistic locations
  static final List<Task> mockTasks = [
    Task(
      id: 1,
      title: 'Inspect Building A',
      description: 'Conduct safety inspection of Building A including fire exits and emergency lighting',
      latitude: 40.7128,
      longitude: -74.0060,
      completionRadius: 100.0,
      status: TaskStatus.PENDING,
      assignerId: 2,
      assigneeId: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Task(
      id: 2,
      title: 'Deliver Package to Office',
      description: 'Deliver urgent package to the main office reception desk',
      latitude: 40.7589,
      longitude: -73.9851,
      completionRadius: 50.0,
      status: TaskStatus.IN_PROGRESS,
      assignerId: 2,
      assigneeId: 4,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Task(
      id: 3,
      title: 'Check Equipment Status',
      description: 'Verify all equipment in the warehouse is functioning properly',
      latitude: 40.7505,
      longitude: -73.9934,
      completionRadius: 150.0,
      status: TaskStatus.COMPLETED,
      assignerId: 2,
      assigneeId: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      id: 4,
      title: 'Inventory Count',
      description: 'Perform inventory count for Section B of the warehouse',
      latitude: 40.7484,
      longitude: -73.9857,
      completionRadius: 200.0,
      status: TaskStatus.PENDING,
      assignerId: 2,
      assigneeId: 4,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Task(
      id: 5,
      title: 'Security Check',
      description: 'Complete security check of all entry points and cameras',
      latitude: 40.7527,
      longitude: -73.9772,
      completionRadius: 75.0,
      status: TaskStatus.COMPLETED,
      assignerId: 2,
      assigneeId: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Mock task completions
  static final List<TaskCompletion> mockCompletions = [
    TaskCompletion(
      id: 1,
      taskId: 3,
      userId: 3,
      gpsLatitude: 40.7505,
      gpsLongitude: -73.9934,
      distanceFromTarget: 25.0,
      completionVerified: true,
      completedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    TaskCompletion(
      id: 2,
      taskId: 5,
      userId: 3,
      gpsLatitude: 40.7527,
      gpsLongitude: -73.9772,
      distanceFromTarget: 15.0,
      completionVerified: true,
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Get current user (simulating logged in user)
  User getCurrentUser() {
    return mockUsers[2]; // worker1
  }

  // Get tasks for current user
  List<Task> getTasksForUser(int userId) {
    return mockTasks.where((task) => task.assigneeId == userId).toList();
  }

  // Get tasks assigned by user
  List<Task> getTasksAssignedByUser(int userId) {
    return mockTasks.where((task) => task.assignerId == userId).toList();
  }

  // Get all tasks (for admin)
  List<Task> getAllTasks() {
    return mockTasks;
  }

  // Get all users (for admin)
  List<User> getAllUsers() {
    return mockUsers;
  }

  // Get task completions
  List<TaskCompletion> getTaskCompletions() {
    return mockCompletions;
  }

  // Simulate GPS location (for demo purposes)
  Map<String, double> getCurrentLocation() {
    // Simulate user being near Times Square
    return {
      'latitude': 40.7589,
      'longitude': -73.9851,
    };
  }

  // Calculate distance between two points
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth's radius in meters
    
    double lat1Rad = lat1 * pi / 180;
    double lon1Rad = lon1 * pi / 180;
    double lat2Rad = lat2 * pi / 180;
    double lon2Rad = lon2 * pi / 180;
    
    double deltaLat = lat2Rad - lat1Rad;
    double deltaLon = lon2Rad - lon1Rad;
    
    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
               cos(lat1Rad) * cos(lat2Rad) *
               sin(deltaLon / 2) * sin(deltaLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  // Check if user is within task completion radius
  bool isWithinTaskRadius(Task task) {
    final currentLocation = getCurrentLocation();
    final distance = calculateDistance(
      currentLocation['latitude']!,
      currentLocation['longitude']!,
      task.latitude,
      task.longitude,
    );
    return distance <= task.completionRadius;
  }

  // Get task statistics
  Map<String, dynamic> getTaskStatistics() {
    final totalTasks = mockTasks.length;
    final completedTasks = mockTasks.where((task) => task.status == TaskStatus.COMPLETED).length;
    final pendingTasks = mockTasks.where((task) => task.status == TaskStatus.PENDING).length;
    final inProgressTasks = mockTasks.where((task) => task.status == TaskStatus.IN_PROGRESS).length;

    return {
      'total': totalTasks,
      'completed': completedTasks,
      'pending': pendingTasks,
      'inProgress': inProgressTasks,
      'completionRate': totalTasks > 0 ? (completedTasks / totalTasks * 100).roundToDouble() : 0.0,
    };
  }

  // Get user statistics
  Map<String, dynamic> getUserStatistics() {
    final totalUsers = mockUsers.length;
    final activeUsers = mockUsers.where((user) => user.isActive).length;
    final admins = mockUsers.where((user) => user.role == UserRole.ADMIN).length;
    final assigners = mockUsers.where((user) => user.role == UserRole.TASK_ASSIGNER).length;
    final workers = mockUsers.where((user) => user.role == UserRole.USER).length;

    return {
      'total': totalUsers,
      'active': activeUsers,
      'admins': admins,
      'assigners': assigners,
      'workers': workers,
    };
  }
}
