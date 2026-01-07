import 'package:flutter/material.dart';

import '../layout/admin_shell.dart';
import 'app_routes.dart';

// Admin pages
import '../../features/dashboard/ui/dashboard_page.dart';
import '../../features/products/ui/products_page.dart';
import '../../features/products/ui/add_product_page.dart';
import '../../features/products/ui/edit_product_page.dart';
import '../../features/products/ui/view_product_page.dart';
import '../../features/sales/ui/sales_page.dart';
import '../../features/users/ui/users_page.dart';
import '../../features/auth/ui/login_page.dart';
import '../../data/models/product_model.dart';

class AdminRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _page(const LoginPage(), shell: false);

      case AppRoutes.adminDashboard:
        return _page(const DashboardPage());

      case AppRoutes.adminProducts:
        return _page(const ProductsPage());

      case AppRoutes.adminAddProduct:
        return _page(const AddProductPage());

      case AppRoutes.adminViewProduct:
        final product = settings.arguments as ProductModel;
        return _page(ViewProductPage(product: product));

      case AppRoutes.adminEditProduct:
        final product = settings.arguments as ProductModel;
        return _page(EditProductPage(product: product));

      case AppRoutes.adminSales:
        return _page(const SalesPage());

      case AppRoutes.adminUsers:
        return _page(const UsersPage());

      default:
        return _page(const DashboardPage());
    }
  }

  static MaterialPageRoute _page(
    Widget page, {
    bool shell = true,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: page.runtimeType.toString()),
      builder: (_) => shell ? AdminShell(child: page) : page,
    );
  }
}
