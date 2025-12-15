import 'package:flutter/material.dart';
import 'customer_router.dart';

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: CustomerRouter.generateRoute,
    );
  }
}
