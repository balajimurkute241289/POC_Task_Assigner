enum TaskStatus { PENDING, IN_PROGRESS, COMPLETED, CANCELLED }

class Task {
  final int id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final double completionRadius;
  final TaskStatus status;
  final int assignerId;
  final int assigneeId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.completionRadius,
    required this.status,
    required this.assignerId,
    required this.assigneeId,
    required this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      completionRadius: json['completionRadius']?.toDouble() ?? 100.0,
      status: TaskStatus.values.firstWhere((e) => e.toString().split('.').last == json['status']),
      assignerId: json['assignerId'],
      assigneeId: json['assigneeId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'completionRadius': completionRadius,
      'status': status.toString().split('.').last,
      'assignerId': assignerId,
      'assigneeId': assigneeId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
    double? completionRadius,
    TaskStatus? status,
    int? assignerId,
    int? assigneeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      completionRadius: completionRadius ?? this.completionRadius,
      status: status ?? this.status,
      assignerId: assignerId ?? this.assignerId,
      assigneeId: assigneeId ?? this.assigneeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status)';
  }
}
