import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.email,
    required this.isActive,
  });

  factory UserModel.fromFirestore(
    Map<String, dynamic> json,
    String id,
  ) {
    return UserModel(
      id: id,
      email: json['email'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      isActive: entity.isActive,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      isActive: isActive,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'isActive': isActive,
    };
  }
}
