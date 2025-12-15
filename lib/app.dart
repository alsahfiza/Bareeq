import 'package:flutter/material.dart';
import 'core/auth/auth_gate.dart';
import 'shared/services/notification_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
