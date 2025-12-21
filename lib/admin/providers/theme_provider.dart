import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';


// ==================== THEME PROVIDER ====================
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  // Load saved theme preference
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString('theme_mode') ?? 'system';
      
      switch (savedThemeMode) {
        case 'light':
          _themeMode = ThemeMode.light;
          _isDarkMode = false;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          _isDarkMode = true;
          break;
        default:
          _themeMode = ThemeMode.system;
          _isDarkMode = false;
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }

  // Save theme preference
  Future<void> _saveThemePreference(String themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_mode', themeMode);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  // Toggle between light and dark mode
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setDarkMode();
    } else {
      setLightMode();
    }
  }

  // Set light mode
  void setLightMode() {
    _themeMode = ThemeMode.light;
    _isDarkMode = false;
    _saveThemePreference('light');
    notifyListeners();
  }

  // Set dark mode
  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    _isDarkMode = true;
    _saveThemePreference('dark');
    notifyListeners();
  }

  // Set system mode
  void setSystemMode() {
    _themeMode = ThemeMode.system;
    _isDarkMode = false;
    _saveThemePreference('system');
    notifyListeners();
  }

  // Get current theme brightness
  Brightness getCurrentBrightness(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness;
    }
    return _themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
  }
}