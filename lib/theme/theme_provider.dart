import 'package:flutter/material.dart';
import 'package:movieflix/services/shared_preferences_services.dart';
import 'package:movieflix/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  ThemeProvider() {
    _isDarkMode = SharedPreferencesService.i.getValue(key: "theme") == "true";
  }

  bool get isDarkMode => _isDarkMode;

  void changeTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    SharedPreferencesService.i
        .setValue(key: "theme", value: _isDarkMode.toString());
  }

  ThemeData get currentTheme => _isDarkMode ? themeDataDark : themeDatalight;
}
