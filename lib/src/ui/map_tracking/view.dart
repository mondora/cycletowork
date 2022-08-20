import 'dart:async';

import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/widget/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ShowMapTracking extends StatefulWidget {
  final List<LocationData> listTrackingPosition;
  final LocationData currentPosition;
  final UserActivity trackingUserActivity;
  final GestureTapCancelCallback? pauseTracking;
  final GestureTapCancelCallback? hiddenMap;

  const ShowMapTracking({
    Key? key,
    required this.listTrackingPosition,
    required this.trackingUserActivity,
    required this.currentPosition,
    this.pauseTracking,
    this.hiddenMap,
  }) : super(key: key);

  @override
  State<ShowMapTracking> createState() => _ShowMapTrackingState();
}

class _ShowMapTrackingState extends State<ShowMapTracking> {
  final GlobalKey<AppMapState> _mapKey = GlobalKey();
  Timer? _timer;
  int pathCounter = 0;
  LocationData? lastCurrentPosition;

  @override
  void dispose() {
    _mapKey.currentState?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('render ShowMapTracking *****');

    var currentPosition = widget.currentPosition;
    var firstPosition = widget.listTrackingPosition.first;
    var lastPosition = widget.listTrackingPosition.last;
    final trackingCo2 = (widget.trackingUserActivity.co2 ?? 0).gramToKg();
    final isChallenge =
        widget.trackingUserActivity.isChallenge == 1 ? true : false;

    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final Locale appLocale = Localizations.localeOf(context);
    final numberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );
    var listTrackingPosition =
        widget.listTrackingPosition.map((e) => e).toList();
    listTrackingPosition.add(currentPosition);

    Timer(const Duration(seconds: 1), () async {
      _mapKey.currentState?.setPath(
        listTrackingPosition,
      );

      _mapKey.currentState?.setMarker(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      await _mapKey.currentState?.changeCameraFromPath(
        firstPosition.latitude,
        firstPosition.longitude,
        lastPosition.latitude,
        lastPosition.longitude,
      );

      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          var currentPosition = widget.currentPosition;

          if (lastCurrentPosition != null) {
            var distance = LocationData.calculateDistanceInMeter(
              latitude1: lastCurrentPosition!.latitude,
              longitude1: lastCurrentPosition!.longitude,
              latitude2: currentPosition.latitude,
              longitude2: currentPosition.longitude,
            );
            if (distance > 3) {
              _mapKey.currentState?.addPath(
                lastCurrentPosition!,
                currentPosition,
              );
              _mapKey.currentState?.setMarker(
                currentPosition.latitude,
                currentPosition.longitude,
              );
              lastCurrentPosition = currentPosition;
            }
          } else {
            lastCurrentPosition = currentPosition;
          }
        },
      );
    });

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: AppMap(
              key: _mapKey,
              type: AppMapType.dynamic,
              listTrackingPosition: listTrackingPosition,
              isChallenge: isChallenge,
              initialLatitude: currentPosition.latitude,
              initialLongitude: currentPosition.longitude,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  _Co2Tracking(
                    co2: numberFormat.format(trackingCo2),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 1.0,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 80.0,
                        width: 80.0,
                        child: FittedBox(
                          child: FloatingActionButton(
                            onPressed: widget.pauseTracking,
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
                            onPressed: widget.hiddenMap,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/icons/map.svg',
                                    height: 32.0,
                                    width: 27.0,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: RotationTransition(
                                    turns:
                                        const AlwaysStoppedAnimation(45 / 360),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colorSchemeExtension.textPrimary,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      height: 5.0,
                                      width: 47.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 28.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'CO2'.toUpperCase(),
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        ),
        const SizedBox(
          width: 18.0,
        ),
        Text(
          co2,
          style: textTheme.headline4!.copyWith(
            color: colorSchemeExtension.info,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          width: 18.0,
        ),
        Text(
          'Kg',
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        ),
      ],
    );
  }
}
