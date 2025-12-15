import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: "Bareeq Admin Panel",
          routerConfig: AppRouter.adminRouter,
        );
      },
    );
  }
}
