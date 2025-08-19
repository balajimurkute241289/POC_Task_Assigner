enum UserRole { ADMIN, TASK_ASSIGNER, USER }

class User {
  final int id;
  final String username;
  final String email;
  final UserRole role;
  final bool isActive;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: UserRole.values.firstWhere((e) => e.toString().split('.').last == json['role']),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role.toString().split('.').last,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, role: $role)';
  }
}
