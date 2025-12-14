import 'package:flutter/material.dart';
import 'router/app_router.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Bareeq Admin Panel",
      routerConfig: AppRouter.adminRouter,
    );
  }
}
