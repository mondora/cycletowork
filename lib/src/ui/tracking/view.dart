import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/workout.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/utility/activity_recognition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:provider/provider.dart';

class TrackingView extends StatelessWidget {
  final Workout workout;
  final GestureTapCancelCallback? pauseTracking;
  final GestureTapCancelCallback? showMap;
  final bool error;
  final String errorMessage;

  const TrackingView({
    Key? key,
    required this.pauseTracking,
    required this.showMap,
    required this.workout,
    required this.error,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final measurementUnit = context.read<AppData>().measurementUnit;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final Locale appLocale = Localizations.localeOf(context);
    final numberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );
    final trackingDurationInSeconds = workout.durationInSecond;
    final trackingCo2Kg = workout.co2InGram.gramToKg();
    final trackingCo2Pound = workout.co2InGram.gramToPound();
    final trackingCo2 = measurementUnit == AppMeasurementUnit.metric
        ? trackingCo2Kg
        : trackingCo2Pound;
    final trackingAvarageSpeedKmPerHour =
        workout.averageSpeedInMeterPerSecond.meterPerSecondToKmPerHour();
    final trackingAvarageSpeedMilePerHour =
        workout.averageSpeedInMeterPerSecond.meterPerSecondToMilePerHour();
    final trackingAvarageSpeed = measurementUnit == AppMeasurementUnit.metric
        ? trackingAvarageSpeedKmPerHour
        : trackingAvarageSpeedMilePerHour;

    final trackingSpeed = workout.listLocationData.isNotEmpty
        ? measurementUnit == AppMeasurementUnit.metric
            ? workout.listLocationData.last.speed
                .meterPerSecondToKmPerHour()
                .abs()
            : workout.listLocationData.last.speed
                .meterPerSecondToMilePerHour()
                .abs()
        : 0.0;
    final trackingDistanceInKm = workout.distanceInMeter.meterToKm();
    final trackingDistanceInMile = workout.distanceInMeter.meterToMile();
    final trackingDistance = measurementUnit == AppMeasurementUnit.metric
        ? trackingDistanceInKm
        : trackingDistanceInMile;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          right: error ? 0 : 24.0 * scale,
          left: error ? 0 : 24.0 * scale,
          top: error ? 0 : 30.0 * scale,
        ),
        child: ListView(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          children: [
            if (error)
              Container(
                padding: EdgeInsets.all(20 * scale),
                margin: EdgeInsets.only(bottom: 20.0 * scale),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                ),
                child: Center(
                  child: Text(
                    errorMessage,
                    style: textTheme.bodyText1!.apply(
                      color: colorScheme.onError,
                    ),
                  ),
                ),
              ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: _TimeTracking(
                    time: Duration(
                      seconds: trackingDurationInSeconds,
                    ).toHoursMinutesSeconds(),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: _getActivityIcon(context, workout),
                ),
              ],
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
            SizedBox(
              height: 20.0 * scale,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getActivityIcon(BuildContext context, Workout workout) {
    final colorScheme = Theme.of(context).colorScheme;
    if (workout.activityTypeDetected == null ||
        workout.activityConfidenceDetected == null) {
      return Container();
    }
    final opacity = _getOpacity(workout.activityConfidenceDetected!);
    switch (workout.activityTypeDetected!) {
      case ActivityType.inVehicle:
        return Icon(
          Icons.directions_car_filled_outlined,
          color: colorScheme.onBackground.withOpacity(opacity),
        );
      case ActivityType.onBicycle:
        return Icon(
          Icons.directions_bike_rounded,
          color: colorScheme.onBackground.withOpacity(opacity),
        );
      case ActivityType.running:
        return Icon(
          Icons.directions_run_rounded,
          color: colorScheme.onBackground.withOpacity(opacity),
        );
      case ActivityType.walking:
        return Icon(
          Icons.directions_walk_rounded,
          color: colorScheme.onBackground.withOpacity(opacity),
        );
      case ActivityType.still:
        return Icon(
          Icons.boy_rounded,
          color: colorScheme.onBackground.withOpacity(opacity),
        );
      case ActivityType.unknown:
        return Container();
    }
  }

  double _getOpacity(ActivityConfidence confidence) {
    switch (confidence) {
      case ActivityConfidence.high:
        return 1.0;
      case ActivityConfidence.medium:
        return 0.70;
      case ActivityConfidence.low:
        return 0.50;
    }
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
