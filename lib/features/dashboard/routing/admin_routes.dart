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
  '/dashboard': (_) => const DashboardPage(),

  // TEMP DISABLED
  // '/products': (_) => const ProductsPage(),
  // '/inventory': (_) => const InventoryPage(),
  // '/sales': (_) => const SalesPage(),
  // '/users': (_) => const UsersPage(),
  // '/audit': (_) => const AuditLogsPage(),
  // '/snapshots': (_) => const SnapshotBrowserPage(),
  // '/system-health': (_) => const SystemHealthPage(),
};