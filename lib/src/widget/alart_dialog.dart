import 'package:cycletowork/src/data/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  bool iscConfirmDestructiveAction;
  bool barrierDismissible;
  final String? cancelLabel;
  TextStyle? cancelLabelStyle;
  ButtonStyle? cancelButtonStyle;
  final bool iscCancelDestructiveAction;

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
    this.iscConfirmDestructiveAction = false,
    this.barrierDismissible = false,
    this.cancelLabel,
    this.cancelLabelStyle,
    this.cancelButtonStyle,
    this.iscCancelDestructiveAction = false,
  }) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var scale = context.read<AppData>().scale;
    var radius = 15.0 * scale;

    borderRadius = borderRadius ??
        BorderRadius.all(
          Radius.circular(radius),
        );
    titleStyle = titleStyle ?? textTheme.headline6;
    subtitleStyle = subtitleStyle ?? textTheme.bodyText1;
    bodyStyle = bodyStyle ?? textTheme.bodyText2;
    confirmLabelStyle = confirmLabelStyle ??
        textTheme.caption!.copyWith(
          color: iscConfirmDestructiveAction
              ? colorScheme.error
              : colorScheme.secondary,
        );

    confirmButtonStyle = confirmButtonStyle ??
        TextButton.styleFrom(
          padding: EdgeInsets.all(radius),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          foregroundColor: iscConfirmDestructiveAction
              ? colorScheme.error
              : colorScheme.secondary,
        );

    cancelLabelStyle = cancelLabelStyle ??
        textTheme.caption!.copyWith(
          color: iscCancelDestructiveAction
              ? colorScheme.error
              : colorScheme.secondary,
        );

    cancelButtonStyle = cancelButtonStyle ??
        TextButton.styleFrom(
          padding: EdgeInsets.all(radius),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          foregroundColor: iscCancelDestructiveAction
              ? colorScheme.error
              : colorScheme.secondary,
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
          actionsAlignment:
              cancelLabel != null ? MainAxisAlignment.center : null,
          actions: <Widget>[
            if (cancelLabel != null)
              TextButton(
                style: cancelButtonStyle,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  cancelLabel!,
                  style: cancelLabelStyle,
                ),
              ),
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
