import 'package:flutter/material.dart';
import '../../auth/ui/login_page.dart';
import '../ui/admin_shell.dart';
import '../../products/ui/products_page.dart';
import '../../inventory/ui/inventory_page.dart';
import '../../sales/ui/sales_page.dart';
import '../../users/ui/users_page.dart';
import '../../settings/ui/settings_page.dart';
import '../ui/dashboard_page.dart';

final Map<String, WidgetBuilder> adminRoutes = {
  '/login': (_) => const LoginPage(),
  '/dashboard': (_) => const AdminShell(child: DashboardPage()),
  '/products': (_) => const AdminShell(child: ProductsPage()),
  '/inventory': (_) => const AdminShell(child: InventoryPage()),
  '/sales': (_) => const AdminShell(child: SalesPage()),
  '/users': (_) => const AdminShell(child: UsersPage()),
  '/settings': (_) => const AdminShell(child: SettingsPage()),
};
