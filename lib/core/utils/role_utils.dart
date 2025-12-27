import '../../domain/entities/user_role.dart';

bool canManageProducts(UserRole role) =>
    role == UserRole.admin || role == UserRole.superAdmin;

bool canViewAudit(UserRole role) =>
    role != UserRole.viewer;

bool isReadOnly(UserRole role) =>
    role == UserRole.auditor || role == UserRole.viewer;
