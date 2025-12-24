import '../../domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'],
      role: data['role'],
      isActive: data['isActive'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
    );
  }

  static UserModel fromEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      email: user.email,
      role: user.role,
      isActive: user.isActive,
      createdAt: user.createdAt,
    );
  }
}
