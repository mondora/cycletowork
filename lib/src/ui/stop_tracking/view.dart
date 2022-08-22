import 'package:cycletowork/src/data/chart_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/widget/chart.dart';
import 'package:cycletowork/src/widget/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

enum TrackingOption {
  distance,
  duration,
  avarageSpeed,
  calorie,
  steps,
  maxSpeed,
}

class StopTrackingView extends StatefulWidget {
  final List<LocationData> listTrackingPosition;
  final UserActivity trackingUserActivity;
  final GestureTapCancelCallback? saveTracking;
  final GestureTapCancelCallback? removeTracking;

  const StopTrackingView({
    Key? key,
    required this.listTrackingPosition,
    required this.trackingUserActivity,
    required this.saveTracking,
    required this.removeTracking,
  }) : super(key: key);

  @override
  State<StopTrackingView> createState() => _StopTrackingViewState();
}

class _StopTrackingViewState extends State<StopTrackingView> {
  String city = '';
  final GlobalKey<AppMapState> _mapKey = GlobalKey();

  @override
  void dispose() {
    _mapKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getCityName());
  }

  _getCityName() async {
    var firstPosition = widget.listTrackingPosition.first;
    final Locale appLocale = Localizations.localeOf(context);
    var result = await Gps.getCityName(
      firstPosition.latitude,
      firstPosition.longitude,
      localeIdentifier: appLocale.languageCode,
    );

    setState(() {
      city = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final Locale appLocale = Localizations.localeOf(context);
    final numberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );

    final endTrackingDate = DateTime.fromMillisecondsSinceEpoch(
      widget.trackingUserActivity.stopTime!,
    );
    final trackingDurationInSeconds = widget.trackingUserActivity.duration ?? 0;
    final trackingCo2 = (widget.trackingUserActivity.co2 ?? 0).gramToKg();
    final trackingAvarageSpeed = (widget.trackingUserActivity.averageSpeed ?? 0)
        .meterPerSecondToKmPerHour();
    final trackingMaxSpeed =
        (widget.trackingUserActivity.maxSpeed ?? 0).meterPerSecondToKmPerHour();
    final trackingCalorie = widget.trackingUserActivity.calorie ?? 0;
    final trackingSteps = widget.trackingUserActivity.steps ?? 0;
    final trackingDistanceInKm =
        (widget.trackingUserActivity.distance ?? 0).meterToKm();
    final isChallenge =
        widget.trackingUserActivity.isChallenge == 1 ? true : false;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0,
          ),
          children: [
            Text(
              DateFormat(
                'dd MMMM yyyy, HH:mm',
                appLocale.languageCode,
              ).format(endTrackingDate),
              style: textTheme.headline6,
            ),
            Text(
              city,
              style: textTheme.bodyText1!.apply(
                color: colorSchemeExtension.textSecondary,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: colorSchemeExtension.info,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/icons/co2.svg',
                    height: 46.0,
                    width: 46.0,
                    color: colorScheme.onSecondary,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    numberFormat.format(trackingCo2),
                    style: textTheme.headline4!.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Kg CO\u2082',
                    style: textTheme.headline4!.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 327.0,
              child: AppMap(
                key: _mapKey,
                listTrackingPosition: widget.listTrackingPosition,
                type: AppMapType.static,
                fit: BoxFit.fitWidth,
                isChallenge: isChallenge,
                height: 327.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 82.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Item(
                    imagePath: _getItemInfo(
                      TrackingOption.distance,
                      isChallenge: isChallenge,
                    ).iconPath,
                    title: _getItemInfo(
                      TrackingOption.distance,
                      isChallenge: isChallenge,
                    ).title,
                    value: numberFormat.format(trackingDistanceInKm),
                    unit: _getItemInfo(
                      TrackingOption.distance,
                      isChallenge: isChallenge,
                    ).unit,
                  ),
                  _Item(
                    imagePath: _getItemInfo(
                      TrackingOption.duration,
                      isChallenge: isChallenge,
                    ).iconPath,
                    title: _getItemInfo(
                      TrackingOption.duration,
                      isChallenge: isChallenge,
                    ).title,
                    value: Duration(
                      seconds: trackingDurationInSeconds,
                    ).toHoursMinutesSeconds(),
                    unit: _getItemInfo(
                      TrackingOption.duration,
                      isChallenge: isChallenge,
                    ).unit,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 82.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Item(
                    imagePath: _getItemInfo(
                      TrackingOption.avarageSpeed,
                      isChallenge: isChallenge,
                    ).iconPath,
                    title: _getItemInfo(
                      TrackingOption.avarageSpeed,
                      isChallenge: isChallenge,
                    ).title,
                    value: numberFormat.format(trackingAvarageSpeed),
                    unit: _getItemInfo(
                      TrackingOption.avarageSpeed,
                      isChallenge: isChallenge,
                    ).unit,
                  ),
                  _Item(
                    imagePath: _getItemInfo(
                      TrackingOption.calorie,
                      isChallenge: isChallenge,
                    ).iconPath,
                    title: _getItemInfo(
                      TrackingOption.calorie,
                      isChallenge: isChallenge,
                    ).title,
                    value: trackingCalorie.toString(),
                    unit: _getItemInfo(
                      TrackingOption.calorie,
                      isChallenge: isChallenge,
                    ).unit,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 82.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Item(
                    imagePath: _getItemInfo(
                      TrackingOption.steps,
                      isChallenge: isChallenge,
                    ).iconPath,
                    title: _getItemInfo(
                      TrackingOption.steps,
                      isChallenge: isChallenge,
                    ).title,
                    value: trackingSteps.toString(),
                    unit: _getItemInfo(
                      TrackingOption.steps,
                      isChallenge: isChallenge,
                    ).unit,
                  ),
                  _Item(
                    imagePath: _getItemInfo(
                      TrackingOption.maxSpeed,
                      isChallenge: isChallenge,
                    ).iconPath,
                    title: _getItemInfo(
                      TrackingOption.maxSpeed,
                      isChallenge: isChallenge,
                    ).title,
                    value: numberFormat.format(trackingMaxSpeed),
                    unit: _getItemInfo(
                      TrackingOption.maxSpeed,
                      isChallenge: isChallenge,
                    ).unit,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Text(
              'Velocità (km/h)',
              style: textTheme.caption,
            ),
            Chart(
              type: ChartType.speed,
              chartData: widget.listTrackingPosition
                  .map(
                    (position) => ChartData(
                      DateTime.fromMillisecondsSinceEpoch(
                        position.time.toInt(),
                      ),
                      position.speed.meterPerSecondToKmPerHour(),
                    ),
                  )
                  .toList(),
              scaleType: ChartScaleType.time,
            ),
            const SizedBox(
              height: 30.0,
            ),
            Text(
              'Quota (m)',
              style: textTheme.caption,
            ),
            Chart(
              type: ChartType.altitude,
              chartData: widget.listTrackingPosition
                  .map(
                    (position) => ChartData(
                      DateTime.fromMillisecondsSinceEpoch(
                        position.time.toInt(),
                      ),
                      position.altitude,
                    ),
                  )
                  .toList(),
              scaleType: ChartScaleType.time,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 84.0,
        decoration: BoxDecoration(
          color: colorScheme.background,
          boxShadow: const [
            BoxShadow(
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 50.0,
              child: FittedBox(
                child: FloatingActionButton.extended(
                  extendedPadding: const EdgeInsets.all(13.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  backgroundColor: colorSchemeExtension.success,
                  onPressed: widget.saveTracking,
                  label: Text(
                    'Salva'.toUpperCase(),
                  ),
                  icon: const Icon(
                    Icons.save,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            SizedBox(
              height: 50.0,
              child: FittedBox(
                child: FloatingActionButton.extended(
                  extendedPadding: const EdgeInsets.all(13.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  backgroundColor: colorScheme.error,
                  onPressed: widget.removeTracking,
                  label: const Icon(
                    Icons.delete_forever,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  _ItemInfo _getItemInfo(
    TrackingOption trackingOption, {
    bool isChallenge = false,
  }) {
    String initialPath = 'assets/icons/';
    String endPath = isChallenge ? '_challenge.svg' : '.svg';
    switch (trackingOption) {
      case TrackingOption.distance:
        return _ItemInfo(
          iconPath: '${initialPath}distance$endPath',
          title: 'Distance',
          unit: 'km',
        );
      case TrackingOption.duration:
        return _ItemInfo(
          iconPath: '${initialPath}time$endPath',
          title: 'Durata',
        );
      case TrackingOption.avarageSpeed:
        return _ItemInfo(
          iconPath: '${initialPath}average_speed$endPath',
          title: 'Velocità media',
          unit: 'km/h',
        );
      case TrackingOption.calorie:
        return _ItemInfo(
          iconPath: '${initialPath}calorie$endPath',
          title: 'Calorie',
          unit: 'cal',
        );
      case TrackingOption.steps:
        return _ItemInfo(
          iconPath: '${initialPath}average_steps$endPath',
          title: 'Passo medio',
          unit: 'min/km',
        );
      case TrackingOption.maxSpeed:
        return _ItemInfo(
          iconPath: '${initialPath}max_speed$endPath',
          title: 'Velocità Max',
          unit: 'km/h',
        );
    }
  }
}

class _ItemInfo {
  final String iconPath;
  final String title;
  final String? unit;

  _ItemInfo({
    required this.iconPath,
    required this.title,
    this.unit = '',
  });
}

class _Item extends StatelessWidget {
  final String imagePath;
  final String title;
  final String value;
  final String? unit;
  const _Item({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.value,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    return SizedBox(
      width: 157.0,
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: SvgPicture.asset(
              imagePath,
              height: 37.0,
              width: 37.0,
            ),
            title: Text(
              title,
              style: textTheme.caption!.copyWith(
                fontWeight: FontWeight.w400,
                color: colorSchemeExtension.textSecondary,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            subtitle: Row(
              children: [
                Text(
                  value,
                  style: textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  width: 9.0,
                ),
                Text(
                  unit ?? '',
                  style: textTheme.caption!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: colorSchemeExtension.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 2,
            thickness: 2,
          )
        ],
      ),
    );
  }
}
