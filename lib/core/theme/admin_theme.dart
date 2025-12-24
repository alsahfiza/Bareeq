import 'package:flutter/material.dart';

class AdminTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF4F6F9),
    primaryColor: const Color(0xFF1E1E2D),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E2D),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14),
    ),
    useMaterial3: false,
  );
}
