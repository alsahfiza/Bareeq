import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app_customer.dart';
import 'app_admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final host = Uri.base.host.toLowerCase();

  final bool isAdminDomain = host.contains("admin");

  runApp(
    isAdminDomain ? const AdminApp() : const CustomerApp(),
  );
}
