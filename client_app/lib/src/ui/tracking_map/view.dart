import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/workout.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/widget/map.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TrackingMapView extends StatefulWidget {
  final Workout workout;
  final bool isChallenge;
  final GestureTapCancelCallback? pauseTracking;
  final GestureTapCancelCallback? hiddenMap;

  const TrackingMapView({
    Key? key,
    required this.workout,
    required this.isChallenge,
    this.pauseTracking,
    this.hiddenMap,
  }) : super(key: key);

  @override
  State<TrackingMapView> createState() => _TrackingMapViewState();
}

class _TrackingMapViewState extends State<TrackingMapView> {
  final GlobalKey<AppMapState> _mapKey = GlobalKey();
  LocationData? lastPositionPassed;
  bool isCreatedMap = false;

  @override
  void dispose() {
    _mapKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  onCreatedMap() {
    isCreatedMap = true;
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final measurementUnit = context.read<AppData>().measurementUnit;

    if (widget.workout.listLocationData.isEmpty) {
      return const Scaffold(
        body: Center(
          child: AppProgressIndicator(),
        ),
      );
    }

    var lastPosition = widget.workout.listLocationData.last;
    final trackingCo2Kg = widget.workout.co2InGram.gramToKg();
    final trackingCo2Pound = widget.workout.co2InGram.gramToPound();
    final trackingCo2 = measurementUnit == AppMeasurementUnit.metric
        ? trackingCo2Kg
        : trackingCo2Pound;
    final isChallenge = widget.isChallenge;
    final Locale appLocale = Localizations.localeOf(context);
    final numberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );

    if (isCreatedMap) {
      Timer(const Duration(milliseconds: 200), () async {
        if (lastPositionPassed == null ||
            lastPositionPassed!.latitude != lastPosition.latitude ||
            lastPositionPassed!.longitude != lastPosition.longitude) {
          lastPositionPassed = LocationData(
            latitude: lastPosition.latitude,
            longitude: lastPosition.longitude,
            accuracy: 0,
            altitude: 0,
            speed: 0,
            speedAccuracy: 0,
            time: 0,
            bearing: 0,
          );

          _mapKey.currentState?.setPath(
            widget.workout.listLocationData,
          );

          _mapKey.currentState?.setStartAndCurrentMarker(
            widget.workout.listLocationData.first.latitude,
            widget.workout.listLocationData.first.longitude,
            lastPosition.latitude,
            lastPosition.longitude,
          );

          await _mapKey.currentState?.changeCamera(
            lastPosition.latitude,
            lastPosition.longitude,
            bearing: lastPosition.bearing,
            zoom: 17.0,
          );
        }
      });
    }

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
              maxHeight: 268.0 * scale,
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
                  SizedBox(
                    height: 20 * scale,
                  ),
                  _Co2Tracking(
                    co2: numberFormat.format(trackingCo2),
                  ),
                  SizedBox(
                    height: 20 * scale,
                  ),
                  const Divider(
                    height: 1.0,
                  ),
                  SizedBox(
                    height: 17 * scale,
                  ),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              body: Container(
                margin: EdgeInsets.only(bottom: 120.0 * scale),
                child: AppMap(
                  key: _mapKey,
                  listTrackingPosition: widget.workout.listLocationData,
                  isChallenge: isChallenge,
                  initialLatitude: lastPosition.latitude,
                  initialLongitude: lastPosition.longitude,
                  onCreatedMap: onCreatedMap,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120.0 * scale,
              color: Theme.of(context).colorScheme.background,
              padding: EdgeInsets.symmetric(
                horizontal: 24.0 * scale,
                vertical: 20.0 * scale,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 80.0 * scale,
                      width: 80.0 * scale,
                      child: FittedBox(
                        child: FloatingActionButton(
                          onPressed: widget.pauseTracking,
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
                      margin: EdgeInsets.only(
                        top: 10.0 * scale,
                        right: 50.0 * scale,
                      ),
                      child: SizedBox(
                        height: 60.0 * scale,
                        width: 60.0 * scale,
                        child: FittedBox(
                          child: FloatingActionButton(
                            onPressed: widget.hiddenMap,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/icons/map.svg',
                                    height: 32.0 * scale,
                                    width: 27.0 * scale,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: RotationTransition(
                                    turns:
                                        const AlwaysStoppedAnimation(45 / 360),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8 * scale),
                                        ),
                                      ),
                                      height: 5.0 * scale,
                                      width: 47.0 * scale,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'CO\u2082'.toUpperCase(),
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        ),
        SizedBox(
          width: 18.0 * scale,
        ),
        Text(
          co2,
          style: textTheme.headline4!.copyWith(
            color: colorSchemeExtension.info,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          width: 18.0 * scale,
        ),
        Text(
          measurementUnit == AppMeasurementUnit.metric ? 'Kg' : 'lb',
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        ),
      ],
    );
  }
}
