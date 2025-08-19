import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';

class DemoAdminScreen extends StatefulWidget {
  const DemoAdminScreen({super.key});

  @override
  State<DemoAdminScreen> createState() => _DemoAdminScreenState();
}

class _DemoAdminScreenState extends State<DemoAdminScreen> {
  final MockDataService _mockService = MockDataService();
  late Map<String, dynamic> _taskStats;
  late Map<String, dynamic> _userStats;

  @override
  void initState() {
    super.initState();
    _taskStats = _mockService.getTaskStatistics();
    _userStats = _mockService.getUserStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildDemoInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      child: Container(
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
            Row(
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin Dashboard',
                        style: AppTheme.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'System overview and management',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Statistics',
          style: AppTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Users',
                _userStats['total'].toString(),
                Icons.people,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Active Users',
                _userStats['active'].toString(),
                Icons.person,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Tasks',
                _taskStats['total'].toString(),
                Icons.assignment,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Completion Rate',
                '${_taskStats['completionRate'].round()}%',
                Icons.trending_up,
                Colors.purple,
              ),
            ),
          ],
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

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'User Management',
              Icons.people,
              Colors.blue,
              () => _showFeatureDemo('User Management'),
            ),
            _buildActionCard(
              'Task Overview',
              Icons.assignment,
              Colors.green,
              () => _showFeatureDemo('Task Overview'),
            ),
            _buildActionCard(
              'Reports',
              Icons.analytics,
              Colors.orange,
              () => _showFeatureDemo('Reports'),
            ),
            _buildActionCard(
              'System Settings',
              Icons.settings,
              Colors.purple,
              () => _showFeatureDemo('System Settings'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
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
                  'Admin Features Demo',
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This admin dashboard demonstrates:',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            _buildDemoFeature('✓ User management and role assignment'),
            _buildDemoFeature('✓ Task overview and status monitoring'),
            _buildDemoFeature('✓ System statistics and analytics'),
            _buildDemoFeature('✓ Performance reports and insights'),
            _buildDemoFeature('✓ GPS accuracy monitoring'),
            _buildDemoFeature('✓ System configuration and settings'),
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

  void _showFeatureDemo(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature Demo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This would show the $feature interface with:'),
            const SizedBox(height: 8),
            Text('• Real-time data updates'),
            Text('• Interactive charts and graphs'),
            Text('• Filtering and search capabilities'),
            Text('• Export and reporting features'),
            const SizedBox(height: 8),
            Text('In the full application, this would connect to the backend API for live data.'),
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
