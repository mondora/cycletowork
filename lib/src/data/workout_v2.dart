import 'dart:async';

import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/utility/activity_recognition.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:cycletowork/src/utility/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BaseWorkoutV2 {
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
  late double minAccuracyInMeter;
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
  bool checkMaxAbsoluteAccuracy(LocationData locationData);
  void addLocationDataWithZeroSpeed(LocationData locationData);
  void skipLocationDataWithHighestAccuracy(LocationData locationData);
  void addLocationDatValid(LocationData locationData);
  double calculateSpeed(
    LocationData lastLocationData,
    LocationData newLocationData,
  );

  void setActivityRecognition(
    ActivityRecognitionResult activityRecognitionResult,
  );

  double _getMinDistanceInMeterForactivityType(
      ActivityType activityTypeTarget) {
    switch (activityTypeTarget) {
      case ActivityType.inVehicle:
        return 20.0;
      case ActivityType.onBicycle:
        return 6.0;
      case ActivityType.running:
        return 5.0;
      case ActivityType.still:
        return 5.0;
      case ActivityType.walking:
        return 5.0;
      case ActivityType.unknown:
        return 5.0;
    }
  }

  double _getMinAccuracyInMeterForactivityType(
      ActivityType activityTypeTarget) {
    switch (activityTypeTarget) {
      case ActivityType.inVehicle:
        return 200.0;
      case ActivityType.onBicycle:
        return 100.0;
      case ActivityType.running:
        return 20.0;
      case ActivityType.still:
        return 10.0;
      case ActivityType.walking:
        return 10.0;
      case ActivityType.unknown:
        return 10.0;
    }
  }
}

class WorkoutV2 extends BaseWorkoutV2 {
  WorkoutV2(
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
    minAccuracyInMeter =
        _getMinAccuracyInMeterForactivityType(activityTypeTarget);
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

    debugPrint('locationData.accuracy: ${locationData.accuracy}');

    final isMaxAbsoluteAccuracy = checkMaxAbsoluteAccuracy(locationData);
    if (!isMaxAbsoluteAccuracy) {
      return;
    }

    if (listLocationData.isEmpty) {
      addLocationDataWithZeroSpeed(locationData);
      return;
    }

    final lastPosition = listLocationData.last;
    debugPrint('lastPositionAccuracy: ${lastPosition.accuracy}');
    final newDistanceInMeter = LocationData.calculateDistanceInMeter(
      latitude1: lastPosition.latitude,
      longitude1: lastPosition.longitude,
      latitude2: locationData.latitude,
      longitude2: locationData.longitude,
    ).abs();
    debugPrint('newDistanceInMeter: $newDistanceInMeter');

    if (newDistanceInMeter < locationData.accuracy) {
      skipLocationDataWithHighestAccuracy(locationData);
      return;
    }

    final checkMinDistanceAccuracy =
        newDistanceInMeter > (distanceAccuracyFactor * locationData.accuracy);

    if (!checkMinDistanceAccuracy) {
      skipLocationDataWithHighestAccuracy(locationData);
      return;
    }

    final minDistanceInMeterToCheck = minDistanceInMeter *
        (activityTypeDetected == null ? distanceAccuracyFactor : 1.0);
    final checkMinDistance = newDistanceInMeter > minDistanceInMeterToCheck;

    final checkActivityTypeIsStill = activityTypeDetected != null &&
        activityTypeDetected == ActivityType.still;

    if (!checkMinDistance || checkActivityTypeIsStill) {
      skipLocationDataWithHighestAccuracy(locationData);
      return;
    }

    if (_startedAfterPaused) {
      _startedAfterPaused = false;
      addLocationDataWithZeroSpeed(locationData);
      return;
    }

    final newSpeedInMeterPerSecond = calculateSpeed(
      lastPosition,
      locationData,
    );

    if (maxSpeedInMeterPerSecond < newSpeedInMeterPerSecond) {
      maxSpeedInMeterPerSecond = newSpeedInMeterPerSecond;
    }

    addLocationDatValid(locationData);
  }

