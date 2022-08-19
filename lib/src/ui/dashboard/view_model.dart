import 'dart:async';

import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/user_activity_summery.dart';
import 'package:cycletowork/src/ui/dashboard/repository.dart';
import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  final initialLatitude = 45.50315189900018;
  final initialLongitude = 9.198330425060847;
  final _minDistanceInMeterToAdd = 3;
  final _minAngleInRadiansToAdd = 8;
  final _ignoreAppBarActionPages = [
    AppMenuOption.profile,
  ];
  final _repository = DashboardRepository();

  final _uiState = DashboardUiState();
  DashboardUiState get uiState => _uiState;

  List<LocationData> _listTrackingPosition = [];
  List<LocationData> get listTrackingPosition => _listTrackingPosition;

  UserActivity? _trackingUserActivity;
  UserActivity? get trackingUserActivity => _trackingUserActivity;

  bool _trackingPaused = false;
  bool _isChallengeActivity = false;

  Timer? _timer;
  StreamSubscription<LocationData>? _locationSubscription;

  DashboardViewModel() : this.instance();

  DashboardViewModel.instance() {
    getter();
  }

  void getter() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _uiState.userActivitySummery = await _repository.getUserActivitySummery();
      notifyListeners();
      _uiState.listUserActivity = await _repository.getListUserActivity(
        _uiState.userActivityPage,
        _uiState.userActivityPageSize,
      );
      notifyListeners();
      _uiState.currentPosition = await _getCurrentLocation();
      _isChallengeActivity = await _repository.isChallengeActivity();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void startCounter(context) {
    _uiState.counter = 5;
    _trackingPaused = false;

    _trackingUserActivity = UserActivity(
      userActivityId: const Uuid().v4(),
      startTime: DateTime.now().toLocal().millisecondsSinceEpoch,
      stopTime: 0,
      duration: 0,
      co2: 0,
      distance: 0,
      averageSpeed: 0,
      maxSpeed: 0,
      calorie: 0,
      steps: 0,
      isChallenge: _isChallengeActivity ? 1 : 0,
    );
    _listTrackingPosition = [];

    _uiState.dashboardPageOption = DashboardPageOption.startCounter;
    notifyListeners();
    startGetLocation(context);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_uiState.counter != 0) {
          _uiState.counter--;
        } else {
          if (!_trackingPaused) {
            _trackingUserActivity!.duration =
                _trackingUserActivity!.duration! + 1;
          }
        }

        if (_uiState.dashboardPageOption == DashboardPageOption.startCounter ||
            _uiState.dashboardPageOption == DashboardPageOption.startTracking) {
          notifyListeners();
        }
      },
    );
  }

  void startGetLocation(context) async {
    await _repository.setGpsConfig(context);

    _locationSubscription =
        _repository.startListenOnBackground().handleError((dynamic e) {
      if (e is PlatformException) {
        _uiState.errorMessage = e.toString();
        _uiState.error = true;
        Logger.error(e);
      }
      _timer?.cancel();
      _locationSubscription?.cancel();
      _locationSubscription = null;
      _uiState.dashboardPageOption = DashboardPageOption.home;
    }).listen((LocationData locationData) {
      _uiState.currentPosition = locationData;
      if (_uiState.counter == 0) {
        if (!_isTrackingStarted()) {
          _trackingUserActivity!.startTime =
              DateTime.now().toLocal().millisecondsSinceEpoch;
          _uiState.dashboardPageOption = DashboardPageOption.startTracking;
          notifyListeners();
        }

        if (_isHaveToAddPossitionToList(locationData)) {
          addToListTrackingPosition(locationData);
        }
      }
    });
  }

  void saveTracking() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var userActivity = _trackingUserActivity!;
      var oldUserActivitySummery = _uiState.userActivitySummery!;
      var userActivitySummery = UserActivitySummery(
        co2: oldUserActivitySummery.co2 + (userActivity.co2 ?? 0),
        distance:
            oldUserActivitySummery.distance + (userActivity.distance ?? 0),
        averageSpeed: oldUserActivitySummery.averageSpeed +
            (userActivity.averageSpeed ?? 0),
        maxSpeed:
            oldUserActivitySummery.maxSpeed + (userActivity.maxSpeed ?? 0),
        calorie: oldUserActivitySummery.calorie + (userActivity.calorie ?? 0),
        steps: oldUserActivitySummery.steps + (userActivity.steps ?? 0),
      );
      await _repository.saveUserActivity(
        userActivitySummery,
        userActivity,
        _listTrackingPosition,
      );
      _uiState.userActivitySummery = userActivitySummery;
      _uiState.listUserActivity.add(userActivity);
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.dashboardPageOption = DashboardPageOption.home;
      _uiState.loading = false;
      notifyListeners();
    }
    // var userActivityId = const Uuid().v4();
    // var userActivity = UserActivity(
    //   userActivityId: userActivityId,
    //   startTime: _startTrackingDate!.millisecondsSinceEpoch,
    //   stopTime: _endTrackingDate!.millisecondsSinceEpoch,
    //   duration: _trackingDurationInSeconds,
    //   co2: 0,
    //   distance: 0,
    //   averageSpeed: 0,
    //   maxSpeed: 0,
    //   calorie: 0,
    //   steps: 0,
    //   imageData: [10, 100].toUint8List(),
    // );

    // await LocalDatabase.db.insertData(
    //   tableName: UserActivity.tableName,
    //   item: userActivity.toJson(),
    // );

    // await LocalDatabase.db.insertAll(
    //   tableName: LocationData.tableName,
    //   items: _listTrackingPosition.map((e) => e.toJson()).toList(),
    // );
  }

  void setCounter(int value) {
    _uiState.counter = value;
    if (value == 0) {
      _uiState.dashboardPageOption = DashboardPageOption.startTracking;
      _trackingUserActivity!.startTime =
          DateTime.now().toLocal().millisecondsSinceEpoch;
    }
    notifyListeners();
  }

  void playTracking() {
    _trackingPaused = false;
    _uiState.dashboardPageOption = DashboardPageOption.startTracking;
    notifyListeners();
  }

  void showMapTracking() {
    var lastPosition = _listTrackingPosition.last;
    var currentPosition = _uiState.currentPosition!;
    var distance = _repository.calculateDistanceInMeter(
      lastPosition,
      currentPosition,
    );
    if (distance > _minDistanceInMeterToAdd) {
      addToListTrackingPosition(currentPosition);
    }
    _uiState.dashboardPageOption = DashboardPageOption.showMapTracking;
    notifyListeners();
  }

  void hiddenMap() {
    _uiState.dashboardPageOption = DashboardPageOption.startTracking;
    notifyListeners();
  }

  void removeTracking() {
    _uiState.dashboardPageOption = DashboardPageOption.home;
    notifyListeners();
  }

  void pauseTracking() {
    _trackingPaused = true;
    var lastPosition = _listTrackingPosition.last;
    var currentPosition = _uiState.currentPosition!;
    var distance = _repository.calculateDistanceInMeter(
      lastPosition,
      currentPosition,
    );
    if (distance > _minDistanceInMeterToAdd) {
      addToListTrackingPosition(currentPosition);
    }
    _uiState.dashboardPageOption = DashboardPageOption.pauseTracking;
    notifyListeners();
  }

  void stopTracking() async {
    _trackingPaused = true;
    _timer?.cancel();
    await _locationSubscription?.cancel();

    _locationSubscription = null;
    // _stopTrackingDate = DateTime.now().toLocal();
    //TODO  userActivity
    _uiState.dashboardPageOption = DashboardPageOption.stopTracking;
    notifyListeners();
  }

  void refreshLocation() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _uiState.currentPosition = await _getCurrentLocation();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void changePageFromMenu(AppMenuOption appMenuOption) {
    _uiState.appMenuOption = appMenuOption;
    _uiState.showAppBarAction = _checkShowAppBarAction(appMenuOption);
    var findBottomNavBarOption = AppBottomNavBarOption.values.where(
      (x) => x.name == appMenuOption.name,
    );
    _uiState.appBottomNavBarOption =
        findBottomNavBarOption.isNotEmpty ? findBottomNavBarOption.first : null;
    notifyListeners();
  }

  void changePageFromBottomNavigation(
    AppBottomNavBarOption appBottomNavBarOption,
  ) {
    _uiState.appBottomNavBarOption = appBottomNavBarOption;
    var findMenuOption = AppMenuOption.values
        .firstWhere((x) => x.name == appBottomNavBarOption.name);
    _uiState.appMenuOption = findMenuOption;
    _uiState.showAppBarAction = _checkShowAppBarAction(findMenuOption);
    notifyListeners();
  }

  void clearError() {
    _uiState.loading = false;
    _uiState.error = false;
    _uiState.errorMessage = '';
    notifyListeners();
  }

  Future<LocationData?> _getCurrentLocation() async {
    _uiState.gpsStatus = await _repository.getGpsStatus();
    if (_uiState.gpsStatus == _repository.gpsGranted) {
      return await _repository.getCurrentPosition();
    }
    return null;
  }

  bool _checkShowAppBarAction(AppMenuOption appMenuOption) {
    return !_ignoreAppBarActionPages.any((element) => element == appMenuOption);
  }

  bool _isTrackingStarted() {
    return _uiState.dashboardPageOption == DashboardPageOption.startTracking ||
        _uiState.dashboardPageOption == DashboardPageOption.pauseTracking ||
        _uiState.dashboardPageOption == DashboardPageOption.showMapTracking ||
        _uiState.dashboardPageOption == DashboardPageOption.stopTracking;
  }

  bool _isHaveToAddPossitionToList(LocationData newLocationData) {
    if (_trackingPaused) return false;

    if (_listTrackingPosition.isEmpty) return true;

    var lastPosition = _listTrackingPosition.last;
    var distanceInMeter = _repository.calculateDistanceInMeter(
      lastPosition,
      newLocationData,
    );
    if (distanceInMeter < _minDistanceInMeterToAdd) return false;

    if (_listTrackingPosition.length == 1) return true;

    var preLastPosition =
        _listTrackingPosition[_listTrackingPosition.length - 2];
    var angle1InRadians = _repository.calculateDistanceInRadians(
      preLastPosition,
      lastPosition,
    );
    var angle2InRadians = _repository.calculateDistanceInRadians(
      lastPosition,
      newLocationData,
    );
    var angleInRadians = (angle1InRadians - angle2InRadians).abs();
    if (angleInRadians < _minAngleInRadiansToAdd) return false;

    return true;
  }

  void addToListTrackingPosition(LocationData locationData) {
    if (_listTrackingPosition.isEmpty) {
      _listTrackingPosition.add(locationData);
      _trackingUserActivity!.maxSpeed = locationData.speed;
      _trackingUserActivity!.averageSpeed = locationData.speed;
      return;
    }
    var lastPosition = _listTrackingPosition.last;
    var distance = _trackingUserActivity!.distance ?? 0;
    var calorie = _trackingUserActivity!.calorie ?? 0;
    var co2 = _trackingUserActivity!.co2 ?? 0;
    var maxSpeed = _trackingUserActivity!.maxSpeed ?? 0;
    var newDistance = _repository.calculateDistanceInMeter(
      lastPosition,
      locationData,
    );
    var newCalorie = newDistance.toCalorieFromDistanceInMeter();
    var newCo2 = newDistance.distanceInMeterToCo2g();
    var newSpeed = locationData.speed;
    _trackingUserActivity!.distance = distance + newDistance;
    _trackingUserActivity!.calorie = calorie + newCalorie;
    _trackingUserActivity!.co2 = co2 + newCo2;
    _trackingUserActivity!.maxSpeed = maxSpeed < newSpeed ? newSpeed : maxSpeed;
    _listTrackingPosition.add(locationData);
    _trackingUserActivity!.averageSpeed =
        _listTrackingPosition.map((e) => e.speed).reduce((a, b) => a + b) /
            _listTrackingPosition.length;
  }
}
