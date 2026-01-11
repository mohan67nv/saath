import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Mode State Provider
/// Manages the app's dark/light mode preference and persists it
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _key = 'theme_mode';
  
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  /// Load saved theme mode from shared preferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);
      if (saved != null) {
        state = ThemeMode.values.firstWhere(
          (mode) => mode.name == saved,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  /// Set theme mode and persist
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode.name);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggle() async {
    if (state == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  /// Check if dark mode is currently active
  bool isDark(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}
