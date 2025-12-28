import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';

class UserModel {
  final String id;
  final String email;
  final bool isActive;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.email,
    required this.isActive,
    required this.role,
  });

  factory UserModel.fromFirestore(
    Map<String, dynamic> json,
    String id,
  ) {
    return UserModel(
      id: id,
      email: json['email'] as String,
      isActive: json['isActive'] as bool? ?? true,
      role: _parseRole(json['role']),
    );
  }

  // ✅ ADD THIS
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      isActive: entity.isActive,
      role: entity.role,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      isActive: isActive,
      role: role,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'isActive': isActive,
      'role': role.name,
    };
  }

  static UserRole _parseRole(dynamic value) {
    if (value is String) {
      return UserRole.values.firstWhere(
        (r) => r.name == value,
        orElse: () => UserRole.viewer,
      );
    }
    return UserRole.viewer;
  }
}
