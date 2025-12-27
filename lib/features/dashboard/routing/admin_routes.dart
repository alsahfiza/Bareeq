import 'package:flutter/material.dart';

import '../ui/dashboard_page.dart';
import '../../products/ui/products_page.dart';
import '../../inventory/ui/inventory_page.dart';
import '../../sales/ui/sales_page.dart';
import '../../users/ui/users_page.dart';
import '../../settings/ui/settings_page.dart';
import '../../audit/ui/audit_logs_page.dart';
import '../../snapshots/ui/snapshot_browser_page.dart';
import '../../system_health/ui/system_health_page.dart';

final Map<String, WidgetBuilder> adminRoutes = {
  '/': (_) => DashboardPage(),
  '/products': (_) => ProductsPage(),
  '/inventory': (_) => InventoryPage(),
  '/sales': (_) => SalesPage(),
  '/audit': (_) => AuditLogsPage(),
  '/snapshots': (_) => SnapshotBrowserPage(),
  '/system-health': (_) => SystemHealthPage(),
  '/users': (_) => UsersPage(),
  '/settings': (_) => SettingsPage(),
};
