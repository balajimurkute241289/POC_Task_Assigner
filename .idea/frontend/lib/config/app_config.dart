class AppConfig {
  // App Information
  static const String appName = 'Task Assignment App';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Mobile task assignment with GPS verification';

  // API Configuration
  static const String baseUrl = 'http://localhost:8080/api';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration apiRetryDelay = Duration(seconds: 2);
  static const int maxRetries = 3;

  // GPS Configuration
  static const double defaultCompletionRadius = 100.0; // meters
  static const double maxCompletionRadius = 1000.0; // meters
  static const double minCompletionRadius = 10.0; // meters
  static const Duration locationUpdateInterval = Duration(seconds: 5);
  static const double locationAccuracy = 10.0; // meters

  // Authentication
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 2.0;

  // Task Configuration
  static const int maxTaskTitleLength = 200;
  static const int maxTaskDescriptionLength = 1000;
  static const int maxTasksPerPage = 20;

  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String authenticationErrorMessage = 'Authentication failed. Please login again.';
  static const String locationErrorMessage = 'Location access denied. Please enable location services.';
  static const String gpsErrorMessage = 'GPS signal not available. Please check your location.';

  // Success Messages
  static const String taskCreatedMessage = 'Task created successfully!';
  static const String taskCompletedMessage = 'Task completed successfully!';
  static const String taskUpdatedMessage = 'Task updated successfully!';
  static const String taskDeletedMessage = 'Task deleted successfully!';
  static const String loginSuccessMessage = 'Login successful!';
  static const String logoutSuccessMessage = 'Logout successful!';

  // Validation Messages
  static const String requiredFieldMessage = 'This field is required.';
  static const String invalidEmailMessage = 'Please enter a valid email address.';
  static const String invalidPasswordMessage = 'Password must be at least 6 characters.';
  static const String invalidCoordinatesMessage = 'Please enter valid coordinates.';
  static const String invalidRadiusMessage = 'Radius must be between 10 and 1000 meters.';

  // Map Configuration
  static const double defaultMapZoom = 15.0;
  static const double taskMarkerZoom = 18.0;
  static const double userMarkerZoom = 16.0;

  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'txt'];

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB

  // Notification Configuration
  static const String notificationChannelId = 'task_notifications';
  static const String notificationChannelName = 'Task Notifications';
  static const String notificationChannelDescription = 'Notifications for task updates and assignments';

  // Development Configuration
  static const bool isDevelopment = true;
  static const bool enableLogging = true;
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
  static const bool enableBiometricAuth = false;
  static const bool enableDarkMode = true;
  static const bool enableAnimations = true;
}
