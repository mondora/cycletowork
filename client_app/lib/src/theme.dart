import 'package:cycletowork/src/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData getLightTheme(bool justLocal, {double scale = 1.0}) {
    final colorScheme = AppColor.getLightColors(justLocal);
    final textTheme = _getTextTheme(colorScheme.text, scale);
    return ThemeData(
      textTheme: textTheme,
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
        error: colorScheme.error,
        onError: colorScheme.onError,
        errorContainer: colorScheme.errorContainer,
        onErrorContainer: colorScheme.onErrorContainer,
        background: colorScheme.background,
        onBackground: colorScheme.onBackground,
        surface: colorScheme.surface,
        onSurface: colorScheme.onSurface,
      ),
      scaffoldBackgroundColor: colorScheme.background,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
      ),
      appBarTheme: AppBarTheme(
        elevation: 1,
        backgroundColor: colorScheme.background,
        iconTheme: IconThemeData(
          color: colorScheme.onBackground,
        ),
        toolbarTextStyle: TextStyle(
          color: colorScheme.onBackground,
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.onBackground,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onBackground,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[200],
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: colorScheme.textSecondary,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: colorScheme.textDisabled,
          ),
        ),
        errorStyle: TextStyle(
          color: colorScheme.error,
        ),
        labelStyle: textTheme.subtitle1!.apply(
          color: colorScheme.textSecondary,
        ),
        helperMaxLines: 3,
        helperStyle: textTheme.caption!.apply(
          color: colorScheme.textSecondary,
        ),
        counterStyle: textTheme.caption!.apply(
          color: colorScheme.textSecondary,
        ),
        floatingLabelStyle: textTheme.caption!.apply(
          color: colorScheme.textSecondary,
        ),
        hintStyle: textTheme.caption!.apply(
          color: colorScheme.textSecondary,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.secondary,
      ),
      drawerTheme: const DrawerThemeData(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.background,
        selectedColor: colorScheme.actionSelected,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          side: BorderSide(
            color: colorScheme.actionSelected,
          ),
        ),
        labelStyle: textTheme.caption,
      ),
      extensions: {
        ColorSchemeExtension(
          warrning: colorScheme.warrning,
          success: colorScheme.success,
          action: colorScheme.action,
          textSecondary: colorScheme.textSecondary,
          info: colorScheme.info,
          textDisabled: colorScheme.textDisabled,
          textPrimary: colorScheme.text,
        ),
      },
    );
  }

  static ThemeData getDarkTheme(bool justLocal, {double scale = 1.0}) {
    final colorScheme = AppColor.getDarkColors(justLocal);
    final textTheme = _getTextTheme(colorScheme.text, scale);
    return ThemeData(
      textTheme: textTheme,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: colorScheme.primary,
        onPrimary: colorScheme.onPrimary,
        primaryContainer: colorScheme.primaryContainer,
        onPrimaryContainer: colorScheme.onPrimaryContainer,
        secondary: colorScheme.secondary,
        onSecondary: colorScheme.onSecondary,
        secondaryContainer: colorScheme.secondaryContainer,
        onSecondaryContainer: colorScheme.onSecondaryContainer,
        error: colorScheme.error,
        onError: colorScheme.onError,
        errorContainer: colorScheme.errorContainer,
        onErrorContainer: colorScheme.onErrorContainer,
        background: colorScheme.background,
        onBackground: colorScheme.onBackground,
        surface: colorScheme.surface,
        onSurface: colorScheme.onSurface,
      ),
      scaffoldBackgroundColor: colorScheme.background,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
      ),
      appBarTheme: AppBarTheme(
        elevation: 1,
        backgroundColor: colorScheme.background,
        iconTheme: IconThemeData(
          color: colorScheme.onBackground,
        ),
        toolbarTextStyle: TextStyle(
          color: colorScheme.onBackground,
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.onBackground,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onBackground,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[800],
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: colorScheme.textSecondary,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: colorScheme.textDisabled,
          ),
        ),
        errorStyle: TextStyle(
          color: colorScheme.error,
        ),
        labelStyle: textTheme.subtitle1!.apply(
          color: colorScheme.textSecondary,
        ),
        helperMaxLines: 3,
        helperStyle: textTheme.caption!.apply(
          color: colorScheme.textSecondary,
        ),
        counterStyle: textTheme.caption!.apply(
          color: colorScheme.textSecondary,
        ),
        floatingLabelStyle: textTheme.caption!.apply(
          color: colorScheme.textSecondary,
        ),
        hintStyle: textTheme.caption!.apply(
          color: colorScheme.textSecondary,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.secondary,
      ),
      drawerTheme: const DrawerThemeData(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.background,
        selectedColor: colorScheme.actionSelected,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          side: BorderSide(
            color: colorScheme.actionSelected,
          ),
        ),
        labelStyle: textTheme.caption,
      ),
      extensions: {
        ColorSchemeExtension(
          warrning: colorScheme.warrning,
          success: colorScheme.success,
          action: colorScheme.action,
          textSecondary: colorScheme.textSecondary,
          info: colorScheme.info,
          textDisabled: colorScheme.textDisabled,
          textPrimary: colorScheme.text,
        ),
      },
    );
  }

  static TextTheme _getTextTheme(Color text, double scale) {
    return TextTheme(
      headline1: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 96 * scale,
          letterSpacing: -1.5,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w300,
          color: text,
        ),
      ),
      headline2: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 60 * scale,
          letterSpacing: -0.5,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w300,
          color: text,
        ),
      ),
      headline3: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 48 * scale,
          letterSpacing: 0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          color: text,
        ),
      ),
      headline4: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 34 * scale,
          letterSpacing: 0.25,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          color: text,
        ),
      ),
      headline5: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 24 * scale,
          letterSpacing: 0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          color: text,
        ),
      ),
      headline6: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 20 * scale,
          letterSpacing: 0.15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: text,
        ),
      ),
      subtitle1: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 16 * scale,
          letterSpacing: 0.15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          color: text,
        ),
      ),
      subtitle2: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 14 * scale,
          letterSpacing: 0.1,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: text,
        ),
      ),
      bodyText1: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 16 * scale,
          letterSpacing: 0.15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          color: text,
        ),
      ),
      bodyText2: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 14 * scale,
          letterSpacing: 0.15,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          color: text,
        ),
      ),
      caption: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 12 * scale,
          letterSpacing: 0.4,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          color: text,
        ),
      ),
      button: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 14 * scale,
          letterSpacing: 0.4,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: text,
        ),
      ),
      overline: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 12 * scale,
          letterSpacing: 1.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
          color: text,
        ),
      ),
    );
  }
}

