import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onLanguageToggle;

  const LoginPage({
    super.key,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: onLanguageToggle,
          ),
        ],
      ),
      body: const Center(child: Text('Login')),
    );
  }
}
