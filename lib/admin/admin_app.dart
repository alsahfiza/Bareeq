import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'admin_router.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bareeq Admin',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      onGenerateRoute: AdminRouter.generate,
      home: const AdminLoginPage(),
    );
  }
}
