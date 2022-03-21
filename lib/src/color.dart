import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class AppColor {
  static const String _lightColorSchemeKey = 'lightColorScheme';
  static get primary => 0xFF009A91;
  static get onPrimary => 0xFFFFFFFF;
  static get primaryContainer => 0xFFB2DDDF;
  static get onPrimaryContainer => 0xFF004150;
  static get secondary => 0xFFC715AC;
  static get onSecondary => 0xFFFFFFFF;
  static get secondaryContainer => 0xFFE99FDE;
  static get onSecondaryContainer => 0xFF990F84;
  static get tertiary => 0xFF6200EE;
  static get onTertiary => 0xFF6200EE;
  static get tertiaryContainer => 0xFF6200EE;
  static get onTertiaryContainer => 0xFF6200EE;
  static get error => 0xFFF44336;
  static get onError => 0xFFFFFFFF;
  static get errorContainer => 0xFFE31B0C;
  static get onErrorContainer => 0xFFF88078;
  static get background => 0xFFFFFFFF;
  static get onBackground => 0xFF323232;
  static get surface => 0xFFFFFFFF;
  static get onSurface => 0xFF323232;
  static get surfaceVariant => 0xFF6200EE;
  static get onSurfaceVariant => 0xFF6200EE;
  static get outline => 0xFF6200EE;
  static get shadow => 0xFF6200EE;
  static get inverseSurface => 0xFF6200EE;
  static get onInverseSurface => 0xFF6200EE;
  static get inversePrimary => 0xFF6200EE;

  static Future initial() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setDefaults(<String, dynamic>{
      _lightColorSchemeKey: jsonEncode({
        'primary': primary,
        'onPrimary': onPrimary,
        'primaryContainer': primaryContainer,
        'onPrimaryContainer': onPrimaryContainer,
        'secondary': secondary,
        'onSecondary': onSecondary,
        'secondaryContainer': secondaryContainer,
        'onSecondaryContainer': onSecondaryContainer,
        'tertiary': tertiary,
        'onTertiary': onTertiary,
        'tertiaryContainer': tertiaryContainer,
        'onTertiaryContainer': onTertiaryContainer,
        'error': error,
        'onError': onError,
        'errorContainer': errorContainer,
        'onErrorContainer': onErrorContainer,
        'background': background,
        'onBackground': onBackground,
        'surface': surface,
        'onSurface': onSurface,
        'surfaceVariant': surfaceVariant,
        'onSurfaceVariant': onSurfaceVariant,
        'outline': outline,
        'shadow': shadow,
        'inverseSurface': inverseSurface,
        'onInverseSurface': onInverseSurface,
        'inversePrimary': inversePrimary,
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
      : primary = Color(json['primary'] ?? AppColor.primary),
        onPrimary = Color(json['onPrimary'] ?? AppColor.onPrimary),
        primaryContainer =
            Color(json['primaryContainer'] ?? AppColor.primaryContainer),
        onPrimaryContainer =
            Color(json['onPrimaryContainer'] ?? AppColor.onPrimaryContainer),
        secondary = Color(json['secondary'] ?? AppColor.secondary),
        onSecondary = Color(json['onSecondary'] ?? AppColor.onSecondary),
        secondaryContainer =
            Color(json['secondaryContainer'] ?? AppColor.secondaryContainer),
        onSecondaryContainer = Color(
            json['onSecondaryContainer'] ?? AppColor.onSecondaryContainer),
        tertiary = Color(json['tertiary'] ?? AppColor.tertiary),
        onTertiary = Color(json['onTertiary'] ?? AppColor.onTertiary),
        tertiaryContainer =
            Color(json['tertiaryContainer'] ?? AppColor.tertiaryContainer),
        onTertiaryContainer =
            Color(json['onTertiaryContainer'] ?? AppColor.onTertiaryContainer),
        error = Color(json['error'] ?? AppColor.error),
        onError = Color(json['onError'] ?? AppColor.onError),
        errorContainer =
            Color(json['errorContainer'] ?? AppColor.errorContainer),
        onErrorContainer =
            Color(json['onErrorContainer'] ?? AppColor.onErrorContainer),
        background = Color(json['background'] ?? AppColor.background),
        onBackground = Color(json['onBackground'] ?? AppColor.onBackground),
        surface = Color(json['surface'] ?? AppColor.surface),
        onSurface = Color(json['onSurface'] ?? AppColor.onSurface),
        surfaceVariant =
            Color(json['surfaceVariant'] ?? AppColor.surfaceVariant),
        onSurfaceVariant =
            Color(json['onSurfaceVariant'] ?? AppColor.onSurfaceVariant),
        outline = Color(json['outline'] ?? AppColor.outline),
        shadow = Color(json['shadow'] ?? AppColor.shadow),
        inverseSurface =
            Color(json['inverseSurface'] ?? AppColor.inverseSurface),
        onInverseSurface =
            Color(json['onInverseSurface'] ?? AppColor.onInverseSurface),
        inversePrimary =
            Color(json['inversePrimary'] ?? AppColor.inversePrimary);

  // LightColors.fromJson(Map<String, dynamic> json)
  //     : primary = Color(json['primary'] ?? AppColor.primary),
  //       onPrimary = Color(json['onPrimary'] ?? AppColor.onPrimary),
  //       primaryContainer = Color(json['primaryContainer']
  //           ? json['primaryContainer']
  //           : AppColor.primaryContainer),
  //       onPrimaryContainer = Color(json['onPrimaryContainer']
  //           ? json['onPrimaryContainer']
  //           : AppColor.onPrimaryContainer),
  //       secondary =
  //           Color(json['secondary'] ? json['secondary'] : AppColor.secondary),
  //       onSecondary = Color(
  //           json['onSecondary'] ? json['onSecondary'] : AppColor.onSecondary),
  //       secondaryContainer = Color(json['secondaryContainer']
  //           ? json['secondaryContainer']
  //           : AppColor.secondaryContainer),
  //       onSecondaryContainer = Color(json['onSecondaryContainer']
  //           ? json['onSecondaryContainer']
  //           : AppColor.onSecondaryContainer),
  //       tertiary =
  //           Color(json['tertiary'] ? json['tertiary'] : AppColor.tertiary),
  //       onTertiary = Color(
  //           json['onTertiary'] ? json['onTertiary'] : AppColor.onTertiary),
  //       tertiaryContainer = Color(json['tertiaryContainer']
  //           ? json['tertiaryContainer']
  //           : AppColor.tertiaryContainer),
  //       onTertiaryContainer = Color(json['onTertiaryContainer']
  //           ? json['onTertiaryContainer']
  //           : AppColor.onTertiaryContainer),
  //       error = Color(json['error'] ? json['error'] : AppColor.error),
  //       onError = Color(json['onError'] ? json['onError'] : AppColor.onError),
  //       errorContainer = Color(json['errorContainer']
  //           ? json['errorContainer']
  //           : AppColor.errorContainer),
  //       onErrorContainer = Color(json['onErrorContainer']
  //           ? json['onErrorContainer']
  //           : AppColor.onErrorContainer),
  //       background = Color(
  //           json['background'] ? json['background'] : AppColor.background),
  //       onBackground = Color(json['onBackground']
  //           ? json['onBackground']
  //           : AppColor.onBackground),
  //       surface = Color(json['surface'] ? json['surface'] : AppColor.surface),
  //       onSurface =
  //           Color(json['onSurface'] ? json['onSurface'] : AppColor.onSurface),
  //       surfaceVariant = Color(json['surfaceVariant']
  //           ? json['surfaceVariant']
  //           : AppColor.surfaceVariant),
  //       onSurfaceVariant = Color(json['onSurfaceVariant']
  //           ? json['onSurfaceVariant']
  //           : AppColor.onSurfaceVariant),
  //       outline = Color(json['outline'] ? json['outline'] : AppColor.outline),
  //       shadow = Color(json['shadow'] ? json['shadow'] : AppColor.shadow),
  //       inverseSurface = Color(json['inverseSurface']
  //           ? json['inverseSurface']
  //           : AppColor.inverseSurface),
  //       onInverseSurface = Color(json['onInverseSurface']
  //           ? json['onInverseSurface']
  //           : AppColor.onInverseSurface),
  //       inversePrimary = Color(json['inversePrimary']
  //           ? json['inversePrimary']
  //           : AppColor.inversePrimary);
}
