import 'user_role.dart';

class UserEntity {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final bool active;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.active,
    required this.createdAt,
  });

  UserEntity copyWith({
    String? name,
    String? email,
    UserRole? role,
    bool? active,
  }) {
    return UserEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      active: active ?? this.active,
      createdAt: createdAt,
    );
  }
}
