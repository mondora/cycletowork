import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

enum AppMeasurementUnit {
  metric,
  imperial,
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

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  AppMeasurementUnit _measurementUnit = AppMeasurementUnit.metric;
  AppMeasurementUnit get measurementUnit => _measurementUnit;

  String _version = '';
  String get version => _version;

  bool _isHuaweiDevice = false;
  bool get isHuaweiDevice => _isHuaweiDevice;

  bool _isAppReviewed = true;
  bool get isAppReviewed => _isAppReviewed;

  AppData() : this.instance();

  AppData.instance() {
    getter();
  }

  getter() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      _isWakelockModeEnable = sharedPreferences.getBool(
            'isWakelockModeEnable',
          ) ??
          false;

      var result = sharedPreferences.getString(
        'appThemeMode',
      );
      switch (result) {
        case null:
          _themeMode = ThemeMode.system;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'system':
        case 'automatico':
          _themeMode = ThemeMode.system;
          break;
        default:
          _themeMode = ThemeMode.system;
          break;
      }
      final resultUnit = sharedPreferences.getString(
            'appMeasurementUnit',
          ) ??
          AppMeasurementUnit.metric.name;
      _measurementUnit = AppMeasurementUnit.values.firstWhere(
        (element) => element.name == resultUnit,
      );
      _isAppReviewed = sharedPreferences.getBool(
            'isAppReviewed',
          ) ??
          false;
    } catch (e) {
      Logger.error(e);
    }

    if (kIsWeb) {
      notifyListeners();
      return;
    }

    await _getMarkers();
    try {
      _darkMapStyle =
          await rootBundle.loadString('assets/maps/dark_theme.json');
      _lightMapStyle =
          await rootBundle.loadString('assets/maps/light_theme.json');
    } catch (e) {
      Logger.error(e);
    }
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _version = '${packageInfo.version} (${packageInfo.buildNumber})';

      final isAndroid = defaultTargetPlatform == TargetPlatform.android;
      if (isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _isHuaweiDevice =
            androidInfo.manufacturer.toLowerCase().contains('huawei');
      }
    } catch (e) {
      Logger.error(e);
    }
    notifyListeners();
  }

  ThemeData _lightThemeData = AppTheme.getLightTheme(false, scale: 1.0);
  ThemeData get lightThemeData => _lightThemeData;

  ThemeData _darkThemeData = AppTheme.getDarkTheme(false, scale: 1.0);
  ThemeData get darkThemeData => _darkThemeData;

  static User? user;
  static bool isUserUsedEmailProvider = false;

  setScaleThemeData(double scale) async {
    _scale = scale;
    _lightThemeData = AppTheme.getLightTheme(false, scale: scale);
    _darkThemeData = AppTheme.getDarkTheme(false, scale: scale);
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

  appReviewed() async {
    _isAppReviewed = true;
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(
      'isAppReviewed',
      true,
    );
    await sharedPreferences.setInt(
      'isAppReviewDate',
      DateTime.now().millisecondsSinceEpoch,
    );
    notifyListeners();
  }

  setThemeMode(String value) async {
    switch (value.toLowerCase()) {
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'system':
      case 'automatico':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.system;
        break;
    }
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      'appThemeMode',
      value.toLowerCase(),
    );
    notifyListeners();
  }

  setMeasurementUnit(String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      'appMeasurementUnit',
      value,
    );
    _measurementUnit = AppMeasurementUnit.values.firstWhere(
      (element) => element.name == value,
    );
    notifyListeners();
  }

  Future<void> _getMarkers() async {
    try {
      _markerCurrentPositionIcon = await _getBytesFromAsset(
        'assets/images/marker_current_position.png',
        (80 * scale).toInt(),
      );
    } catch (e) {
      Logger.error(e);
    }
    try {
      _markerStartPositionIcon = await _getBytesFromAsset(
        'assets/images/marker_start_position.png',
        (80 * scale).toInt(),
      );
    } catch (e) {
      Logger.error(e);
    }
    try {
      _markerStopPositionIcon = await _getBytesFromAsset(
        'assets/images/marker_stop_position.png',
        (80 * scale).toInt(),
      );
    } catch (e) {
      Logger.error(e);
    }
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
