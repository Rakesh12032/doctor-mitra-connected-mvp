import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/app_strings.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLang = 'en';

  LanguageProvider() {
    _loadLanguage();
  }

  String get currentLang => _currentLang;

  String t(String key) {
    return AppStrings.strings[_currentLang]?[key] ??
        AppStrings.strings['en']?[key] ??
        key;
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLang = prefs.getString('lang') ?? 'en';
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _currentLang = _currentLang == 'en' ? 'hi' : 'en';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', _currentLang);
    notifyListeners();
  }

  bool get isHindi => _currentLang == 'hi';
}
