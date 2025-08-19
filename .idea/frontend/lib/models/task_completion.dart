class TaskCompletion {
  final int id;
  final int taskId;
  final int userId;
  final double gpsLatitude;
  final double gpsLongitude;
  final double? distanceFromTarget;
  final bool completionVerified;
  final DateTime completedAt;
  final String? verificationNotes;

  TaskCompletion({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.gpsLatitude,
    required this.gpsLongitude,
    this.distanceFromTarget,
    required this.completionVerified,
    required this.completedAt,
    this.verificationNotes,
  });

  factory TaskCompletion.fromJson(Map<String, dynamic> json) {
    return TaskCompletion(
      id: json['id'],
      taskId: json['taskId'],
      userId: json['userId'],
      gpsLatitude: json['gpsLatitude'].toDouble(),
      gpsLongitude: json['gpsLongitude'].toDouble(),
      distanceFromTarget: json['distanceFromTarget']?.toDouble(),
      completionVerified: json['completionVerified'] ?? false,
      completedAt: DateTime.parse(json['completedAt']),
      verificationNotes: json['verificationNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'userId': userId,
      'gpsLatitude': gpsLatitude,
      'gpsLongitude': gpsLongitude,
      'distanceFromTarget': distanceFromTarget,
      'completionVerified': completionVerified,
      'completedAt': completedAt.toIso8601String(),
      'verificationNotes': verificationNotes,
    };
  }

  @override
  String toString() {
    return 'TaskCompletion(id: $id, taskId: $taskId, userId: $userId, verified: $completionVerified)';
  }
}
