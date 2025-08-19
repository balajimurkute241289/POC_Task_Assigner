import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/task.dart';
import '../../models/user.dart';
import '../../services/mock_data_service.dart';

class DemoTaskListScreen extends StatefulWidget {
  const DemoTaskListScreen({super.key});

  @override
  State<DemoTaskListScreen> createState() => _DemoTaskListScreenState();
}

class _DemoTaskListScreenState extends State<DemoTaskListScreen> {
  final MockDataService _mockService = MockDataService();
  late List<Task> _tasks;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _mockService.getCurrentUser();
    _tasks = _mockService.getTasksForUser(_currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _tasks.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return _buildTaskCard(_tasks[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks assigned',
            style: AppTheme.titleLarge.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You will see your assigned tasks here',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    final isWithinRadius = _mockService.isWithinTaskRadius(task);
    final currentLocation = _mockService.getCurrentLocation();
    final distance = _mockService.calculateDistance(
      currentLocation['latitude']!,
      currentLocation['longitude']!,
      task.latitude,
      task.longitude,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: AppTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(task.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${task.latitude.toStringAsFixed(4)}, ${task.longitude.toStringAsFixed(4)}',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  '${distance.round()}m away',
                  style: AppTheme.bodySmall.copyWith(
                    color: isWithinRadius ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.radio_button_checked, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Radius: ${task.completionRadius.round()}m',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (isWithinRadius)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'In Range',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Out of Range',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showTaskDetails(task),
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: task.status == TaskStatus.COMPLETED
                        ? null
                        : () => _completeTask(task),
                    icon: const Icon(Icons.check),
                    label: Text(
                      task.status == TaskStatus.COMPLETED ? 'Completed' : 'Complete',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task.status == TaskStatus.COMPLETED
                          ? Colors.grey
                          : (isWithinRadius ? Colors.green : Colors.orange),
                      foregroundColor: Colors.white,
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

  Widget _buildStatusChip(TaskStatus status) {
    Color color;
    String text;

    switch (status) {
      case TaskStatus.PENDING:
        color = Colors.orange;
        text = 'Pending';
        break;
      case TaskStatus.IN_PROGRESS:
        color = Colors.blue;
        text = 'In Progress';
        break;
      case TaskStatus.COMPLETED:
        color = Colors.green;
        text = 'Completed';
        break;
      case TaskStatus.CANCELLED:
        color = Colors.red;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showTaskDetails(Task task) {
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
              'Location:',
              style: AppTheme.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Latitude: ${task.latitude}'),
            Text('Longitude: ${task.longitude}'),
            const SizedBox(height: 8),
            Text('Completion Radius: ${task.completionRadius.round()}m'),
            const SizedBox(height: 16),
            Text(
              'Status:',
              style: AppTheme.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            _buildStatusChip(task.status),
            const SizedBox(height: 16),
            Text(
              'Created:',
              style: AppTheme.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(task.createdAt.toString().substring(0, 19)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _completeTask(Task task) {
    final isWithinRadius = _mockService.isWithinTaskRadius(task);
    
    if (!isWithinRadius) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You must be within ${task.completionRadius.round()}m of the task location to complete it.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to complete "${task.title}"?'),
            const SizedBox(height: 16),
            Text(
              'GPS Verification:',
              style: AppTheme.titleSmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text('Location verified'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text('Within completion radius'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmTaskCompletion(task);
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

  void _confirmTaskCompletion(Task task) {
    // In a real app, this would send a request to the backend
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(status: TaskStatus.COMPLETED);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" completed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
