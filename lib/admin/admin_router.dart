import 'package:flutter/material.dart';
import '../admin/pages/dashboard_page.dart';
import '../admin/pages/products_page.dart';
import '../admin/pages/categories_page.dart';
import '../admin/pages/orders_page.dart';
import '../admin/pages/settings_page.dart';


class AdminRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );
      case '/products':
        return MaterialPageRoute(
          builder: (_) => const ProductsPage(),
        );
      case '/categories':
        return MaterialPageRoute(
          builder: (_) => const CategoriesPage(),
        );
      case '/orders':
        return MaterialPageRoute(
          builder: (_) => const OrdersPage(),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );
    }
  }
}
