import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

// 100% — FF
// 95% — F2
// 90% — E6

// 85% — D9

// 80% — CC
// 75% — BF
// 70% — B3
// 65% — A6
// 60% — 99
// 55% — 8C
// 50% — 80
// 45% — 73
// 40% — 66
// 35% — 59
// 30% — 4D
// 25% — 40
// 20% — 33
// 15% — 26
// 10% — 1A
// 5% — 0D
// 0% — 00
class AppColor {
  static const String _lightColorSchemeKey = 'lightColorScheme';
  static get lightPrimary => 0xFFFFDA03;
  static get lightOnPrimary => 0xFFFFFFFF;
  static get lightPrimaryContainer => 0xFFFFF34F;
  static get lightOnPrimaryContainer => 0xFFFFC803;
  static get lightSecondary => 0xFF006AA7;
  static get lightOnSecondary => 0xFFFFFFFF;
  static get lightSecondaryContainer => 0xFFB2CFDF;
  static get lightOnSecondaryContainer => 0xFF003350;
  static get lightError => 0xFFF44336;
  static get lightOnError => 0xFFFFFFFF;
  static get lightErrorContainer => 0xFFE31B0C;
  static get lightOnErrorContainer => 0xFFF88078;
  static get lightBackground => 0xFFFFFFFF;
  static get lightOnBackground => 0xFF000000;
  static get lightSurface => 0xFFFFFFFF;
  static get lightOnSurface => 0xFF000000;
  static get lightText => 0xFF000000;
  static get lightTextPrimary => 0xD9000000;
  static get lightTextSecondary => 0x99000000;
  static get lightTextDisabled => 0x66000000;
  static get lightSuccess => 0xFF4CAF50;
  static get lightWarrning => 0xFFED6C02;
  static get lightAction => 0x8C000000;
  static get lightInfo => 0xFF2196F3;
  static get lightActionSelected => 0x1A000000;

  static Future initial() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setDefaults(<String, dynamic>{
      _lightColorSchemeKey: jsonEncode({
        'primary': lightPrimary,
        'onPrimary': lightOnPrimary,
        'primaryContainer': lightPrimaryContainer,
        'onPrimaryContainer': lightOnPrimaryContainer,
        'secondary': lightSecondary,
        'onSecondary': lightOnSecondary,
        'secondaryContainer': lightSecondaryContainer,
        'onSecondaryContainer': lightOnSecondaryContainer,
        'error': lightError,
        'onError': lightOnError,
        'errorContainer': lightErrorContainer,
        'onErrorContainer': lightOnErrorContainer,
        'background': lightBackground,
        'onBackground': lightOnBackground,
        'surface': lightSurface,
        'onSurface': lightOnSurface,
        'text': lightText,
        'textPrimary': lightTextPrimary,
        'textSecondary': lightTextSecondary,
        'textDisabled': lightTextDisabled,
        'success': lightSuccess,
        'warrning': lightWarrning,
        'action': lightAction,
        'info': lightInfo,
        'actionSelected': lightActionSelected,
      })
    });

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 1),
      ),
    );
    await remoteConfig.fetchAndActivate();
  }

  static LightColors getLightColors() {
    final remoteConfig = FirebaseRemoteConfig.instance;
    return LightColors.fromJson(
      jsonDecode(
        remoteConfig.getString(
          _lightColorSchemeKey,
        ),
      ),
    );
  }
}

class LightColors {
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color text;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color success;
  final Color warrning;
  final Color action;
  final Color info;
  final Color actionSelected;

  LightColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.text,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.success,
    required this.warrning,
    required this.action,
    required this.info,
    required this.actionSelected,
  });

  LightColors.fromJson(Map<String, dynamic> json)
      : primary = Color(json['primary'] ?? AppColor.lightPrimary),
        onPrimary = Color(json['onPrimary'] ?? AppColor.lightOnPrimary),
        primaryContainer =
            Color(json['primaryContainer'] ?? AppColor.lightPrimaryContainer),
        onPrimaryContainer = Color(
            json['onPrimaryContainer'] ?? AppColor.lightOnPrimaryContainer),
        secondary = Color(json['secondary'] ?? AppColor.lightSecondary),
        onSecondary = Color(json['onSecondary'] ?? AppColor.lightOnSecondary),
        secondaryContainer = Color(
            json['secondaryContainer'] ?? AppColor.lightSecondaryContainer),
        onSecondaryContainer = Color(
            json['onSecondaryContainer'] ?? AppColor.lightOnSecondaryContainer),
        error = Color(json['error'] ?? AppColor.lightError),
        onError = Color(json['onError'] ?? AppColor.lightOnError),
        errorContainer =
            Color(json['errorContainer'] ?? AppColor.lightErrorContainer),
        onErrorContainer =
            Color(json['onErrorContainer'] ?? AppColor.lightOnErrorContainer),
        background = Color(json['background'] ?? AppColor.lightBackground),
        onBackground =
            Color(json['onBackground'] ?? AppColor.lightOnBackground),
        surface = Color(json['surface'] ?? AppColor.lightSurface),
        onSurface = Color(json['onSurface'] ?? AppColor.lightOnSurface),
        text = Color(json['text'] ?? AppColor.lightText),
        textPrimary = Color(json['textPrimary'] ?? AppColor.lightTextPrimary),
        textSecondary =
            Color(json['textSecondary'] ?? AppColor.lightTextSecondary),
        textDisabled =
            Color(json['textDisabled'] ?? AppColor.lightTextDisabled),
        success = Color(json['success'] ?? AppColor.lightSuccess),
        warrning = Color(json['warrning'] ?? AppColor.lightWarrning),
        action = Color(json['action'] ?? AppColor.lightAction),
        info = Color(json['info'] ?? AppColor.lightInfo),
        actionSelected =
            Color(json['actionSelected'] ?? AppColor.lightActionSelected);
}
