import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('theme_dark') ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar preferência de tema: $e');
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('theme_dark', _isDarkMode);
    } catch (e) {
      debugPrint('Erro ao salvar preferência de tema: $e');
    }
    notifyListeners();
  }
}
