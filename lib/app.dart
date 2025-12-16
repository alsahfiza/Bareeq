import 'package:flutter/material.dart';
import 'core/auth/auth_gate.dart';
import 'shared/services/language_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool arabic = false;

  @override
  void initState() {
    super.initState();
    LanguageService().isArabic().then((v) {
      setState(() => arabic = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: arabic ? const Locale('ar') : const Locale('en'),
      home: AuthGate(
        onLanguageToggle: () async {
          final newValue = !arabic;
          await LanguageService().setArabic(newValue);
          setState(() => arabic = newValue);
        },
      ),
    );
  }
}
