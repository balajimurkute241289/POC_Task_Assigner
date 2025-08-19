import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/user.dart';
import '../../services/mock_data_service.dart';
import 'demo_task_list_screen.dart';
import 'demo_admin_screen.dart';
import 'demo_map_screen.dart';

class DemoHomeScreen extends StatefulWidget {
  const DemoHomeScreen({super.key});

  @override
  State<DemoHomeScreen> createState() => _DemoHomeScreenState();
}

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  final MockDataService _mockService = MockDataService();
  late User _currentUser;
  late Map<String, dynamic> _taskStats;
  late Map<String, dynamic> _userStats;

  @override
  void initState() {
    super.initState();
    _currentUser = _mockService.getCurrentUser();
    _taskStats = _mockService.getTaskStatistics();
    _userStats = _mockService.getUserStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Assignment App - Demo'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            
            // Current User Info
            _buildCurrentUserCard(),
            const SizedBox(height: 24),
            
            // Quick Stats
            _buildStatsSection(),
            const SizedBox(height: 24),
            
            // Feature Buttons
            _buildFeatureButtons(),
            const SizedBox(height: 24),
            
            // Demo Info
            _buildDemoInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDarkColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.task_alt,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'Welcome to Task Assignment App',
            style: AppTheme.headlineSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'GPS-based task management with role-based access control',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    _currentUser.username[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentUser.username,
                        style: AppTheme.titleLarge,
                      ),
                      Text(
                        _currentUser.role.toString().split('.').last,
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _currentUser.isActive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _currentUser.isActive ? 'Active' : 'Inactive',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Tasks',
            _taskStats['total'].toString(),
            Icons.assignment,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Completed',
            _taskStats['completed'].toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Pending',
            _taskStats['pending'].toString(),
            Icons.pending,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: AppTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demo Features',
          style: AppTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildFeatureButton(
              'My Tasks',
              Icons.assignment,
              Colors.blue,
              () => _navigateToTaskList(),
            ),
            _buildFeatureButton(
              'Map View',
              Icons.map,
              Colors.green,
              () => _navigateToMap(),
            ),
            _buildFeatureButton(
              'Admin Panel',
              Icons.admin_panel_settings,
              Colors.purple,
              () => _navigateToAdmin(),
            ),
            _buildFeatureButton(
              'GPS Demo',
              Icons.location_on,
              Colors.red,
              () => _showGpsDemo(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTheme.titleMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Demo Information',
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This is a demo version with mock data. All features are fully functional:',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            _buildDemoFeature('✓ GPS-based task completion verification'),
            _buildDemoFeature('✓ Role-based access control (Admin, Manager, Worker)'),
            _buildDemoFeature('✓ Real-time task management'),
            _buildDemoFeature('✓ Interactive map with task locations'),
            _buildDemoFeature('✓ Comprehensive reporting and analytics'),
            _buildDemoFeature('✓ Modern Material Design 3 UI'),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: AppTheme.bodySmall,
      ),
    );
  }

  void _navigateToTaskList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DemoTaskListScreen(),
      ),
    );
  }

  void _navigateToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DemoMapScreen(),
      ),
    );
  }

  void _navigateToAdmin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DemoAdminScreen(),
      ),
    );
  }

  void _showGpsDemo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('GPS Demo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current simulated location:'),
            const SizedBox(height: 8),
            Text('Latitude: 40.7589°N'),
            Text('Longitude: -73.9851°W'),
            const SizedBox(height: 8),
            Text('This simulates being near Times Square, NYC.'),
            const SizedBox(height: 8),
            Text('Tasks can only be completed when you are within the specified radius of the task location.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
