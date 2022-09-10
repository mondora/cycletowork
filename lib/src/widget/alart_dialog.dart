import 'package:flutter/material.dart';

class AppAlartDialog {
  final BuildContext context;
  BorderRadius? borderRadius;
  final String title;
  TextStyle? titleStyle;
  final String subtitle;
  TextStyle? subtitleStyle;
  final String body;
  TextStyle? bodyStyle;
  final String confirmLabel;
  TextStyle? confirmLabelStyle;
  ButtonStyle? confirmButtonStyle;
  bool barrierDismissible;

  AppAlartDialog({
    required this.context,
    this.borderRadius,
    required this.title,
    this.titleStyle,
    required this.subtitle,
    this.subtitleStyle,
    required this.body,
    this.bodyStyle,
    required this.confirmLabel,
    this.confirmLabelStyle,
    this.confirmButtonStyle,
    this.barrierDismissible = false,
  }) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    borderRadius = borderRadius ??
        const BorderRadius.all(
          Radius.circular(15.0),
        );
    titleStyle = titleStyle ?? textTheme.headline6;
    subtitleStyle = subtitleStyle ?? textTheme.bodyText1;
    bodyStyle = bodyStyle ?? textTheme.bodyText2;
    confirmLabelStyle = confirmLabelStyle ??
        textTheme.caption!.copyWith(
          color: colorScheme.secondary,
        );

    confirmButtonStyle = confirmButtonStyle ??
        TextButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          foregroundColor: colorScheme.secondary,
        );
  }

  Future<bool?> show() async {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: barrierDismissible, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          title: Text(
            title,
            style: titleStyle,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  subtitle,
                  style: subtitleStyle,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  body,
                  style: bodyStyle,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: confirmButtonStyle,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                confirmLabel,
                style: confirmLabelStyle,
              ),
            ),
          ],
        );
      },
    );
  }
}
