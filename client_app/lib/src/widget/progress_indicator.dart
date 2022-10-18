import 'package:cycletowork/src/data/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:provider/provider.dart';

class AppProgressIndicator extends StatelessWidget {
  final double radius;
  final double androidStrokeWidth;
  final Color? color;

  const AppProgressIndicator({
    Key? key,
    this.radius = 20.0,
    this.androidStrokeWidth = 4.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final colorScheme = Theme.of(context).colorScheme;
    final color = this.color ??
        (colorScheme.brightness == Brightness.light
            ? colorScheme.secondary
            : colorScheme.primary);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoActivityIndicator(
        radius: radius * scale,
        color: color,
      );
    }
    return SizedBox(
      height: radius * 2 * scale,
      width: radius * 2 * scale,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: androidStrokeWidth * scale,
      ),
    );
  }
}
