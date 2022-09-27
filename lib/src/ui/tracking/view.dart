import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:provider/provider.dart';

class TrackingView extends StatelessWidget {
  final LocationData? lastLocation;
  final UserActivity trackingUserActivity;
  final GestureTapCancelCallback? pauseTracking;
  final GestureTapCancelCallback? showMap;

  const TrackingView({
    Key? key,
    required this.trackingUserActivity,
    required this.pauseTracking,
    required this.showMap,
    required this.lastLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final measurementUnit = context.read<AppData>().measurementUnit;
    final Locale appLocale = Localizations.localeOf(context);
    final numberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );
    final trackingDurationInSeconds = trackingUserActivity.duration;
    final trackingCo2Kg = trackingUserActivity.co2.gramToKg();
    final trackingCo2Pound = trackingUserActivity.co2.gramToPound();
    final trackingCo2 = measurementUnit == AppMeasurementUnit.metric
        ? trackingCo2Kg
        : trackingCo2Pound;
    final trackingAvarageSpeedKmPerHour =
        trackingUserActivity.averageSpeed.meterPerSecondToKmPerHour();
    final trackingAvarageSpeedMilePerHour =
        trackingUserActivity.averageSpeed.meterPerSecondToMilePerHour();
    final trackingAvarageSpeed = measurementUnit == AppMeasurementUnit.metric
        ? trackingAvarageSpeedKmPerHour
        : trackingAvarageSpeedMilePerHour;

    final trackingSpeed = lastLocation != null
        ? measurementUnit == AppMeasurementUnit.metric
            ? lastLocation!.speed.meterPerSecondToKmPerHour().abs()
            : lastLocation!.speed.meterPerSecondToMilePerHour().abs()
        : 0.0;
    final trackingDistanceInKm = trackingUserActivity.distance.meterToKm();
    final trackingDistanceInMile = trackingUserActivity.distance.meterToMile();
    final trackingDistance = measurementUnit == AppMeasurementUnit.metric
        ? trackingDistanceInKm
        : trackingDistanceInMile;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          right: 24.0 * scale,
          left: 24.0 * scale,
          top: 30.0 * scale,
        ),
        child: ListView(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          children: [
            _TimeTracking(
              time: Duration(
                seconds: trackingDurationInSeconds,
              ).toHoursMinutesSeconds(),
            ),
            const _Divider(),
            _Co2Tracking(
              co2: numberFormat.format(trackingCo2),
            ),
            const _Divider(),
            _DistanceTracking(
              distance: numberFormat.format(trackingDistance),
            ),
            const _Divider(),
            _SpeedTracking(
              avarageSpeed: numberFormat.format(trackingAvarageSpeed),
              speed: numberFormat.format(trackingSpeed),
            ),
            const _Divider(),
            SizedBox(
              height: 15 * scale,
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 80.0 * scale,
                    width: 80.0 * scale,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: pauseTracking,
                        child: Icon(
                          Icons.pause,
                          color: Colors.black,
                          size: 26.0 * scale,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin:
                        EdgeInsets.only(top: 10 * scale, right: 50.0 * scale),
                    height: 60.0 * scale,
                    width: 60.0 * scale,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: showMap,
                        child: SvgPicture.asset(
                          'assets/icons/map.svg',
                          height: 32.0 * scale,
                          width: 27.0 * scale,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 28.0 * scale,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    return Column(
      children: [
        SizedBox(
          height: 10.0 * scale,
        ),
        Divider(
          height: 1.0 * scale,
        ),
        SizedBox(
          height: 10.0 * scale,
        ),
      ],
    );
  }
}

class _TimeTracking extends StatelessWidget {
  final String time;
  const _TimeTracking({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Column(
      children: [
        Text(
          'TEMPO'.toUpperCase(),
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        ),
        Text(
          time,
          style: textTheme.headline4,
        ),
        Text(
          'h:m:s',
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        )
      ],
    );
  }
}

class _Co2Tracking extends StatelessWidget {
  final String co2;
  const _Co2Tracking({
    Key? key,
    required this.co2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final measurementUnit = context.read<AppData>().measurementUnit;
    final textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Column(
      children: [
        Text(
          'CO\u2082'.toUpperCase(),
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        ),
        Text(
          co2,
          style: textTheme.headline1!.copyWith(
            color: colorSchemeExtension.info,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          measurementUnit == AppMeasurementUnit.metric ? 'Kg' : 'lb',
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        )
      ],
    );
  }
}

class _DistanceTracking extends StatelessWidget {
  final String distance;
  const _DistanceTracking({
    Key? key,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final measurementUnit = context.read<AppData>().measurementUnit;
    final textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Column(
      children: [
        Text(
          'DISTANZA'.toUpperCase(),
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        ),
        Text(
          distance,
          style: textTheme.headline2!.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          measurementUnit == AppMeasurementUnit.metric ? 'km' : 'mi',
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SpeedTracking extends StatelessWidget {
  final String speed;
  final String avarageSpeed;
  const _SpeedTracking({
    Key? key,
    required this.speed,
    required this.avarageSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final measurementUnit = context.read<AppData>().measurementUnit;
    final textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              'VELOCITÀ'.toUpperCase(),
              style: textTheme.caption!.apply(
                color: colorSchemeExtension.textSecondary,
              ),
            ),
            Text(
              speed,
              style: textTheme.headline4,
            ),
            Text(
              measurementUnit == AppMeasurementUnit.metric ? 'km/h' : 'mi/h',
              style: textTheme.caption!.apply(
                color: colorSchemeExtension.textSecondary,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              'VELOCITÀ MEDIA'.toUpperCase(),
              style: textTheme.caption!.apply(
                color: colorSchemeExtension.textSecondary,
              ),
            ),
            Text(
              avarageSpeed,
              style: textTheme.headline4,
            ),
            Text(
              measurementUnit == AppMeasurementUnit.metric ? 'km/h' : 'mi/h',
              style: textTheme.caption!.apply(
                color: colorSchemeExtension.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
