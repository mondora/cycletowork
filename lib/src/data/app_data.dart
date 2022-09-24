import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

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

  Uint8List? _markerCurrentPositionIcon;
  Uint8List? get markerCurrentPositionIcon => _markerCurrentPositionIcon;

  Uint8List? _markerStartPositionIcon;
  Uint8List? get markerStartPositionIcon => _markerStartPositionIcon;

  Uint8List? _markerStopPositionIcon;
  Uint8List? get markerStopPositionIcon => _markerStopPositionIcon;

  String? _darkMapStyle;
  String? get darkMapStyle => _darkMapStyle;

  String? _lightMapStyle;
  String? get lightMapStyle => _lightMapStyle;

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

    await _getMarkers();
    _darkMapStyle = await rootBundle.loadString('assets/maps/dark_theme.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/maps/light_theme.json');
  }

  ThemeData _themeData = AppTheme.getLightTheme(false, scale: 1.0);
  ThemeData get themeData => _themeData;

  static User? user;
  static bool isUserUsedEmailProvider = false;

  setScaleThemeData(double scale) async {
    _scale = scale;
    _themeData = AppTheme.getLightTheme(false, scale: scale);
    await _getMarkers();
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

  Future<void> _getMarkers() async {
    _markerCurrentPositionIcon = await _getBytesFromAsset(
      'assets/images/marker_current_position.png',
      (80 * scale).toInt(),
    );
    _markerStartPositionIcon = await _getBytesFromAsset(
      'assets/images/marker_start_position.png',
      (80 * scale).toInt(),
    );
    _markerStopPositionIcon = await _getBytesFromAsset(
      'assets/images/marker_stop_position.png',
      (80 * scale).toInt(),
    );
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
