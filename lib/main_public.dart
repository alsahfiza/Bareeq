import 'package:flutter/material.dart';

Future<void> runPublicApp() async {
  runApp(const PublicApp());
}

class PublicApp extends StatelessWidget {
  const PublicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'Public Store Front',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
