import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const _key = 'lang';

  Future<void> setArabic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }

  Future<bool> isArabic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }
}
