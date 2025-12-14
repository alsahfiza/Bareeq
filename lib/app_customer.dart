import 'package:flutter/material.dart';
import 'router/app_router.dart';

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Bareeq Stores",
      routerConfig: AppRouter.customerRouter,
    );
  }
}
