import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';

class UserModel {
  final String id;
  final Map<String, dynamic> data;

  UserModel(this.id, this.data);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel(doc.id, doc.data() as Map<String, dynamic>);
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: data['email'],
      role: userRoleFromString(data['role']),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> fromEntity(UserEntity u) {
    return {
      'email': u.email,
      'role': userRoleToString(u.role),
      'isActive': u.isActive,
      'createdAt': Timestamp.fromDate(u.createdAt),
    };
  }
}
