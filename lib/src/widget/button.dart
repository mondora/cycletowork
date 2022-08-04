import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
  facebookLogin,
  appleLogin,
  googleLogin,
  emailLogin,
}

class AppButton extends StatelessWidget {
  final String title;
  final GestureTapCallback? onPressed;
  final ButtonType type;
  final double maxWidth;
  final double horizontalMargin;
  final double radius;
  final double height;
  final bool textUpperCase;
  final bool loading;
  const AppButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.maxWidth = 400,
    this.horizontalMargin = 0,
    this.radius = 4.0,
    this.height = 36.0,
    this.textUpperCase = true,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttonStyle = _ButtonStyle(context, type);
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
      ),
      child: ButtonTheme(
        minWidth: maxWidth,
        height: height,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: MaterialButton(
          color: buttonStyle.backgroundColor,
          disabledColor: buttonStyle.backgroundColor.withOpacity(0.75),
          onPressed: loading == true ? null : onPressed,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              buttonStyle.icon != null ? buttonStyle.icon! : Container(),
              Text(
                textUpperCase ? title.toUpperCase() : title,
                style: buttonStyle.textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonStyle {
  late Color backgroundColor;
  late TextStyle textStyle;
  late Widget? icon;
  final double _marginRight = 5.0;

  _ButtonStyle(BuildContext context, ButtonType type) {
    var buttonStyle = Theme.of(context).textTheme.button;
    buttonStyle ??= const TextStyle();
    textStyle = buttonStyle;
    backgroundColor = Theme.of(context).colorScheme.primary;
    icon = null;

    if (type == ButtonType.primary) {
      backgroundColor = Theme.of(context).colorScheme.primary;
      textStyle = buttonStyle.apply(
        color: Theme.of(context).colorScheme.secondary,
      );
    }

    if (type == ButtonType.secondary) {
      backgroundColor = Theme.of(context).colorScheme.secondary;
      textStyle = buttonStyle.apply(
        color: Theme.of(context).colorScheme.onSecondary,
      );
    }

    if (type == ButtonType.facebookLogin) {
      backgroundColor = const Color.fromRGBO(76, 95, 145, 1);
      textStyle = buttonStyle.apply(
        color: Theme.of(context).colorScheme.onSecondary,
      );
      icon = Container(
        margin: EdgeInsets.only(right: _marginRight),
        child: Image.asset('assets/images/facebook_icon.png'),
      );
    }

    if (type == ButtonType.googleLogin) {
      backgroundColor = Colors.white;
      textStyle = buttonStyle.apply(
        color: Colors.black,
      );
      icon = Container(
        margin: EdgeInsets.only(right: _marginRight),
        child: Image.asset('assets/images/google_icon.png'),
      );
    }

    if (type == ButtonType.appleLogin) {
      backgroundColor = Colors.black;
      textStyle = buttonStyle.apply(
        color: Colors.white,
      );
      icon = Container(
        margin: EdgeInsets.only(right: _marginRight),
        child: Image.asset('assets/images/apple_icon.png'),
      );
    }

    if (type == ButtonType.emailLogin) {
      backgroundColor = Theme.of(context).colorScheme.secondary;
      textStyle = buttonStyle.apply(
        color: Theme.of(context).colorScheme.onSecondary,
      );
      icon = Container(
        margin: EdgeInsets.only(right: _marginRight),
        child: Image.asset('assets/images/email_icon.png'),
      );
    }
  }
}
