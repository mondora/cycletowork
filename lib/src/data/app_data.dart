import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppMeasurementUnit {
  metric,
  imperial,
}

enum AppThemeBrightness {
  light,
  dark,
  system,
}

class AppData with ChangeNotifier, DiagnosticableTreeMixin {
  double _scale = 1.0;
  double get scale => _scale;

  bool _isWakelockModeEnable = false;
  bool get isWakelockModeEnable => _isWakelockModeEnable;

  AppData() : this.instance();

  AppData.instance() {
    getter();
  }

  getter() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    _isWakelockModeEnable = sharedPreferences.getBool(
          'isWakelockModeEnable',
        ) ??
        false;
  }

  ThemeData _themeData = AppTheme.getLightTheme(false, scale: 1.0);
  ThemeData get themeData => _themeData;

  static User? user;
  static bool isUserUsedEmailProvider = false;

  setScaleThemeData(double scale) {
    _scale = scale;
    _themeData = AppTheme.getLightTheme(false, scale: scale);
    notifyListeners();
  }

  setWakelockModeEnable(bool value) async {
    _isWakelockModeEnable = value;
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(
      'isWakelockModeEnable',
      value,
    );
    notifyListeners();
  }
}
