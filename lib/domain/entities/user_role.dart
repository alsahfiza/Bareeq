enum UserRole { admin, manager, viewer }

UserRole userRoleFromString(String v) {
  return UserRole.values.firstWhere(
    (e) => e.name == v,
    orElse: () => UserRole.viewer,
  );
}

String userRoleToString(UserRole r) => r.name;