class ColorSchemeExtension extends ThemeExtension<ColorSchemeExtension> {
  final Color warrning;
  final Color success;
  final Color action;
  final Color textSecondary;
  final Color info;
  final Color textDisabled;
  final Color textPrimary;

  const ColorSchemeExtension({
    required this.warrning,
    required this.success,
    required this.action,
    required this.textSecondary,
    required this.info,
    required this.textDisabled,
    required this.textPrimary,
  });

  @override
  ThemeExtension<ColorSchemeExtension> copyWith({
    Color? warrning,
    Color? success,
    Color? action,
    Color? textSecondary,
    Color? info,
    Color? textDisabled,
    Color? textPrimary,
  }) =>
      ColorSchemeExtension(
        warrning: warrning ?? this.warrning,
        success: success ?? this.success,
        action: action ?? this.action,
        textSecondary: textSecondary ?? this.textSecondary,
        info: info ?? this.info,
        textDisabled: textDisabled ?? this.textDisabled,
        textPrimary: textPrimary ?? this.textPrimary,
      );

  @override
  ThemeExtension<ColorSchemeExtension> lerp(
      ThemeExtension<ColorSchemeExtension>? other, double t) {
    if (other is! ColorSchemeExtension) {
      return this;
    }

    return ColorSchemeExtension(
      warrning: Color.lerp(warrning, other.warrning, t) ?? warrning,
      success: Color.lerp(success, other.success, t) ?? success,
      action: Color.lerp(action, other.action, t) ?? action,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      info: Color.lerp(info, other.info, t) ?? info,
      textDisabled:
          Color.lerp(textDisabled, other.textDisabled, t) ?? textDisabled,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
    );
  }
}
