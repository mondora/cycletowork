import 'dart:async';

import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/utility/activity_recognition.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:cycletowork/src/utility/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

abstract class BaseWorkout {
  late ActivityType activityTypeTarget;
  late String userActivityId;
  late int durationInSecond;
  late int startDateInMilliSeconds;
  late int stopDateInMilliSeconds;
  late List<LocationData> listLocationData;
  late List<int> listPauseWorkoutDateInMilliSeconds;
  late List<int> listPlayAgainWorkoutDateInMilliSeconds;
  late List<LocationData> listLocationDataUnFiltered;
  late double distanceInMeter;
  late double speedInMeterPerSecond;
  late double averageSpeedInMeterPerSecond;
  late double maxSpeedInMeterPerSecond;
  late double co2InGram;
  late int minDistanceInMeter;
  late double minAccuracyInNegativeAccuracy;
  late double distanceAccuracyFactor;
  late double minDistanceFromLineInMeter;
  late double delayInSecondToCalculateAverageSpeed;
  late int calorie;
  late int steps;
  late bool isWakeLockEnabled;
  late int countdown;
  late void Function(int countdown) onTickEverySecond;
  late void Function(LocationData locationData) onLocationData;
  ActivityType? activityTypeDetected;
  ActivityConfidence? activityConfidenceDetected;
  bool _started = false;
  bool get started => _started;
  bool _startedAfterPaused = false;
  bool _isLastPositionWasNegativeAccuracy = false;
  bool _isAccuracyIncludeAbnormalMinValue = false;
  bool get isAccuracyIncludeAbnormalMinValue =>
      _isAccuracyIncludeAbnormalMinValue;
  double? _accuracyAbnormalMinValue;
  double? get accuracyAbnormalMinValue => _accuracyAbnormalMinValue;
  bool _isAccuracyIncludeAbnormalMaxValue = false;
  bool get isAccuracyIncludeAbnormalMaxValue =>
      _isAccuracyIncludeAbnormalMaxValue;
  double? _accuracyAbnormalMaxValue;
  double? get accuracyAbnormalMaxValue => _accuracyAbnormalMaxValue;
  bool _isRecivedLocation = false;
  bool get isRecivedLocation => _isRecivedLocation;

  Timer? _timer;
  StreamSubscription<LocationData>? _locationSubscription;
  StreamSubscription<ActivityRecognitionResult>? _activityStreamSubscription;

  Future<void> startWorkout(BuildContext context);
  Future<void> pauseWorkout();
  Future<void> playAgainWorkout();
  Future<void> stopWorkout();
  void setCountdown(int countdown);
  void addLocationData(LocationData locationData);
  void setActivityRecognition(
    ActivityRecognitionResult activityRecognitionResult,
  );

  int _getMinDistanceInMeterForactivityType(ActivityType activityTypeTarget) {
    switch (activityTypeTarget) {
      case ActivityType.inVehicle:
        return 20;
      case ActivityType.onBicycle:
        return 8;
      case ActivityType.running:
        return 5;
      case ActivityType.still:
        return 5;
      case ActivityType.walking:
        return 5;
      case ActivityType.unknown:
        return 10;
    }
  }
}

class Workout extends BaseWorkout {
  Workout(
    ActivityType activityTypeTarget,
    String userActivityId, {
    required Function(int countdown) onTickEverySecond,
    required Function(LocationData locationData) onLocationData,
    double distanceAccuracyFactor = 1.5,
    double minDistanceFromLineInMeter = 2.0,
    double delayInSecondToCalculateAverageSpeed = 10.0,
    bool isWakeLockEnabled = true,
    int countdown = 5,
    double minAccuracyInNegativeAccuracy = 30.0,
  }) {
    this.activityTypeTarget = activityTypeTarget;
    this.userActivityId = userActivityId;
    this.distanceAccuracyFactor = distanceAccuracyFactor;
    this.minDistanceFromLineInMeter = minDistanceFromLineInMeter;
    this.delayInSecondToCalculateAverageSpeed =
        delayInSecondToCalculateAverageSpeed;
    this.isWakeLockEnabled = isWakeLockEnabled;
    this.countdown = countdown;
    this.onTickEverySecond = onTickEverySecond;
    this.onLocationData = onLocationData;
    this.minAccuracyInNegativeAccuracy = minAccuracyInNegativeAccuracy;
    durationInSecond = 0;
    startDateInMilliSeconds = 0;
    stopDateInMilliSeconds = 0;
    listLocationData = [];
    listLocationDataUnFiltered = [];
    listPauseWorkoutDateInMilliSeconds = [];
    listPlayAgainWorkoutDateInMilliSeconds = [];
    distanceInMeter = 0;
    speedInMeterPerSecond = 0;
    averageSpeedInMeterPerSecond = 0;
    maxSpeedInMeterPerSecond = 0;
    co2InGram = 0;
    calorie = 0;
    steps = 0;
    minDistanceInMeter =
        _getMinDistanceInMeterForactivityType(activityTypeTarget);
  }

