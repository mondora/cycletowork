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
  final bool actionsAlignmentCenter;
  final bool justContent;
  final Widget? contain;

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
    this.actionsAlignmentCenter = true,
    this.justContent = false,
    this.contain,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = colorScheme.brightness == Brightness.light
        ? colorScheme.secondary
        : colorScheme.primary;
    final scale = context.read<AppData>().scale;
    final radius = 15.0 * scale;

    borderRadius = borderRadius ??
        BorderRadius.all(
          Radius.circular(radius),
        );
    titleStyle = titleStyle ?? textTheme.headline6;
    subtitleStyle = subtitleStyle ?? textTheme.bodyText1;
    bodyStyle = bodyStyle ?? textTheme.bodyText2;
    confirmLabelStyle = confirmLabelStyle ??
        textTheme.caption!.copyWith(
          color: iscConfirmDestructiveAction ? colorScheme.error : color,
        );

    confirmButtonStyle = confirmButtonStyle ??
        TextButton.styleFrom(
          padding: EdgeInsets.all(radius),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          foregroundColor:
              iscConfirmDestructiveAction ? colorScheme.error : color,
        );

    cancelLabelStyle = cancelLabelStyle ??
        textTheme.caption!.copyWith(
          color: iscCancelDestructiveAction ? colorScheme.error : color,
        );

    cancelButtonStyle = cancelButtonStyle ??
        TextButton.styleFrom(
          padding: EdgeInsets.all(radius),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          foregroundColor:
              iscCancelDestructiveAction ? colorScheme.error : color,
        );
  }

  Future<bool?> show() async {
    if (justContent) {
      return showGeneralDialog(
        context: context,
        barrierColor: Theme.of(context).colorScheme.background,
        barrierDismissible: barrierDismissible,
        barrierLabel: 'Dialog',
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) {
          final scale = context.read<AppData>().scale;
          return Padding(
            padding: EdgeInsets.only(
              top: 80.0,
              right: 20.0 * scale,
              left: 20.0 * scale,
            ),
            child: contain!,
          );
        },
      );
    }

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
          actionsAlignment: cancelLabel != null && actionsAlignmentCenter
              ? MainAxisAlignment.center
              : null,
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
