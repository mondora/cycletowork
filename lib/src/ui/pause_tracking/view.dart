import 'dart:io';

import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/widget/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:cycletowork/src/utility/convert.dart';

class PauseTrackingView extends StatelessWidget {
  final List<LocationData> listTrackingPosition;
  final UserActivity trackingUserActivity;
  final GestureTapCancelCallback? playTracking;
  final GestureTapCancelCallback? stopTracking;

  const PauseTrackingView({
    Key? key,
    required this.listTrackingPosition,
    required this.trackingUserActivity,
    required this.playTracking,
    required this.stopTracking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final Locale appLocale = Localizations.localeOf(context);
    final numberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );

    final trackingDurationInSeconds = trackingUserActivity.duration ?? 0;
    final trackingCo2 = (trackingUserActivity.co2 ?? 0).gramToKg();
    final trackingAvarageSpeed =
        (trackingUserActivity.averageSpeed ?? 0).meterPerSecondToKmPerHour();
    final trackingDistanceInKm =
        (trackingUserActivity.distance ?? 0).meterToKm();
    final isChallenge = trackingUserActivity.isChallenge == 1 ? true : false;

    return Scaffold(
      body: Stack(
        children: [
          SlidingUpPanel(
            backdropColor: Theme.of(context).colorScheme.background,
            maxHeight: 268.0,
            minHeight: 155.0,
            parallaxEnabled: true,
            parallaxOffset: 0.2,
            defaultPanelState: PanelState.OPEN,
            color: Theme.of(context).colorScheme.background,
            panelBuilder: (sc) => Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.drag_handle,
                      color: Colors.grey,
                    )
                  ],
                ),
                _SummeryCard(
                  time: Duration(
                    seconds: trackingDurationInSeconds,
                  ).toHoursMinutesSeconds(),
                  co2: numberFormat.format(trackingCo2),
                  distant: numberFormat.format(trackingDistanceInKm),
                  avarageSpeed: numberFormat.format(trackingAvarageSpeed),
                ),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            body: Container(
              margin: const EdgeInsets.only(bottom: 120.0),
              child: AppMap(
                type: AppMapType.static,
                listTrackingPosition: listTrackingPosition,
                isChallenge: isChallenge,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Theme.of(context).colorScheme.background,
              // color: Colors.blue,
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: stopTracking,
                        child: Icon(
                          Icons.stop,
                          color: colorSchemeExtension.textPrimary,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25.0,
                  ),
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: playTracking,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: colorSchemeExtension.textPrimary,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 35.0,
                  ),
                  SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: Colors.grey,
                        onPressed: null,
                        child: SvgPicture.asset(
                          'assets/icons/map.svg',
                          height: 32.0,
                          width: 27.0,
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
    // return Container(
    //   color: Colors.black,
    //   height: 120,
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     mainAxisSize: MainAxisSize.max,
    //     children: [
    //       Container(
    //         color: Colors.blue,
    //         child: Column(
    //           children: [
    //             Text('data'),
    //           ],
    //         ),
    //       ),
    //       Container(
    //         color: Colors.red,
    //         child: Column(
    //           children: [
    //             Text('data'),
    //           ],
    //         ),
    //       ),
    //       Container(
    //         color: Colors.green,
    //         child: Column(
    //           children: [
    //             Text('data'),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.0,
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
            top: 12.0,
            right: 24.0,
            left: 24.0,
          ),
          child: Divider(
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
    var textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
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
        const SizedBox(
          width: 18.0,
        ),
        Container(
          width: 135.0,
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
        const SizedBox(
          width: 50.0,
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
    var textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'CO2'.toUpperCase(),
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 18.0,
        ),
        SizedBox(
          width: 135.0,
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
                'Kg',
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 50.0,
        ),
      ],
    );
  }
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text(
  //         'CO2'.toUpperCase(),
  //         style: textTheme.caption!.apply(
  //           color: colorSchemeExtension.textSecondary,
  //         ),
  //       ),
  //       const SizedBox(
  //         width: 18.0,
  //       ),
  //       Text(
  //         co2,
  //         style: textTheme.headline6!.copyWith(
  //           color: colorSchemeExtension.info,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //       const SizedBox(
  //         width: 18.0,
  //       ),
  //       Text(
  //         'Kg',
  //         style: textTheme.caption!.apply(
  //           color: colorSchemeExtension.textSecondary,
  //         ),
  //       )
  //     ],
  //   );
  // }
}

class _DistanceTracking extends StatelessWidget {
  final String distance;
  const _DistanceTracking({
    Key? key,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
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
        const SizedBox(
          width: 18.0,
        ),
        Container(
          width: 135.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                distance,
                style: textTheme.headline6,
              ),
              Text(
                'km',
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 50.0,
        ),
      ],
    );
  }
  //   return Column(
  //     children: [
  //       Text(
  //         'DISTANZA'.toUpperCase(),
  //         style: textTheme.caption!.apply(
  //           color: colorSchemeExtension.textSecondary,
  //         ),
  //       ),
  //       Text(
  //         distance,
  //         style: textTheme.headline2!.copyWith(
  //           fontWeight: FontWeight.w700,
  //         ),
  //       ),
  //       Text(
  //         'km',
  //         style: textTheme.caption!.apply(
  //           color: colorSchemeExtension.textSecondary,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class _SpeedTracking extends StatelessWidget {
  final String avarageSpeed;
  const _SpeedTracking({
    Key? key,
    required this.avarageSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
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
        const SizedBox(
          width: 18.0,
        ),
        Container(
          width: 135.0,
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
                'km/h',
                style: textTheme.caption!.apply(
                  color: colorSchemeExtension.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 50.0,
        ),
      ],
    );
  }
  // return Row(
  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //   children: [
  //     Column(
  //       children: [
  //         Text(
  //           'VELOCITÀ'.toUpperCase(),
  //           style: textTheme.caption!.apply(
  //             color: colorSchemeExtension.textSecondary,
  //           ),
  //         ),
  //         Text(
  //           speed,
  //           style: textTheme.headline4,
  //         ),
  //         Text(
  //           'km/h',
  //           style: textTheme.caption!.apply(
  //             color: colorSchemeExtension.textSecondary,
  //           ),
  //         ),
  //       ],
  //     ),
  //     Column(
  //       children: [
  //         Text(
  //           'VELOCITÀ MEDIA'.toUpperCase(),
  //           style: textTheme.caption!.apply(
  //             color: colorSchemeExtension.textSecondary,
  //           ),
  //         ),
  //         Text(
  //           avarageSpeed,
  //           style: textTheme.headline4,
  //         ),
  //         Text(
  //           'km/h',
  //           style: textTheme.caption!.apply(
  //             color: colorSchemeExtension.textSecondary,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ],
  // );
  // }
}
