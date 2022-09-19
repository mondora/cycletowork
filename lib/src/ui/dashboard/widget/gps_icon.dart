import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppGpsIcon extends StatelessWidget {
  final GpsStatus gpsStatus;
  final GestureTapCallback? onPressed;
  final bool visible;
  const AppGpsIcon({
    Key? key,
    required this.gpsStatus,
    this.onPressed,
    required this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final errorColor = Theme.of(context).colorScheme.error;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final warrningColor = colorSchemeExtension.warrning;
    final successColor = colorSchemeExtension.success;

    if (!visible) {
      return Container();
    }

    if (gpsStatus == GpsStatus.granted) {
      return IconButton(
        splashRadius: 20 * scale,
        onPressed: onPressed,
        icon: Icon(
          Icons.gps_fixed,
          color: successColor,
          size: 20 * scale,
        ),
      );
    }

    if (gpsStatus == GpsStatus.turnOn) {
      return IconButton(
        splashRadius: 20 * scale,
        onPressed: onPressed,
        icon: Icon(
          Icons.gps_fixed,
          color: warrningColor,
          size: 20 * scale,
        ),
      );
    }

    return IconButton(
      splashRadius: 25 * scale,
      onPressed: onPressed,
      icon: Icon(
        Icons.gps_off_outlined,
        color: errorColor,
        size: 20 * scale,
      ),
    );
  }
}
