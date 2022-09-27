import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/chart_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/widget/alart_dialog.dart';
import 'package:cycletowork/src/widget/chart.dart';
import 'package:cycletowork/src/widget/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum TrackingOption {
  distance,
  duration,
  avarageSpeed,
  calorie,
  steps,
  maxSpeed,
}

class TrackingStopView extends StatefulWidget {
  final List<LocationData> listTrackingPosition;
  final UserActivity trackingUserActivity;
  final GestureTapCancelCallback saveTracking;
  final GestureTapCancelCallback removeTracking;

  const TrackingStopView({
    Key? key,
    required this.listTrackingPosition,
    required this.trackingUserActivity,
    required this.saveTracking,
    required this.removeTracking,
  }) : super(key: key);

  @override
  State<TrackingStopView> createState() => _TrackingStopViewState();
}

class _TrackingStopViewState extends State<TrackingStopView> {
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
    if (widget.listTrackingPosition.isEmpty) {
      return;
    }
    var firstPosition = widget.listTrackingPosition.first;
    final Locale appLocale = Localizations.localeOf(context);
    var result = await Gps.getCityName(
      firstPosition.latitude,
      firstPosition.longitude,
      localeIdentifier: appLocale.languageCode,
    );
    context.read<ViewModel>().setUserActivityCity(result);
    setState(() {
      city = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final measurementUnit = context.read<AppData>().measurementUnit;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final Locale appLocale = Localizations.localeOf(context);
    final numberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );
    final numberPaceFormat = NumberFormat(
      '##0',
      appLocale.languageCode,
    );

    final endTrackingDate = DateTime.fromMillisecondsSinceEpoch(
      widget.trackingUserActivity.stopTime,
    );
    final trackingDurationInSeconds = widget.trackingUserActivity.duration;
    final trackingCo2Kg = widget.trackingUserActivity.co2.gramToKg();
    final trackingCo2Pound = widget.trackingUserActivity.co2.gramToPound();
    final trackingCo2 = measurementUnit == AppMeasurementUnit.metric
        ? trackingCo2Kg
        : trackingCo2Pound;
    final trackingAvarageSpeedKmPerHour =
        widget.trackingUserActivity.averageSpeed.meterPerSecondToKmPerHour();
    final trackingAvarageSpeedMilePerHour =
        widget.trackingUserActivity.averageSpeed.meterPerSecondToMilePerHour();
    final trackingAvarageSpeed = measurementUnit == AppMeasurementUnit.metric
        ? trackingAvarageSpeedKmPerHour
        : trackingAvarageSpeedMilePerHour;
    final trackingMaxSpeedKmPerHour =
        widget.trackingUserActivity.maxSpeed.meterPerSecondToKmPerHour();
    final trackingMaxSpeedMilePerHour =
        widget.trackingUserActivity.maxSpeed.meterPerSecondToMilePerHour();
    final trackingMaxSpeed = measurementUnit == AppMeasurementUnit.metric
        ? trackingMaxSpeedKmPerHour
        : trackingMaxSpeedMilePerHour;
    final trackingCalorie = widget.trackingUserActivity.calorie;
    final trackingDistanceInKm =
        widget.trackingUserActivity.distance.meterToKm();
    final trackingDistanceInMile =
        widget.trackingUserActivity.distance.meterToMile();
    final trackingDistance = measurementUnit == AppMeasurementUnit.metric
        ? trackingDistanceInKm
        : trackingDistanceInMile;
    final trackingPace = trackingAvarageSpeed > 2 && trackingDistanceInKm > 0.1
        ? 60 / trackingAvarageSpeed
        : 0;
    final isChallenge =
        widget.trackingUserActivity.isChallenge == 1 ? true : false;
    final listLocationData = widget.listTrackingPosition;
    final imageData = widget.trackingUserActivity.imageData;
    final city = widget.trackingUserActivity.city;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0 * scale,
          vertical: 20.0 * scale,
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
            city ?? '',
            style: textTheme.bodyText1!.apply(
              color: colorSchemeExtension.textSecondary,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.all(10.0 * scale),
            decoration: BoxDecoration(
              color: colorSchemeExtension.info,
              borderRadius: BorderRadius.circular(10.0 * scale),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/icons/co2.svg',
                  height: 46.0 * scale,
                  width: 46.0 * scale,
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
                  '${measurementUnit == AppMeasurementUnit.metric ? 'Kg' : 'lb'} CO\u2082',
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
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: SizedBox(
              height: 327.0 * scale,
              child: listLocationData.isNotEmpty && imageData == null
                  ? AppMap(
                      key: _mapKey,
                      listTrackingPosition: listLocationData,
                      isChallenge: isChallenge,
                      initialLatitude: listLocationData.first.latitude,
                      initialLongitude: listLocationData.first.longitude,
                      isStatic: true,
                      canScroll: false,
                    )
                  : imageData != null
                      ? Image.memory(
                          imageData,
                          fit: BoxFit.fill,
                          height: 327.0 * scale,
                          width: 327.0 * scale,
                        )
                      : Image.asset(
                          'assets/images/preview_${isChallenge ? 'challenge_' : ''}tracking_details.png',
                          fit: BoxFit.cover,
                          height: 327.0 * scale,
                          width: 327.0 * scale,
                        ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 82.0 * scale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Item(
                  imagePath: _getItemInfo(
                    TrackingOption.distance,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).iconPath,
                  title: _getItemInfo(
                    TrackingOption.distance,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).title,
                  value: numberFormat.format(trackingDistance),
                  unit: _getItemInfo(
                    TrackingOption.distance,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).unit,
                ),
                _Item(
                  imagePath: _getItemInfo(
                    TrackingOption.duration,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).iconPath,
                  title: _getItemInfo(
                    TrackingOption.duration,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).title,
                  value: Duration(
                    seconds: trackingDurationInSeconds,
                  ).toHoursMinutesSeconds(),
                  unit: _getItemInfo(
                    TrackingOption.duration,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).unit,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 82.0 * scale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Item(
                  imagePath: _getItemInfo(
                    TrackingOption.avarageSpeed,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).iconPath,
                  title: _getItemInfo(
                    TrackingOption.avarageSpeed,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).title,
                  value: numberFormat.format(trackingAvarageSpeed),
                  unit: _getItemInfo(
                    TrackingOption.avarageSpeed,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).unit,
                ),
                _Item(
                  imagePath: _getItemInfo(
                    TrackingOption.calorie,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).iconPath,
                  title: _getItemInfo(
                    TrackingOption.calorie,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).title,
                  value: trackingCalorie.toString(),
                  unit: _getItemInfo(
                    TrackingOption.calorie,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).unit,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 82.0 * scale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Item(
                  imagePath: _getItemInfo(
                    TrackingOption.steps,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).iconPath,
                  title: _getItemInfo(
                    TrackingOption.steps,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).title,
                  value: numberPaceFormat.format(trackingPace),
                  unit: _getItemInfo(
                    TrackingOption.steps,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).unit,
                ),
                _Item(
                  imagePath: _getItemInfo(
                    TrackingOption.maxSpeed,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).iconPath,
                  title: _getItemInfo(
                    TrackingOption.maxSpeed,
                    measurementUnit,
                    isChallenge: isChallenge,
                  ).title,
                  value: numberFormat.format(trackingMaxSpeed),
                  unit: _getItemInfo(
                    TrackingOption.maxSpeed,
                    measurementUnit,
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
            'Velocità (${measurementUnit == AppMeasurementUnit.metric ? 'km/h' : 'mi/h'})',
            style: textTheme.caption,
          ),
          Chart(
            type: ChartType.speed,
            chartData: listLocationData
                .map(
                  (position) => ChartData(
                    DateTime.fromMillisecondsSinceEpoch(
                      position.time.toInt(),
                    ),
                    measurementUnit == AppMeasurementUnit.metric
                        ? position.speed.meterPerSecondToKmPerHour()
                        : position.speed.meterPerSecondToMilePerHour(),
                  ),
                )
                .toList(),
            scaleType: ChartScaleType.time,
          ),
          const SizedBox(
            height: 30.0,
          ),
          Text(
            'Quota (${measurementUnit == AppMeasurementUnit.metric ? 'm' : 'ft'})',
            style: textTheme.caption,
          ),
          Chart(
            type: ChartType.altitude,
            chartData: listLocationData
                .map(
                  (position) => ChartData(
                    DateTime.fromMillisecondsSinceEpoch(
                      position.time.toInt(),
                    ),
                    measurementUnit == AppMeasurementUnit.metric
                        ? position.altitude
                        : position.altitude.meterToFoot(),
                  ),
                )
                .toList(),
            scaleType: ChartScaleType.time,
          ),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 4,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        child: Container(
          height: 84.0 * scale,
          decoration: BoxDecoration(
            color: colorScheme.background,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                blurRadius: 8.0,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 50.0 * scale,
                child: FittedBox(
                  child: FloatingActionButton.extended(
                    extendedPadding: EdgeInsets.all(13.0 * scale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15 * scale),
                      ),
                    ),
                    backgroundColor: widget.listTrackingPosition.isNotEmpty &&
                            widget.listTrackingPosition.length > 1
                        ? colorSchemeExtension.success
                        : colorSchemeExtension.textDisabled,
                    onPressed: widget.listTrackingPosition.isNotEmpty &&
                            widget.listTrackingPosition.length > 1
                        ? () => widget.saveTracking()
                        : null,
                    label: Text(
                      'Salva'.toUpperCase(),
                    ),
                    icon: const Icon(
                      Icons.save,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20.0 * scale,
              ),
              SizedBox(
                height: 50.0 * scale,
                child: FittedBox(
                  child: FloatingActionButton.extended(
                    extendedPadding: EdgeInsets.all(13.0 * scale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15 * scale),
                      ),
                    ),
                    backgroundColor: colorScheme.error,
                    onPressed: () async {
                      var isConfirmed = await AppAlartDialog(
                        context: context,
                        title: 'Attenzione!',
                        subtitle: "Desideri davvero cancellare l'attività?",
                        body: '',
                        confirmLabel: 'Sì, desidero cancellare',
                        iscConfirmDestructiveAction: true,
                        barrierDismissible: true,
                      ).show();
                      if (isConfirmed == true) {
                        widget.removeTracking();
                      }
                    },
                    label: const Icon(
                      Icons.delete_forever,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 24.0 * scale,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ItemInfo _getItemInfo(
    TrackingOption trackingOption,
    AppMeasurementUnit measurementUnit, {
    bool isChallenge = false,
  }) {
    String initialPath = 'assets/icons/';
    String endPath = isChallenge ? '_challenge.svg' : '.svg';
    switch (trackingOption) {
      case TrackingOption.distance:
        return _ItemInfo(
          iconPath: '${initialPath}distance$endPath',
          title: 'Distance',
          unit: measurementUnit == AppMeasurementUnit.metric ? 'km' : 'mi',
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
          unit: measurementUnit == AppMeasurementUnit.metric ? 'km/h' : 'mi/h',
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
          unit: measurementUnit == AppMeasurementUnit.metric
              ? 'min/km'
              : 'min/mi',
        );
      case TrackingOption.maxSpeed:
        return _ItemInfo(
          iconPath: '${initialPath}max_speed$endPath',
          title: 'Velocità Max',
          unit: measurementUnit == AppMeasurementUnit.metric ? 'km/h' : 'mi/h',
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
    var scale = context.read<AppData>().scale;
    var textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    return SizedBox(
      width: 160.0 * scale,
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: SvgPicture.asset(
              imagePath,
              height: 30.0 * scale,
              width: 30.0 * scale,
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
                SizedBox(
                  width: 9.0 * scale,
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
