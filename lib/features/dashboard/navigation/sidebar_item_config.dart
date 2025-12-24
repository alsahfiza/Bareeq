import 'package:flutter/material.dart';
import '../../../core/constants/roles.dart';

class SidebarItemConfig {
  final String title;
  final String route;
  final IconData icon;
  final List<String> allowedRoles;

  const SidebarItemConfig({
    required this.title,
    required this.route,
    required this.icon,
    required this.allowedRoles,
  });

  bool isAllowed(String role) {
    return allowedRoles.contains(role);
  }
}
