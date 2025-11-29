import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends Notifier<bool> {
  static const String _themeKey = 'isDarkMode';
  
  @override
  bool build() {
    _loadThemePreference();
    return true; // Default to dark mode while loading
  }
  
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getBool(_themeKey);
    if (savedTheme != null) {
      state = savedTheme;
    }
  }
  
  Future<void> toggleTheme() async {
    state = !state;
    await _saveThemePreference(state);
  }
  
  Future<void> setDarkMode(bool isDark) async {
    state = isDark;
    await _saveThemePreference(isDark);
  }
  
  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, bool>(
  () => ThemeModeNotifier(),
);