  @override
  void addLocationData(LocationData locationData) {
    debugPrint(locationData.toJson().toString());
    _isRecivedLocation = true;
    if (!started) {
      return;
    }

    if (countdown != 0) {
      return;
    }

    listLocationDataUnFiltered.add(locationData);

    var accuracy = locationData.accuracy;

    if (_accuracyAbnormalMinValue != null) {
      _accuracyAbnormalMinValue = _accuracyAbnormalMinValue! > accuracy
          ? accuracy
          : _accuracyAbnormalMinValue;
    } else {
      _accuracyAbnormalMinValue = accuracy;
    }

    if (_accuracyAbnormalMaxValue != null) {
      _accuracyAbnormalMaxValue = _accuracyAbnormalMaxValue! < accuracy
          ? accuracy
          : _accuracyAbnormalMaxValue;
    } else {
      _accuracyAbnormalMaxValue = accuracy;
    }

    if (accuracy <= 0) {
      _isAccuracyIncludeAbnormalMinValue = true;
    }

    if (accuracy > 100) {
      _isAccuracyIncludeAbnormalMaxValue = true;
    }

    try {
      onLocationData(locationData);
    } catch (e) {
      Logger.error(e);
    }

    if (listLocationData.isEmpty || _startedAfterPaused) {
      if (_startedAfterPaused) {
        _startedAfterPaused = false;
      }
      listLocationData.add(locationData);
      return;
    }

    if (accuracy <= 0.0) {
      if (_isLastPositionWasNegativeAccuracy) {
        accuracy = minAccuracyInNegativeAccuracy;
      } else {
        _isLastPositionWasNegativeAccuracy = true;
        return;
      }
    } else {
      _isLastPositionWasNegativeAccuracy = false;
    }

    final lastPosition = listLocationData.last;
    final newDistanceInMeter = LocationData.calculateDistanceInMeter(
      latitude1: lastPosition.latitude,
      longitude1: lastPosition.longitude,
      latitude2: locationData.latitude,
      longitude2: locationData.longitude,
    ).abs();

    if (locationData.speed <= 0) {
      final durationLastLocationInSecond =
          (locationData.time - lastPosition.time) / 1000;
      final newSpeed = durationLastLocationInSecond != 0
          ? newDistanceInMeter / durationLastLocationInSecond
          : 0.0;
      speedInMeterPerSecond = newSpeed > 2 ? newSpeed : 0.0;
    } else {
      speedInMeterPerSecond = locationData.speed > 2 ? locationData.speed : 0.0;
    }

    if (newDistanceInMeter < accuracy) {
      return;
    }

    if (maxSpeedInMeterPerSecond < speedInMeterPerSecond) {
      maxSpeedInMeterPerSecond = speedInMeterPerSecond;
    }

    final checkMinDistanceAccuracy =
        newDistanceInMeter > (distanceAccuracyFactor * accuracy);

    if (!checkMinDistanceAccuracy) {
      return;
    }

    final checkMinDistance = newDistanceInMeter >
        (minDistanceInMeter *
            (activityTypeDetected == null ? distanceAccuracyFactor : 1.0));
    final checkActivityTypeIsStill = activityTypeDetected != null &&
        activityTypeDetected == ActivityType.still &&
        newDistanceInMeter < (2 * accuracy);

    if (!checkMinDistance || checkActivityTypeIsStill) {
      return;
    }

    distanceInMeter += newDistanceInMeter;
    co2InGram += newDistanceInMeter.distanceInMeterToCo2g();

    steps += newDistanceInMeter.distanceInMeterToSteps().toInt();

    calorie = distanceInMeter.toCalorieFromDistanceInMeter();
    if (listLocationData.length < 2) {
      listLocationData.add(locationData);
    } else {
      var point = lastPosition;
      var endPont = locationData;
      var startPoint = listLocationData[listLocationData.length - 2];
      var distance = LocationData.distanceToLine(point, startPoint, endPont);
      if (distance >= minDistanceFromLineInMeter) {
        listLocationData.add(locationData);
      } else {
        listLocationData[listLocationData.length - 1] = locationData;
      }
    }

    if (durationInSecond > delayInSecondToCalculateAverageSpeed) {
      averageSpeedInMeterPerSecond = distanceInMeter / durationInSecond;
    }
  }

