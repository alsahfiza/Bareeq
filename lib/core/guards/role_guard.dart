import '../../domain/entities/user_entity.dart';
import '../constants/roles.dart';

class RoleGuard {
  final UserEntity user;

  const RoleGuard(this.user);

  bool get isActive => user.isActive;

  bool get isSuperAdmin => user.role == Roles.superAdmin;
  bool get isAdmin => user.role == Roles.admin;
  bool get isManager => user.role == Roles.manager;
  bool get isViewer => user.role == Roles.viewer;

  bool canManageUsers() => isSuperAdmin;

  bool canManageProducts() =>
      isSuperAdmin || isAdmin;

  bool canAdjustInventory() =>
      isSuperAdmin || isAdmin || isManager;

  bool canViewSales() => true;

  bool canDelete() => false; // Spec enforced
}
