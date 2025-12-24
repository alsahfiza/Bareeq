import 'package:flutter/material.dart';
import '../../../core/constants/roles.dart';
import 'sidebar_item_config.dart';

const sidebarItems = [
  SidebarItemConfig(
    title: 'Dashboard',
    route: '/dashboard',
    icon: Icons.dashboard,
    allowedRoles: Roles.all,
  ),
  SidebarItemConfig(
    title: 'Products',
    route: '/products',
    icon: Icons.inventory_2,
    allowedRoles: [
      Roles.superAdmin,
      Roles.admin,
    ],
  ),
  SidebarItemConfig(
    title: 'Inventory',
    route: '/inventory',
    icon: Icons.warehouse,
    allowedRoles: [
      Roles.superAdmin,
      Roles.admin,
      Roles.manager,
    ],
  ),
  SidebarItemConfig(
    title: 'Sales',
    route: '/sales',
    icon: Icons.bar_chart,
    allowedRoles: Roles.all,
  ),
  SidebarItemConfig(
    title: 'Users',
    route: '/users',
    icon: Icons.people,
    allowedRoles: [
      Roles.superAdmin,
    ],
  ),
  SidebarItemConfig(
    title: 'Settings',
    route: '/settings',
    icon: Icons.settings,
    allowedRoles: [
      Roles.superAdmin,
      Roles.admin,
    ],
  ),
];
