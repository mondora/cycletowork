import 'package:flutter/material.dart';

class Screen {
  static ScreenSize getScreen(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var screen = ScreenSize.laptop;
    if (width < 320) {
      screen = ScreenSize.mobileS;
    } else if (width < 375) {
      screen = ScreenSize.mobileM;
    } else if (width < 425) {
      screen = ScreenSize.mobileL;
    } else if (width < 768) {
      screen = ScreenSize.tablet;
    }
    return screen;
  }
}

enum ScreenSize {
  mobileS,
  mobileM,
  mobileL,
  tablet,
  laptop,
}