  @override
  Future<void> startWorkout(
    BuildContext context,
    String permissionRequestMessage,
  ) async {
    startDateInMilliSeconds = DateTime.now().toLocal().millisecondsSinceEpoch;
    _started = true;
    _timer?.cancel();
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

    _activityStreamSubscription =
        ActivityRecognition.activityStream().handleError((dynamic e) {
      Logger.error(e);
      _activityStreamSubscription?.cancel();
    }).listen((activityRecognitionResult) {
      setActivityRecognition(activityRecognitionResult);
    });

    _locationSubscription =
        Gps.startListenOnBackground().handleError((dynamic e) async {
      if (e is PlatformException) {
        await stopWorkout();
        throw (e);
      }
    }).listen((LocationData locationData) {
      addLocationData(locationData);
    });

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

  @override
  bool checkMaxAbsoluteAccuracy(LocationData locationData) {
    if (locationData.accuracy < 0) {
      return false;
    }

    if (locationData.accuracy > minAccuracyInMeter) {
      return false;
    }

    return true;
  }

  @override
  void addLocationDataWithZeroSpeed(
    LocationData locationData,
  ) {
    locationData.speed = 0.0;
    listLocationData.add(locationData);
  }

  @override
  void addLocationDatValid(LocationData locationData) {
    final lastPosition = listLocationData.last;
    final newDistanceInMeter = LocationData.calculateDistanceInMeter(
      latitude1: lastPosition.latitude,
      longitude1: lastPosition.longitude,
      latitude2: locationData.latitude,
      longitude2: locationData.longitude,
    ).abs();
    distanceInMeter += newDistanceInMeter;
    co2InGram = distanceInMeter.distanceInMeterToCo2g();

    steps = newDistanceInMeter.distanceInMeterToSteps().toInt();

    calorie = distanceInMeter.toCalorieFromDistanceInMeter();
    if (listLocationData.length < 2) {
      listLocationData.add(locationData);
    } else {
      final point = lastPosition;
      final endPont = locationData;
      final startPoint = listLocationData[listLocationData.length - 2];
      final distance = LocationData.distanceToLine(point, startPoint, endPont);
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
  void skipLocationDataWithHighestAccuracy(LocationData locationData) {
    final lastPosition = listLocationData.last;
    final newDistanceInMeter = LocationData.calculateDistanceInMeter(
      latitude1: lastPosition.latitude,
      longitude1: lastPosition.longitude,
      latitude2: locationData.latitude,
      longitude2: locationData.longitude,
    ).abs();

    if (lastPosition.accuracy > locationData.accuracy &&
        listLocationData.length > 1) {
      final prelastPosition = listLocationData[listLocationData.length - 2];

      final preDistanceInMeter = LocationData.calculateDistanceInMeter(
        latitude1: prelastPosition.latitude,
        longitude1: prelastPosition.longitude,
        latitude2: lastPosition.latitude,
        longitude2: lastPosition.longitude,
      ).abs();

      distanceInMeter =
          distanceInMeter - preDistanceInMeter + newDistanceInMeter;
      co2InGram = distanceInMeter.distanceInMeterToCo2g();

      steps = distanceInMeter.distanceInMeterToSteps().toInt();

      calorie = distanceInMeter.toCalorieFromDistanceInMeter();

      if (durationInSecond > delayInSecondToCalculateAverageSpeed) {
        averageSpeedInMeterPerSecond = distanceInMeter / durationInSecond;
      }

      final newSpeedInMeterPerSecond = calculateSpeed(
        prelastPosition,
        locationData,
      );
      locationData.speed = newSpeedInMeterPerSecond;

      if (maxSpeedInMeterPerSecond < newSpeedInMeterPerSecond) {
        maxSpeedInMeterPerSecond = newSpeedInMeterPerSecond;
      }

      listLocationData[listLocationData.length - 1] =
          LocationData.fromLocationData(locationData);

      return;
    } else {
      final newSpeedInMeterPerSecond = calculateSpeed(
        lastPosition,
        locationData,
      );
      lastPosition.speed = newSpeedInMeterPerSecond;
      return;
    }
  }

  @override
  double calculateSpeed(
    LocationData lastLocationData,
    LocationData newLocationData,
  ) {
    final durationLastLocationInSecond =
        newLocationData.time.millisecondsSinceEpochToSeconde() -
            lastLocationData.time.millisecondsSinceEpochToSeconde();

    final newDistanceInMeter = LocationData.calculateDistanceInMeter(
      latitude1: lastLocationData.latitude,
      longitude1: lastLocationData.longitude,
      latitude2: newLocationData.latitude,
      longitude2: newLocationData.longitude,
    ).abs();

    var newSpeedInMeterPerSecond = durationLastLocationInSecond != 0
        ? newDistanceInMeter / durationLastLocationInSecond
        : 0.0;
    return newSpeedInMeterPerSecond > 2.0 ? newSpeedInMeterPerSecond : 0;
  }
}
