import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/widget/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cycletowork/src/utility/convert.dart';

class TrackingPauseView extends StatelessWidget {
  final List<LocationData> listTrackingPosition;
  final UserActivity trackingUserActivity;
  final GestureTapCancelCallback? playTracking;
  final GestureTapCancelCallback? stopTracking;

  const TrackingPauseView({
    Key? key,
    required this.listTrackingPosition,
    required this.trackingUserActivity,
    required this.playTracking,
    required this.stopTracking,
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

    final trackingDistanceInKm = trackingUserActivity.distance.meterToKm();
    final trackingDistanceInMile = trackingUserActivity.distance.meterToMile();
    final trackingDistance = measurementUnit == AppMeasurementUnit.metric
        ? trackingDistanceInKm
        : trackingDistanceInMile;

    final isChallenge = trackingUserActivity.isChallenge == 1 ? true : false;

    final initialLatitude = listTrackingPosition.isNotEmpty
        ? listTrackingPosition.first.latitude
        : context.read<ViewModel>().uiState.currentPosition!.latitude;
    final initialLongitude = listTrackingPosition.isNotEmpty
        ? listTrackingPosition.first.longitude
        : context.read<ViewModel>().uiState.currentPosition!.longitude;

    return Scaffold(
      body: Stack(
        children: [
          Material(
            elevation: 4,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            child: SlidingUpPanel(
              backdropColor: Theme.of(context).colorScheme.background,
              maxHeight: 275.08 * scale,
              minHeight: 155.0 * scale,
              parallaxEnabled: true,
              parallaxOffset: 0.2,
              defaultPanelState: PanelState.OPEN,
              color: Theme.of(context).colorScheme.background,
              panelBuilder: (sc) => Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.drag_handle,
                        color: Colors.grey,
                        size: 20 * scale,
                      )
                    ],
                  ),
                  _SummeryCard(
                    time: Duration(
                      seconds: trackingDurationInSeconds,
                    ).toHoursMinutesSeconds(),
                    co2: numberFormat.format(trackingCo2),
                    distant: numberFormat.format(trackingDistance),
                    avarageSpeed: numberFormat.format(trackingAvarageSpeed),
                  ),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              body: Container(
                margin: EdgeInsets.only(bottom: 210.0 * scale),
                child: AppMap(
                  listTrackingPosition: listTrackingPosition,
                  isChallenge: isChallenge,
                  initialLatitude: initialLatitude,
                  initialLongitude: initialLongitude,
                  isStatic: listTrackingPosition.isNotEmpty ? true : false,
                  padding: 150.0,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Theme.of(context).colorScheme.background,
              padding: EdgeInsets.symmetric(
                horizontal: 24.0 * scale,
                vertical: 20.0 * scale,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80.0 * scale,
                    width: 80.0 * scale,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: stopTracking,
                        child: Icon(
                          Icons.stop,
                          color: Colors.black,
                          size: 30.0 * scale,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25.0 * scale,
                  ),
                  SizedBox(
                    height: 80.0 * scale,
                    width: 80.0 * scale,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: playTracking,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.black,
                          size: 30.0 * scale,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 35.0 * scale,
                  ),
                  SizedBox(
                    height: 60.0 * scale,
                    width: 60.0 * scale,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: Colors.grey,
                        onPressed: null,
                        child: SvgPicture.asset(
                          'assets/icons/map.svg',
                          height: 32.0 * scale,
                          width: 27.0 * scale,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummeryCard extends StatelessWidget {
  final String time;
  final String co2;
  final String distant;
  final String avarageSpeed;
  const _SummeryCard({
    Key? key,
    required this.time,
    required this.co2,
    required this.distant,
    required this.avarageSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;

    return Column(
      children: [
        SizedBox(
          height: 10.0 * scale,
        ),
        _TimeTracking(
          time: time,
        ),
        _Co2Tracking(
          co2: co2,
        ),
        _SpeedTracking(
          avarageSpeed: avarageSpeed,
        ),
        _DistanceTracking(
          distance: distant,
        ),
        Container(
          margin: EdgeInsets.only(
            top: 12.0 * scale,
            right: 24.0 * scale,
            left: 24.0 * scale,
          ),
          child: const Divider(
            height: 1,
          ),
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
    final scale = context.read<AppData>().scale;
    final textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120 * scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Tempo'.toUpperCase(),
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 18.0 * scale,
        ),
        SizedBox(
          width: 135.0 * scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: textTheme.headline6,
              ),
              Text(
                'h:m:s',
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 50.0 * scale,
        ),
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
    final scale = context.read<AppData>().scale;
    final measurementUnit = context.read<AppData>().measurementUnit;
    final textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120 * scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'CO\u2082'.toUpperCase(),
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 18.0 * scale,
        ),
        SizedBox(
          width: 135.0 * scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                co2,
                style: textTheme.headline6!.copyWith(
                  color: colorSchemeExtension.info,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                measurementUnit == AppMeasurementUnit.metric ? 'Kg' : 'lb',
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 50.0 * scale,
        ),
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
    final scale = context.read<AppData>().scale;
    final measurementUnit = context.read<AppData>().measurementUnit;
    final textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120 * scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'DISTANZA'.toUpperCase(),
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 18.0 * scale,
        ),
        SizedBox(
          width: 135.0 * scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                distance,
                style: textTheme.headline6,
              ),
              Text(
                measurementUnit == AppMeasurementUnit.metric ? 'km' : 'mi',
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 50.0 * scale,
        ),
      ],
    );
  }
}

class _SpeedTracking extends StatelessWidget {
  final String avarageSpeed;
  const _SpeedTracking({
    Key? key,
    required this.avarageSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final measurementUnit = context.read<AppData>().measurementUnit;
    final textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120 * scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'VELOCITÀ MEDIA'.toUpperCase(),
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 18.0 * scale,
        ),
        SizedBox(
          width: 135.0 * scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                avarageSpeed,
                style: textTheme.headline6!.copyWith(
                  color: colorSchemeExtension.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                measurementUnit == AppMeasurementUnit.metric ? 'km/h' : 'mi/h',
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 50.0 * scale,
        ),
      ],
    );
  }
}
