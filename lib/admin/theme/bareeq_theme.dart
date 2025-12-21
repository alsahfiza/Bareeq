import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Bareeq Brand Colors (extracted from your logo)
class BareeqColors {
  // Primary Colors (Teal/Turquoise from logo)
  static const Color primaryTeal = Color(0xFF1E9B9B); // Main teal color
  static const Color primaryTealDark = Color(0xFF157575); // Darker teal
  static const Color primaryTealLight = Color(0xFF4DB8B8); // Lighter teal
  
  // Accent Colors (Yellow sparkle from spray bottle)
  static const Color accentYellow = Color(0xFFFFD700); // Gold/Yellow
  static const Color accentYellowLight = Color(0xFFFFF4CC); // Light yellow
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF6B7F8C); // Grey from spray bottle top
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F9F9); // Very light teal
  static const Color backgroundDark = Color(0xFF0D1B1E); // Dark for dark mode
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue
}

// Light Theme
ThemeData getBareeqLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: BareeqColors.primaryTeal,
      onPrimary: BareeqColors.white,
      primaryContainer: BareeqColors.primaryTealLight,
      onPrimaryContainer: BareeqColors.primaryTealDark,
      
      secondary: BareeqColors.accentYellow,
      onSecondary: BareeqColors.black,
      secondaryContainer: BareeqColors.accentYellowLight,
      onSecondaryContainer: BareeqColors.primaryTealDark,
      
      tertiary: BareeqColors.grey,
      
      background: BareeqColors.backgroundLight,
      onBackground: BareeqColors.black,
      
      surface: BareeqColors.white,
      onSurface: BareeqColors.black,
      surfaceVariant: const Color(0xFFF0F4F5),
      
      error: BareeqColors.error,
      onError: BareeqColors.white,
      
      outline: const Color(0xFFD1D5DB),
      shadow: Colors.black12,
    ),
    
    // App Bar Theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: BareeqColors.primaryTeal,
      foregroundColor: BareeqColors.white,
      iconTheme: IconThemeData(color: BareeqColors.white),
      titleTextStyle: TextStyle(
        color: BareeqColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: BareeqColors.white,
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: BareeqColors.primaryTeal,
        foregroundColor: BareeqColors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: BareeqColors.primaryTeal,
        side: const BorderSide(color: BareeqColors.primaryTeal, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: BareeqColors.primaryTeal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: BareeqColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: BareeqColors.primaryTeal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: BareeqColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: BareeqColors.accentYellow,
      foregroundColor: BareeqColors.black,
      elevation: 4,
    ),
    
    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: BareeqColors.primaryTealLight.withOpacity(0.2),
      selectedColor: BareeqColors.primaryTeal,
      labelStyle: const TextStyle(color: BareeqColors.primaryTealDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E7EB),
      thickness: 1,
      space: 1,
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: BareeqColors.primaryTeal,
      size: 24,
    ),
  );
}

// Dark Theme
ThemeData getBareeqDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: BareeqColors.primaryTealLight,
      onPrimary: BareeqColors.black,
      primaryContainer: BareeqColors.primaryTealDark,
      onPrimaryContainer: BareeqColors.primaryTealLight,
      
      secondary: BareeqColors.accentYellow,
      onSecondary: BareeqColors.black,
      secondaryContainer: BareeqColors.accentYellow.withOpacity(0.2),
      onSecondaryContainer: BareeqColors.accentYellow,
      
      tertiary: BareeqColors.grey,
      
      background: BareeqColors.backgroundDark,
      onBackground: BareeqColors.white,
      
      surface: const Color(0xFF1F2937),
      onSurface: BareeqColors.white,
      surfaceVariant: const Color(0xFF374151),
      
      error: BareeqColors.error,
      onError: BareeqColors.white,
      
      outline: const Color(0xFF4B5563),
      shadow: Colors.black45,
    ),
    
    // App Bar Theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Color(0xFF1F2937),
      foregroundColor: BareeqColors.white,
      iconTheme: IconThemeData(color: BareeqColors.white),
      titleTextStyle: TextStyle(
        color: BareeqColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF1F2937),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: BareeqColors.primaryTealLight,
        foregroundColor: BareeqColors.black,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: BareeqColors.primaryTealLight,
        side: const BorderSide(color: BareeqColors.primaryTealLight, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: BareeqColors.primaryTealLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF374151),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4B5563)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4B5563)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: BareeqColors.primaryTealLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: BareeqColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: BareeqColors.accentYellow,
      foregroundColor: BareeqColors.black,
      elevation: 6,
    ),
    
    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: BareeqColors.primaryTealDark.withOpacity(0.3),
      selectedColor: BareeqColors.primaryTealLight,
      labelStyle: const TextStyle(color: BareeqColors.primaryTealLight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFF374151),
      thickness: 1,
      space: 1,
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: BareeqColors.primaryTealLight,
      size: 24,
    ),
  );
}

// Usage in main.dart:
/*
MaterialApp(
  title: 'Bareeq Admin',
  theme: getBareeqLightTheme(),
  darkTheme: getBareeqDarkTheme(),
  themeMode: themeProvider.themeMode,
  home: DashboardScreen(),
)
*/