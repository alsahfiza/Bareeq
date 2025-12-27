import 'user_role.dart';

class UserEntity {
  final String id;
  final String email;
  final bool isActive;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.email,
    required this.isActive,
    required this.role,
  });

  UserEntity copyWith({
    bool? isActive,
    UserRole? role,
  }) {
    return UserEntity(
      id: id,
      email: email,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
    );
  }
}
