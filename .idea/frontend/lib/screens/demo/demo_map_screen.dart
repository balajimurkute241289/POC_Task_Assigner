import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/mock_data_service.dart';

class DemoMapScreen extends StatefulWidget {
  const DemoMapScreen({super.key});

  @override
  State<DemoMapScreen> createState() => _DemoMapScreenState();
}

class _DemoMapScreenState extends State<DemoMapScreen> {
  final MockDataService _mockService = MockDataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildMapPlaceholder(),
          _buildTaskList(),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          // Map placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Interactive Map View',
                  style: AppTheme.titleLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Google Maps integration would show here',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Task markers overlay
          Positioned(
            top: 20,
            left: 20,
            child: _buildMapLegend(),
          ),
          // Current location indicator
          Positioned(
            bottom: 20,
            right: 20,
            child: _buildCurrentLocationIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Status',
            style: AppTheme.titleSmall.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildLegendItem('Pending', Colors.orange),
          _buildLegendItem('In Progress', Colors.blue),
          _buildLegendItem('Completed', Colors.green),
          _buildLegendItem('Your Location', Colors.red),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationIndicator() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.my_location,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildTaskList() {
    final tasks = _mockService.getAllTasks();
    final currentLocation = _mockService.getCurrentLocation();

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final distance = _mockService.calculateDistance(
            currentLocation['latitude']!,
            currentLocation['longitude']!,
            task.latitude,
            task.longitude,
          );
          final isWithinRadius = _mockService.isWithinTaskRadius(task);

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getTaskStatusColor(task.status),
                child: Icon(
                  _getTaskStatusIcon(task.status),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                task.title,
                style: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${distance.round()}m away',
                        style: AppTheme.bodySmall.copyWith(
                          color: isWithinRadius ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isWithinRadius ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isWithinRadius ? 'In Range' : 'Out of Range',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () => _showTaskDetails(task),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getTaskStatusColor(dynamic status) {
    switch (status.toString()) {
      case 'TaskStatus.PENDING':
        return Colors.orange;
      case 'TaskStatus.IN_PROGRESS':
        return Colors.blue;
      case 'TaskStatus.COMPLETED':
        return Colors.green;
      case 'TaskStatus.CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTaskStatusIcon(dynamic status) {
    switch (status.toString()) {
      case 'TaskStatus.PENDING':
        return Icons.schedule;
      case 'TaskStatus.IN_PROGRESS':
        return Icons.play_arrow;
      case 'TaskStatus.COMPLETED':
        return Icons.check;
      case 'TaskStatus.CANCELLED':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  void _showTaskDetails(dynamic task) {
    final currentLocation = _mockService.getCurrentLocation();
    final distance = _mockService.calculateDistance(
      currentLocation['latitude']!,
      currentLocation['longitude']!,
      task.latitude,
      task.longitude,
    );
    final isWithinRadius = _mockService.isWithinTaskRadius(task);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: AppTheme.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(task.description),
            const SizedBox(height: 16),
            Text(
              'Location Details:',
              style: AppTheme.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Latitude: ${task.latitude}'),
            Text('Longitude: ${task.longitude}'),
            const SizedBox(height: 8),
            Text('Distance from you: ${distance.round()}m'),
            Text('Completion radius: ${task.completionRadius.round()}m'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isWithinRadius ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isWithinRadius ? '✓ Within completion range' : '✗ Outside completion range',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Status:',
              style: AppTheme.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTaskStatusColor(task.status),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task.status.toString().split('.').last,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (isWithinRadius && task.status.toString() != 'TaskStatus.COMPLETED')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _completeTask(task);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Complete'),
            ),
        ],
      ),
    );
  }

  void _completeTask(dynamic task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" completed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
