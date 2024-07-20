import 'package:flutter/material.dart';
import 'package:football/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightmode;

  ThemeData get themeData => themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightmode) {
      _themeData = darkmode;
    } else {
      _themeData = lightmode;
    }
  }
}
