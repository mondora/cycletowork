import 'dart:async';

import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/utility/activity_recognition.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:cycletowork/src/utility/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BaseWorkout {
  late ActivityType activityTypeTarget;
  late int durationInSecond;
  late int startDateInMilliSeconds;
  late int stopDateInMilliSeconds;
  late List<LocationData> listLocationData;
  late double distanceInMeter;
  late double speedInMeterPerSecond;
  late double averageSpeedInMeterPerSecond;
  late double maxSpeedInMeterPerSecond;
  late double co2InGram;
  late double minDistanceInMeter;
  // late double minAccuracyInMeter;
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

  Timer? _timer;
  StreamSubscription<LocationData>? _locationSubscription;
  StreamSubscription<ActivityRecognitionResult>? _activityStreamSubscription;

  Future<void> startWorkout(
    BuildContext context,
    String permissionRequestMessage,
  );
  Future<void> pauseWorkout();
  Future<void> playAgainWorkout();
  Future<void> stopWorkout();
  void setCountdown(int countdown);
  void addLocationData(LocationData locationData);
  void setActivityRecognition(
    ActivityRecognitionResult activityRecognitionResult,
  );

  double _getMinDistanceInMeterForactivityType(
      ActivityType activityTypeTarget) {
    switch (activityTypeTarget) {
      case ActivityType.inVehicle:
        return 20.0;
      case ActivityType.onBicycle:
        return 8.0;
      case ActivityType.running:
        return 5.0;
      case ActivityType.still:
        return 0.0;
      case ActivityType.walking:
        return 5.0;
      case ActivityType.unknown:
        return 0.0;
    }
  }

  // double _getMinAccuracyInMeterForactivityType(
  //     ActivityType activityTypeTarget) {
  //   switch (activityTypeTarget) {
  //     case ActivityType.inVehicle:
  //       return 150.0;
  //     case ActivityType.onBicycle:
  //       return 100.0;
  //     case ActivityType.running:
  //       return 10.0;
  //     case ActivityType.still:
  //       return 10.0;
  //     case ActivityType.walking:
  //       return 10.0;
  //     case ActivityType.unknown:
  //       return 10.0;
  //   }
  // }
}

class Workout extends BaseWorkout {
  Workout(
    ActivityType activityTypeTarget, {
    required Function(int countdown) onTickEverySecond,
    required Function(LocationData locationData) onLocationData,
    double distanceAccuracyFactor = 1.5,
    double minDistanceFromLineInMeter = 2.0,
    double delayInSecondToCalculateAverageSpeed = 10.0,
    bool isWakeLockEnabled = true,
    int countdown = 5,
  }) {
    this.activityTypeTarget = activityTypeTarget;
    this.distanceAccuracyFactor = distanceAccuracyFactor;
    this.minDistanceFromLineInMeter = minDistanceFromLineInMeter;
    this.delayInSecondToCalculateAverageSpeed =
        delayInSecondToCalculateAverageSpeed;
    this.isWakeLockEnabled = isWakeLockEnabled;
    this.countdown = countdown;
    this.onTickEverySecond = onTickEverySecond;
    this.onLocationData = onLocationData;
    durationInSecond = 0;
    startDateInMilliSeconds = 0;
    stopDateInMilliSeconds = 0;
    listLocationData = [];
    distanceInMeter = 0;
    speedInMeterPerSecond = 0;
    averageSpeedInMeterPerSecond = 0;
    maxSpeedInMeterPerSecond = 0;
    co2InGram = 0;
    calorie = 0;
    steps = 0;
    minDistanceInMeter =
        _getMinDistanceInMeterForactivityType(activityTypeTarget);
    // minAccuracyInMeter =
    //     _getMinAccuracyInMeterForactivityType(activityTypeTarget);
  }

  @override
  void addLocationData(LocationData locationData) {
    if (!started) {
      return;
    }

    if (countdown != 0) {
      return;
    }

    onLocationData(locationData);

    // if (locationData.accuracy < 0) {
    //   return;
    // }

    // if (locationData.accuracy > minAccuracyInMeter) {
    //   return;
    // }

    if (listLocationData.isEmpty || _startedAfterPaused) {
      if (_startedAfterPaused) {
        _startedAfterPaused = false;
      }
      locationData.speed = 0.0;
      listLocationData.add(locationData);
      return;
    }

    final lastPosition = listLocationData.last;
    final newDistanceInMeter = LocationData.calculateDistanceInMeter(
      latitude1: lastPosition.latitude,
      longitude1: lastPosition.longitude,
      latitude2: locationData.latitude,
      longitude2: locationData.longitude,
    ).abs();

    if (newDistanceInMeter < locationData.accuracy) {
      return;
    }

    final durationLastLocationInSecond =
        locationData.time.millisecondsSinceEpochToSeconde() -
            lastPosition.time.millisecondsSinceEpochToSeconde();
    var newSpeedInMeterPerSecond = durationLastLocationInSecond != 0
        ? newDistanceInMeter / durationLastLocationInSecond
        : 0.0;
    newSpeedInMeterPerSecond =
        newSpeedInMeterPerSecond > 2.7 ? newSpeedInMeterPerSecond : 0;

    if (maxSpeedInMeterPerSecond < newSpeedInMeterPerSecond) {
      maxSpeedInMeterPerSecond = newSpeedInMeterPerSecond;
    }

    final checkMinDistanceAccuracy =
        newDistanceInMeter > (distanceAccuracyFactor * locationData.accuracy);
    // final checkOnBicycleHighConfidence = activityTypeDetected != null &&
    //     activityTypeDetected == ActivityType.onBicycle &&
    //     activityConfidenceDetected != null &&
    //     activityConfidenceDetected == ActivityConfidence.high;

    if (!checkMinDistanceAccuracy) {
      lastPosition.speed = newSpeedInMeterPerSecond;
      return;
    }

    final checkMinDistance = newDistanceInMeter >
        (minDistanceInMeter *
            (activityTypeDetected == null ? distanceAccuracyFactor : 1.0));
    final checkActivityTypeIsStill = activityTypeDetected != null &&
        activityTypeDetected == ActivityType.still;

    if (!checkMinDistance || checkActivityTypeIsStill) {
      lastPosition.speed = newSpeedInMeterPerSecond;
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
  Future<void> startWorkout(
    BuildContext context,
    String permissionRequestMessage,
  ) async {
    startDateInMilliSeconds = DateTime.now().toLocal().millisecondsSinceEpoch;
    _started = true;
    // _timer?.cancel();

    await Gps.setSettings(
      smallestDisplacement: minDistanceInMeter,
      permissionRequestMessage: permissionRequestMessage,
    );
    var date = DateTime.now().toLocal();
    await Gps.setNotificaion(
      title: date.toDayInterval(context),
      subtitle: date.toStartTime(context),
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
          }
        }
      },
    );

    _locationSubscription =
        Gps.startListenOnBackground().handleError((dynamic e) async {
      if (e is PlatformException) {
        Logger.error(e);
        await stopWorkout();
        // throw (e);
      }
    }).listen((LocationData locationData) {
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
  }

  @override
  Future<void> playAgainWorkout() async {
    _started = true;
    _startedAfterPaused = true;
  }

  @override
  Future<void> stopWorkout() async {
    _started = false;
    stopDateInMilliSeconds = DateTime.now().toLocal().millisecondsSinceEpoch;
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
