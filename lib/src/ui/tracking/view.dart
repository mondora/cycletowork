import 'dart:async';

import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:cycletowork/src/utility/convert.dart';

// class TrackingView2 extends StatefulWidget {
//   final int trackingDurationInSeconds;
//   const TrackingView2({
//     Key? key,
//     required this.trackingDurationInSeconds,
//   }) : super(key: key);

//   @override
//   State<TrackingView2> createState() => _TrackingViewState2();
// }

// class _TrackingViewState2 extends State<TrackingView2> {
//   String time = '00:00:00';

//   @override
//   void initState() {
//     super.initState();
//     // _startTimer();
//   }

//   // _startTimer() {
//   //   Timer.periodic(
//   //     const Duration(seconds: 1),
//   //     (Timer timer) {
//   //       var nowDate = DateTime.now().toLocal();
//   //       var duration = nowDate.difference(
//   //         widget.startTrackingDate,
//   //       );
//   //       setState(() {
//   //         time = duration.toHoursMinutesSeconds();
//   //       });
//   //     },
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final colorSchemeExtension =
//         Theme.of(context).extension<ColorSchemeExtension>()!;
//     return Scaffold(
//       body: Container(
//         margin: const EdgeInsets.only(
//           right: 24.0,
//           left: 24.0,
//           top: 30.0,
//         ),
//         child: ListView(
//           physics: const ScrollPhysics(),
//           shrinkWrap: true,
//           children: [
//             _TimeTracking(
//               time: time,
//             ),
//             const _Divider(),
//             _Co2Tracking(
//               co2: '0,00',
//             ),
//             const _Divider(),
//             _DistanceTracking(
//               distance: '0,00',
//             ),
//             const _Divider(),
//             _SpeedTracking(
//               avarageSpeed: '0,00',
//               speed: '0,00',
//             ),
//             const _Divider(),
//             const SizedBox(
//               height: 15,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 SizedBox(
//                   height: 80.0,
//                   width: 80.0,
//                   child: FittedBox(
//                     child: FloatingActionButton(
//                       onPressed: () {},
//                       child: Icon(
//                         Icons.pause,
//                         color: colorSchemeExtension.textPrimary,
//                         size: 26.0,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 35.0,
//                 ),
//                 SizedBox(
//                   height: 60.0,
//                   width: 60.0,
//                   child: FittedBox(
//                     child: FloatingActionButton(
//                       onPressed: () {},
//                       child: SvgPicture.asset(
//                         'assets/icons/map.svg',
//                         height: 32.0,
//                         width: 27.0,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 28.0,
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class TrackingView extends StatelessWidget {
  final UserActivity trackingUserActivity;
  final GestureTapCancelCallback? pauseTracking;
  final GestureTapCancelCallback? showMap;

  const TrackingView({
    Key? key,
    required this.trackingUserActivity,
    required this.pauseTracking,
    required this.showMap,
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
    final trackingMaxSpeed =
        (trackingUserActivity.maxSpeed ?? 0).meterPerSecondToKmPerHour();
    final trackingDistanceInKm =
        (trackingUserActivity.distance ?? 0).meterToKm();

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(
          right: 24.0,
          left: 24.0,
          top: 30.0,
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
              distance: numberFormat.format(trackingDistanceInKm),
            ),
            const _Divider(),
            _SpeedTracking(
              avarageSpeed: numberFormat.format(trackingAvarageSpeed),
              speed: numberFormat.format(trackingMaxSpeed),
            ),
            const _Divider(),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 80.0,
                  width: 80.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      onPressed: pauseTracking,
                      child: Icon(
                        Icons.pause,
                        color: colorSchemeExtension.textPrimary,
                        size: 26.0,
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
                      onPressed: showMap,
                      child: SvgPicture.asset(
                        'assets/icons/map.svg',
                        height: 32.0,
                        width: 27.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 28.0,
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
    return Column(
      children: const [
        SizedBox(
          height: 10.0,
        ),
        Divider(
          height: 1.0,
        ),
        SizedBox(
          height: 10.0,
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
    var textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    return Column(
      children: [
        Text(
          'CO2'.toUpperCase(),
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
          'Kg',
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
    var textTheme = Theme.of(context).textTheme;
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
          'km',
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
    var textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              'VELOCITÀ Massima'.toUpperCase(),
              style: textTheme.caption!.apply(
                color: colorSchemeExtension.textSecondary,
              ),
            ),
            Text(
              speed,
              style: textTheme.headline4,
            ),
            Text(
              'km/h',
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
              'km/h',
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