import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppData with ChangeNotifier, DiagnosticableTreeMixin {
  double _scale = 1.0;
  double get scale => _scale;

  ThemeData _themeData = AppTheme.getLightTheme(false, scale: 1.0);
  ThemeData get themeData => _themeData;

  static User? user;
  static bool isUserUsedEmailProvider = false;

  setScaleThemeData(double scale) {
    _scale = scale;
    _themeData = AppTheme.getLightTheme(false, scale: scale);
    notifyListeners();
  }
}
