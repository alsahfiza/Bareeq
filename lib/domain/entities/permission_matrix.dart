class PermissionMatrix {
  final String feature;
  final bool viewer;
  final bool admin;
  final bool superAdmin;

  const PermissionMatrix({
    required this.feature,
    required this.viewer,
    required this.admin,
    required this.superAdmin,
  });
}
