import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/products_by_category_page.dart';

class CustomerRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());

      case '/category':
        final categoryId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductsByCategoryPage(categoryId: categoryId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Not Found'))),
        );
    }
  }
}
