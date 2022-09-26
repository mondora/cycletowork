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
    var scale = context.read<AppData>().scale;

    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
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
    final trackingCo2 = widget.trackingUserActivity.co2.gramToKg();
    final trackingAvarageSpeed =
        widget.trackingUserActivity.averageSpeed.meterPerSecondToKmPerHour();
    final trackingMaxSpeed =
        widget.trackingUserActivity.maxSpeed.meterPerSecondToKmPerHour();
    final trackingCalorie = widget.trackingUserActivity.calorie;
    final trackingDistanceInKm =
        widget.trackingUserActivity.distance.meterToKm();
    final trackingPace = trackingAvarageSpeed > 2 && trackingDistanceInKm > 0.1
        ? 60 / trackingAvarageSpeed
        : 0;
    final isChallenge =
        widget.trackingUserActivity.isChallenge == 1 ? true : false;

    final initialLatitude = widget.listTrackingPosition.isNotEmpty
        ? widget.listTrackingPosition.first.latitude
        : context.read<ViewModel>().uiState.currentPosition!.latitude;
    final initialLongitude = widget.listTrackingPosition.isNotEmpty
        ? widget.listTrackingPosition.first.longitude
        : context.read<ViewModel>().uiState.currentPosition!.longitude;

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
            city,
            style: textTheme.bodyText1!.apply(
              color: colorSchemeExtension.textSecondary,
            ),
          ),
          SizedBox(
            height: 10.0 * scale,
          ),
          Container(
            padding: EdgeInsets.all(10.0 * scale),
            decoration: BoxDecoration(
              color: colorSchemeExtension.info,
              borderRadius: BorderRadius.circular(10.0),
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
                SizedBox(
                  width: 10 * scale,
                ),
                Text(
                  numberFormat.format(trackingCo2),
                  style: textTheme.headline4!.copyWith(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 10 * scale,
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
          SizedBox(
            height: 10.0 * scale,
          ),
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            child: SizedBox(
              height: 327.0 * scale,
              child: AppMap(
                listTrackingPosition: widget.listTrackingPosition,
                isChallenge: isChallenge,
                initialLatitude: initialLatitude,
                initialLongitude: initialLongitude,
                isStatic: widget.listTrackingPosition.isNotEmpty ? true : false,
                padding: 100.0,
                onSnapshot: (value) {
                  context.read<ViewModel>().setUserActivityImageData(value);
                },
                canScroll: false,
              ),
            ),
          ),
          SizedBox(
            height: 20.0 * scale,
          ),
          SizedBox(
            height: 82.0 * scale,
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
            height: 82.0 * scale,
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
            height: 82.0 * scale,
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
                  value: numberPaceFormat.format(trackingPace),
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
          SizedBox(
            height: 25.0 * scale,
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
          SizedBox(
            height: 30.0 * scale,
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