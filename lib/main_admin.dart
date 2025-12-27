import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/theme/admin_theme.dart';
import 'features/auth/ui/auth_gate.dart';
import 'features/dashboard/ui/admin_shell.dart';
import 'features/dashboard/ui/dashboard_page.dart';
import 'features/dashboard/routing/admin_routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: BareeqAdminApp()));
}

class BareeqAdminApp extends StatelessWidget {
  const BareeqAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bareeq Admin',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.light,
      home: AuthGate(
        child: AdminShell(),
      ),
      // routes: adminRoutes,
    );
  }
}


