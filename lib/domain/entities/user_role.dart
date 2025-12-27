enum UserRole {
  superAdmin,
  admin,
  auditor,
  viewer,
}
extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.auditor:
        return 'Auditor';
      case UserRole.viewer:
        return 'Viewer';
    }
  }
}
