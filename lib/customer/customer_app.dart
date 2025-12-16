import 'package:flutter/material.dart';
import 'pages/home_page.dart';

class CustomerApp extends StatelessWidget {
  // final VoidCallback onLanguageToggle;

  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }
}
