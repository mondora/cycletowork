import 'package:cycletowork/src/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData getLightTheme() {
    final colorScheme = AppColor.getLightColors();
    return ThemeData.from(
      textTheme: _getTextTheme(),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: colorScheme.primary,
        onPrimary: colorScheme.onPrimary,
        primaryContainer: colorScheme.primaryContainer,
        onPrimaryContainer: colorScheme.onPrimaryContainer,
        secondary: colorScheme.secondary,
        onSecondary: colorScheme.onSecondary,
        secondaryContainer: colorScheme.secondaryContainer,
        onSecondaryContainer: colorScheme.onSecondaryContainer,
        tertiary: colorScheme.tertiary,
        onTertiary: colorScheme.onTertiary,
        tertiaryContainer: colorScheme.onTertiaryContainer,
        onTertiaryContainer: colorScheme.onTertiaryContainer,
        error: colorScheme.error,
        onError: colorScheme.onError,
        errorContainer: colorScheme.errorContainer,
        onErrorContainer: colorScheme.onErrorContainer,
        background: colorScheme.background,
        onBackground: colorScheme.onBackground,
        surface: colorScheme.surface,
        onSurface: colorScheme.onSurface,
        surfaceVariant: colorScheme.surfaceVariant,
        onSurfaceVariant: colorScheme.onSurfaceVariant,
        outline: colorScheme.outline,
        shadow: colorScheme.shadow,
        inverseSurface: colorScheme.inverseSurface,
        onInverseSurface: colorScheme.onInverseSurface,
        inversePrimary: colorScheme.inversePrimary,
      ),
    );
  }

  static TextTheme _getTextTheme() {
    return TextTheme(
      headline1: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 96,
          letterSpacing: -1.5,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w300,
        ),
      ),
      headline2: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 60,
          letterSpacing: -0.5,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w300,
        ),
      ),
      headline3: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 48,
          letterSpacing: 0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
      ),
      headline4: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 34,
          letterSpacing: 0.25,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
      ),
      headline5: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 24,
          letterSpacing: 0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
      ),
      headline6: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 20,
          letterSpacing: 0.15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle1: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 16,
          letterSpacing: 0.15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle2: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 14,
          letterSpacing: 0.1,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
        ),
      ),
      bodyText1: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 16,
          letterSpacing: 0.15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
      ),
      bodyText2: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 14,
          letterSpacing: 0.15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
      ),
      caption: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 12,
          letterSpacing: 0.4,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
      ),
      button: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 14,
          letterSpacing: 0.4,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
        ),
      ),
      overline: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 12,
          letterSpacing: 1.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
