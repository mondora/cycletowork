import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class AppProgressIndicator extends StatelessWidget {
  final double radius;
  final double androidStrokeWidth;
  const AppProgressIndicator({
    Key? key,
    this.radius = 20.0,
    this.androidStrokeWidth = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoActivityIndicator(
        radius: radius,
        color: secondaryColor,
      );
    }
    return SizedBox(
      height: radius * 2,
      width: radius * 2,
      child: CircularProgressIndicator(
        color: secondaryColor,
        strokeWidth: androidStrokeWidth,
      ),
    );
  }
}
