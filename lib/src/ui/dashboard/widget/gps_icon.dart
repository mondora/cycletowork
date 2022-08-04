import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/utility/gps_status.dart';
import 'package:flutter/material.dart';

class AppGpsIcon extends StatelessWidget {
  final GpsStatus gpsStatus;
  final GestureTapCallback? onPressed;
  const AppGpsIcon({
    Key? key,
    required this.gpsStatus,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final warrningColor = colorSchemeExtension.warrning;
    final successColor = colorSchemeExtension.success;

    if (gpsStatus == GpsStatus.granted) {
      return IconButton(
        splashRadius: 20,
        onPressed: onPressed,
        icon: Icon(
          Icons.gps_fixed,
          color: successColor,
        ),
      );
    }

    if (gpsStatus == GpsStatus.turnOn) {
      return IconButton(
        splashRadius: 20,
        onPressed: onPressed,
        icon: Icon(
          Icons.gps_fixed,
          color: warrningColor,
        ),
      );
    }

    return IconButton(
      splashRadius: 25,
      onPressed: onPressed,
      icon: Icon(
        Icons.gps_off_outlined,
        color: errorColor,
      ),
    );
  }
}
