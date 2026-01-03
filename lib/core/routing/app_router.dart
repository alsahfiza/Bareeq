import 'package:flutter/material.dart';
import '../layout/admin_shell.dart';
import 'app_routes.dart';

// pages
import '../../features/dashboard/ui/dashboard_page.dart';
import '../../features/products/ui/products_page.dart';
// import '../../features/products/ui/product_form_page.dart';
import '../../features/inventory/ui/inventory_page.dart';
import '../../features/inventory/ui/inventory_adjust_page.dart';
import '../../features/sales/ui/sales_page.dart';
import '../../features/users/ui/users_page.dart';
import '../../features/snapshots/ui/snapshot_browser_page.dart';
import '../../features/system_health/ui/system_health_page.dart';
import '../../features/auth/ui/login_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {

    switch (settings.name) {
      case AppRoutes.login:
        return _page(const LoginPage(), shell: false);

      case AppRoutes.dashboard:
        return _page(const DashboardPage());

      case AppRoutes.products:
        return _page(const ProductsPage());

      // case AppRoutes.productForm:
      //   return _page(const ProductFormPage());

      case AppRoutes.inventory:
        return _page(const InventoryPage());

      case AppRoutes.inventoryAdjust:
        final args = settings.arguments as Map<String, dynamic>;
        return _page(
          InventoryAdjustPage(
            productId: args['productId'] as String,
            productName: args['productName'] as String,
          ),
        );

      
      case AppRoutes.sales:
        return _page(const SalesPage());

      case AppRoutes.users:
        return _page(const UsersPage());

      case AppRoutes.snapshots:
        return _page(const SnapshotBrowserPage());

      case AppRoutes.systemHealth:
        return _page(const SystemHealthPage());

      default:
        return _page(const DashboardPage());
    }
  }

  static MaterialPageRoute _page(
    Widget page, {
    bool shell = true,
  }) {
    return MaterialPageRoute(
      builder: (_) =>
          shell ? AdminShell(child: page) : page,
    );
  }
}
