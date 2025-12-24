class UserEntity {
  final String id;
  final String email;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  UserEntity copyWith({
    bool? isActive,
  }) {
    return UserEntity(
      id: id,
      email: email,
      role: role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}
