import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Хранит выбранную тему и сохраняет выбор между перезагрузками.
///
/// На web shared_preferences — это localStorage, поэтому выбор
/// переживает перезагрузку страницы (в отличие от состояния в памяти).
class ThemeNotifier extends ChangeNotifier {
  static const _key = 'themeMode';

  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  ThemeNotifier() {
    load();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == 'dark') {
      _mode = ThemeMode.dark;
      notifyListeners();
    }
  }

  Future<void> toggle() async {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, isDark ? 'dark' : 'light');
  }
}
