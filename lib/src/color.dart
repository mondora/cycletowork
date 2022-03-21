import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class AppColor {
  static const String _lightColorSchemeKey = 'lightColorScheme';
  static get primary => const Color(0xFF6200EE);
  static get onPrimary => const Color(0xFF6200EE);
  static get primaryContainer => const Color(0xFF6200EE);
  static get onPrimaryContainer => const Color(0xFF6200EE);
  static get secondary => const Color(0xFF6200EE);
  static get onSecondary => const Color(0xFF6200EE);
  static get secondaryContainer => const Color(0xFF6200EE);
  static get onSecondaryContainer => const Color(0xFF6200EE);
  static get tertiary => const Color(0xFF6200EE);
  static get onTertiary => const Color(0xFF6200EE);
  static get tertiaryContainer => const Color(0xFF6200EE);
  static get onTertiaryContainer => const Color(0xFF6200EE);
  static get error => const Color(0xFF6200EE);
  static get onError => const Color(0xFF6200EE);
  static get errorContainer => const Color(0xFF6200EE);
  static get onErrorContainer => const Color(0xFF6200EE);
  static get background => const Color(0xFF6200EE);
  static get onBackground => const Color(0xFF6200EE);
  static get surface => const Color(0xFF6200EE);
  static get onSurface => const Color(0xFF6200EE);
  static get surfaceVariant => const Color(0xFF6200EE);
  static get onSurfaceVariant => const Color(0xFF6200EE);
  static get outline => const Color(0xFF6200EE);
  static get shadow => const Color(0xFF6200EE);
  static get inverseSurface => const Color(0xFF6200EE);
  static get onInverseSurface => const Color(0xFF6200EE);
  static get inversePrimary => const Color(0xFF6200EE);

  static Future initial() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setDefaults(<String, dynamic>{
      _lightColorSchemeKey: jsonEncode({
        'primary': primary,
        'onPrimary': 0xFFFFFFFF,
        'primaryContainer': 0xFF3700B3,
        'onPrimaryContainer': 0xFF6200EE,
        'secondary': 0xFF03DAC6,
        'onSecondary': 0xFF000000,
        'secondaryContainer': 0xFF018786,
        'onSecondaryContainer': 0xFF6200EE,
        'tertiary': 0xFF6200EE,
        'onTertiary': 0xFF6200EE,
        'tertiaryContainer': 0xFF6200EE,
        'onTertiaryContainer': 0xFF6200EE,
        'error': 0xFFB00020,
        'onError': 0xFFFFFFFF,
        'errorContainer': 0xFF6200EE,
        'onErrorContainer': 0xFF6200EE,
        'background': 0xFFFFFFFF,
        'onBackground': 0xFF000000,
        'surface': 0xFFFFFFFF,
        'onSurface': 0xFF000000,
        'surfaceVariant': 0xFF6200EE,
        'onSurfaceVariant': 0xFF6200EE,
        'outline': 0xFF6200EE,
        'shadow': 0xFF6200EE,
        'inverseSurface': 0xFF6200EE,
        'onInverseSurface': 0xFF6200EE,
        'inversePrimary': 0xFF6200EE,
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
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color shadow;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;

  LightColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.shadow,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
  });

  LightColors.fromJson(Map<String, dynamic> json)
      : primary = json['primary'] ? Color(json['primary']) : AppColor.primary,
        onPrimary =
            json['onPrimary'] ? Color(json['onPrimary']) : AppColor.onPrimary,
        primaryContainer = json['primaryContainer']
            ? Color(json['primaryContainer'])
            : AppColor.primaryContainer,
        onPrimaryContainer = json['onPrimaryContainer']
            ? Color(json['onPrimaryContainer'])
            : AppColor.onPrimaryContainer,
        secondary =
            json['secondary'] ? Color(json['secondary']) : AppColor.secondary,
        onSecondary = json['onSecondary']
            ? Color(json['onSecondary'])
            : AppColor.onSecondary,
        secondaryContainer = json['secondaryContainer']
            ? Color(json['secondaryContainer'])
            : AppColor.secondaryContainer,
        onSecondaryContainer = json['onSecondaryContainer']
            ? Color(json['onSecondaryContainer'])
            : AppColor.onSecondaryContainer,
        tertiary =
            json['tertiary'] ? Color(json['tertiary']) : AppColor.tertiary,
        onTertiary = json['onTertiary']
            ? Color(json['onTertiary'])
            : AppColor.onTertiary,
        tertiaryContainer = json['tertiaryContainer']
            ? Color(json['tertiaryContainer'])
            : AppColor.tertiaryContainer,
        onTertiaryContainer = json['onTertiaryContainer']
            ? Color(json['onTertiaryContainer'])
            : AppColor.onTertiaryContainer,
        error = json['error'] ? Color(json['error']) : AppColor.error,
        onError = json['onError'] ? Color(json['onError']) : AppColor.onError,
        errorContainer = json['errorContainer']
            ? Color(json['errorContainer'])
            : AppColor.errorContainer,
        onErrorContainer = json['onErrorContainer']
            ? Color(json['onErrorContainer'])
            : AppColor.onErrorContainer,
        background = json['background']
            ? Color(json['background'])
            : AppColor.background,
        onBackground = json['onBackground']
            ? Color(json['onBackground'])
            : AppColor.onBackground,
        surface = json['surface'] ? Color(json['surface']) : AppColor.surface,
        onSurface =
            json['onSurface'] ? Color(json['onSurface']) : AppColor.onSurface,
        surfaceVariant = json['surfaceVariant']
            ? Color(json['surfaceVariant'])
            : AppColor.surfaceVariant,
        onSurfaceVariant = json['onSurfaceVariant']
            ? Color(json['onSurfaceVariant'])
            : AppColor.onSurfaceVariant,
        outline = json['outline'] ? Color(json['outline']) : AppColor.outline,
        shadow = json['shadow'] ? Color(json['shadow']) : AppColor.shadow,
        inverseSurface = json['inverseSurface']
            ? Color(json['inverseSurface'])
            : AppColor.inverseSurface,
        onInverseSurface = json['onInverseSurface']
            ? Color(json['onInverseSurface'])
            : AppColor.onInverseSurface,
        inversePrimary = json['inversePrimary']
            ? Color(json['inversePrimary'])
            : AppColor.inversePrimary;
}
