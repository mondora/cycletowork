import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/chart_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/details_tracking/ui_state.dart';
import 'package:cycletowork/src/ui/details_tracking/view_model.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/widget/chart.dart';
import 'package:cycletowork/src/widget/map.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailsTrackingView extends StatelessWidget {
  final UserActivity userActivity;
  const DetailsTrackingView({
    Key? key,
    required this.userActivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<AppMapState> _mapKey = GlobalKey();
    var scale = context.read<AppData>().scale;

    return ChangeNotifierProvider<ViewModel>(
      create: (_) => ViewModel.instance(userActivity),
      child: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
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
            '##0.00',
            appLocale.languageCode,
          );
          final userActivity = viewModel.uiState.userActivity!;
          final endTrackingDate = DateTime.fromMillisecondsSinceEpoch(
            userActivity.stopTime,
          );
          final trackingDurationInSeconds = userActivity.duration;
          final trackingCo2 = userActivity.co2.gramToKg();
          final trackingAvarageSpeed =
              userActivity.averageSpeed.meterPerSecondToKmPerHour();
          final trackingMaxSpeed =
              userActivity.maxSpeed.meterPerSecondToKmPerHour();
          final trackingCalorie = userActivity.calorie;
          final trackingDistanceInKm = userActivity.distance.meterToKm();
          final trackingPace =
              trackingAvarageSpeed > 2 && trackingDistanceInKm > 0.1
                  ? 60 / trackingAvarageSpeed
                  : 0;

          final isChallenge = userActivity.isChallenge == 1 ? true : false;
          final listLocationData = viewModel.uiState.listLocationData;
          final imageData = userActivity.imageData;
          final city = userActivity.city;

          if (viewModel.uiState.loading) {
            return const Scaffold(
              body: Center(
                child: AppProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                splashRadius: 25.0 * scale,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: colorScheme.onBackground,
                  size: 20 * scale,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SafeArea(
              child: ListView(
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
                              fit: BoxFit.fitWidth,
                              isChallenge: isChallenge,
                              height: 327.0 * scale,
                              initialLatitude: listLocationData.first.latitude,
                              initialLongitude:
                                  listLocationData.first.longitude,
                              isStatic: true,
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
                  const SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    'Velocità (km/h)',
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
                    chartData: listLocationData
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
          );
        },
      ),
    );
  }
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
                  width: 8.0 * scale,
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
