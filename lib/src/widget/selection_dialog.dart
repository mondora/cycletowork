import 'package:cycletowork/src/data/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppSelectionDialog {
  final BuildContext context;
  BorderRadius? borderRadius;

  final List<String> listLabel;
  TextStyle? labelStyle;
  ButtonStyle? labelButtonStyle;
  bool barrierDismissible;

  AppSelectionDialog({
    required this.context,
    this.borderRadius,
    required this.listLabel,
    this.labelStyle,
    this.labelButtonStyle,
    this.barrierDismissible = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = colorScheme.brightness == Brightness.light
        ? colorScheme.secondary
        : colorScheme.primary;

    final textTheme = Theme.of(context).textTheme;
    final scale = context.read<AppData>().scale;
    final radius = 15.0 * scale;

    borderRadius = borderRadius ??
        BorderRadius.all(
          Radius.circular(radius),
        );
    labelStyle = labelStyle ??
        textTheme.bodyText1!.copyWith(
          color: color,
        );

    labelButtonStyle = labelButtonStyle ??
        TextButton.styleFrom(
          padding: EdgeInsets.all(radius),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          foregroundColor: color,
          minimumSize: const Size(double.infinity, 40.0),
        );
  }

  Future<String?> show() async {
    return showDialog<String?>(
      context: context,
      barrierDismissible: barrierDismissible, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var lable in listLabel)
                TextButton(
                  style: labelButtonStyle,
                  onPressed: () => Navigator.of(context).pop(lable),
                  child: Text(
                    lable,
                    style: labelStyle,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
