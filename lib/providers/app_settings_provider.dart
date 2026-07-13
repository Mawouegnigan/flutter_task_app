import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  static const String _langKey = 'languageCode';
  static const String _offlineKey = 'isManualOffline';

  bool _isDarkMode = false;
  String _languageCode = 'fr';
  bool _isManualOffline = false;

  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;
  bool get isManualOffline => _isManualOffline;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  Locale get locale => Locale(_languageCode);

  AppSettingsProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    _languageCode = prefs.getString(_langKey) ?? 'fr';
    _isManualOffline = prefs.getBool(_offlineKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
  }

  Future<void> setLanguage(String code) async {
    _languageCode = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, code);
  }

  Future<void> toggleOfflineMode(bool value) async {
    _isManualOffline = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_offlineKey, value);
  }
}