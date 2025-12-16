import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'pages/products_page.dart';
import 'pages/categories_page.dart';
import 'pages/orders_page.dart';
import 'pages/banners_page.dart';
import 'pages/users_page.dart';
import 'pages/settings_page.dart';
import 'pages/analytics_page.dart';
import 'pages/export_page.dart';
import 'pages/date_range_report_page.dart';
import 'pages/branches_page.dart';

class AdminRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case '/dashboard':
      //   return MaterialPageRoute(
      //       builder: (_) => const DashboardPage());
      case '/products':
        return MaterialPageRoute(
            builder: (_) => const ProductsPage());
      case '/categories':
        return MaterialPageRoute(
            builder: (_) => const CategoriesPage());
      case '/orders':
        return MaterialPageRoute(
            builder: (_) => const OrdersPage());
      // case '/analytics':
      //   return MaterialPageRoute(
      //       builder: (_) => const AnalyticsPage());
      // case '/reports':
      //   return MaterialPageRoute(
      //       builder: (_) => const DateRangeReportPage());
      // case '/export':
      //   return MaterialPageRoute(
      //       builder: (_) => const ExportPage());
      // case '/branches':
      //   return MaterialPageRoute(
      //       builder: (_) => const BranchesPage());
      // case '/banners':
      //   return MaterialPageRoute(
      //       builder: (_) => const BannersPage());
      // case '/users':
      //   return MaterialPageRoute(
      //       builder: (_) => const UsersPage());
      case '/settings':
        return MaterialPageRoute(
            builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