  @override
  Future<void> startWorkout(BuildContext context) async {
    startDateInMilliSeconds = DateTime.now().toLocal().millisecondsSinceEpoch;
    _started = true;
    final date = DateTime.now().toLocal();
    await Gps.setNotificaion(
      title: date.toDayInterval(context),
      subtitle: date.toStartTime(context),
    );
    await Gps.setSettings(
      smallestDisplacement: minDistanceInMeter,
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        onTickEverySecond(countdown);
        if (countdown != 0) {
          countdown--;
        } else {
          if (started) {
            durationInSecond++;
            if (listPlayAgainWorkoutDateInMilliSeconds.isEmpty) {
              final now = DateTime.now().toLocal().millisecondsSinceEpoch;
              listPlayAgainWorkoutDateInMilliSeconds.add(now);
            }
          }

          if (listLocationDataUnFiltered.isNotEmpty) {
            final lastPositionTime = listLocationDataUnFiltered.last.time;
            final lastPositionDateTime =
                DateTime.fromMillisecondsSinceEpoch(lastPositionTime);
            final isAfter4Seconds = DateTime.now().isAfter(
              lastPositionDateTime.add(
                const Duration(milliseconds: 5000),
              ),
            );
            if (isAfter4Seconds) {
              speedInMeterPerSecond = 0.0;
            }
          }
        }
      },
    );

    _locationSubscription =
        Gps.startListenOnBackground().handleError((dynamic e) async {
      if (e is PlatformException) {
        Logger.error(e);
      }
    }).listen((LocationData locationData) {
      locationData.userActivityId = userActivityId;
      locationData.locationDataId = const Uuid().v4();
      addLocationData(locationData);
    });

    try {
      _activityStreamSubscription =
          ActivityRecognition.activityStream().handleError((dynamic e) {
        Logger.error(e);
        _activityStreamSubscription?.cancel();
      }).listen((activityRecognitionResult) {
        setActivityRecognition(activityRecognitionResult);
      });
    } catch (_) {}

    if (isWakeLockEnabled) {
      await WakeLock.enable();
    }
  }

  @override
  Future<void> pauseWorkout() async {
    _started = false;
    speedInMeterPerSecond = 0.0;
    final now = DateTime.now().toLocal().millisecondsSinceEpoch;
    listPauseWorkoutDateInMilliSeconds.add(now);
  }

  @override
  Future<void> playAgainWorkout() async {
    _started = true;
    _startedAfterPaused = true;
    final now = DateTime.now().toLocal().millisecondsSinceEpoch;
    listPlayAgainWorkoutDateInMilliSeconds.add(now);
  }

  @override
  Future<void> stopWorkout() async {
    _started = false;
    speedInMeterPerSecond = 0.0;
    stopDateInMilliSeconds = DateTime.now().toLocal().millisecondsSinceEpoch;

    var duration = 0;
    for (var i = 0; i < listPauseWorkoutDateInMilliSeconds.length; i++) {
      duration += listPauseWorkoutDateInMilliSeconds[i] -
          listPlayAgainWorkoutDateInMilliSeconds[i];
    }
    durationInSecond = duration ~/ 1000;

    _timer?.cancel();
    await _activityStreamSubscription?.cancel();
    await _locationSubscription?.cancel();
    if (isWakeLockEnabled) {
      await WakeLock.disable();
    }
  }

  @override
  void setActivityRecognition(
    ActivityRecognitionResult activityRecognitionResult,
  ) {
    debugPrint('activity.type: ${activityRecognitionResult.activityType}');
    debugPrint(
        'activity.confidence: ${activityRecognitionResult.activityConfidence}');
    activityTypeDetected = activityRecognitionResult.activityType;
    activityConfidenceDetected = activityRecognitionResult.activityConfidence;
  }

  @override
  void setCountdown(int countdown) {
    if (this.countdown != 0) {
      this.countdown = countdown;
    }
  }
}
