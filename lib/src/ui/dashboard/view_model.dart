import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/user_activity_summary.dart';
import 'package:cycletowork/src/ui/dashboard/repository.dart';
import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:cycletowork/src/utility/notification.dart';
import 'package:cycletowork/src/widget/chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class ViewModel extends ChangeNotifier {
  final initialLatitude = 45.50315189900018;
  final initialLongitude = 9.198330425060847;
  final _minDistanceInMeterToAdd = 3;
  final _minAngleInRadiansToAdd = 8;
  final _ignoreAppBarActionPages = [
    AppMenuOption.profile,
  ];
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  List<LocationData> _listTrackingPosition = [];
  List<LocationData> get listTrackingPosition => _listTrackingPosition;

  UserActivity? _trackingUserActivity;
  UserActivity? get trackingUserActivity => _trackingUserActivity;

  bool _trackingPaused = false;
  ChallengeRegistry? _challengeActive;

  Timer? _timer;
  StreamSubscription<LocationData>? _locationSubscription;

  ViewModel() : this.instance();

  ViewModel.instance() {
    getter();
  }

  void getter() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _initAppNotification();
      _uiState.userActivitySummary = await _repository.getUserActivitySummary();
      notifyListeners();
      await getListUserActivity();
      await _getActiveChallengeList();
      await getListUserActivityFilterd();
      notifyListeners();
      _uiState.currentPosition = await _getCurrentLocation();
      // _challengeActive = await _repository.isChallengeActivity();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void startCounter(context) async {
    _uiState.counter = 5;
    _trackingPaused = false;
    _challengeActive = await _repository.isChallengeActivity();
    _trackingUserActivity = UserActivity(
      userActivityId: const Uuid().v4(),
      uid: AppData.user!.uid,
      startTime: DateTime.now().toLocal().millisecondsSinceEpoch,
      stopTime: 0,
      duration: 0,
      co2: 0,
      distance: 0,
      averageSpeed: 0,
      maxSpeed: 0,
      calorie: 0,
      steps: 0,
      isChallenge: _challengeActive != null ? 1 : 0,
      challengeId: _challengeActive?.challengeId,
      companyId: _challengeActive?.companyId,
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
                _trackingUserActivity!.duration + 1;
          }
        }

        if (_uiState.dashboardPageOption == DashboardPageOption.startCounter ||
            _uiState.dashboardPageOption == DashboardPageOption.startTracking) {
          notifyListeners();
        }
      },
    );
  }

  void getActiveChallengeList() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _getActiveChallengeList();
      AppData.user = await _repository.getUserInfo();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
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

  void saveTracking(String localeIdentifier) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var userActivity = _trackingUserActivity!;
      userActivity.imageData = await _repository.getMapImageData(
        _listTrackingPosition,
      );
      var oldUserActivitySummary = _uiState.userActivitySummary!;
      var userActivitySummary = UserActivitySummary(
        uid: AppData.user!.uid,
        co2: oldUserActivitySummary.co2 + userActivity.co2,
        distance: oldUserActivitySummary.distance + userActivity.distance,
        averageSpeed:
            (oldUserActivitySummary.averageSpeed + userActivity.averageSpeed) /
                2,
        maxSpeed: (oldUserActivitySummary.maxSpeed + userActivity.maxSpeed) / 2,
        calorie: oldUserActivitySummary.calorie + userActivity.calorie,
        steps: oldUserActivitySummary.steps + userActivity.steps,
      );
      if (_listTrackingPosition.isNotEmpty) {
        var firstLocation = _listTrackingPosition.first;
        userActivity.city = await _repository.getCityNameFromLocation(
          firstLocation,
          localeIdentifier: localeIdentifier,
        );
      } else {
        userActivity.city = '';
      }
      await _repository.saveUserActivity(
        userActivitySummary,
        userActivity,
        _listTrackingPosition,
      );
      _uiState.userActivitySummary = userActivitySummary;
      await getListUserActivity();
      await getListUserActivityFilterd();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.dashboardPageOption = DashboardPageOption.home;
      _uiState.loading = false;
      notifyListeners();
    }
  }

  Future<void> getListUserActivity({
    bool? nextPage,
  }) async {
    if (nextPage == true) {
      _uiState.userActivityPage++;
    }

    _uiState.loading = true;
    notifyListeners();
    try {
      var result = await _repository.getListUserActivity(
        _uiState.userActivityPage,
        _uiState.userActivityPageSize,
      );
      if (nextPage == true) {
        if (result.isNotEmpty) {
          _uiState.listUserActivity.addAll(result);
        } else {
          _uiState.userActivityPage--;
        }
      } else {
        _uiState.listUserActivity = result;
      }
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  Future<void> getListUserActivityFilterd({
    bool? justChallenges,
    ChartScaleType? chartScaleType,
    bool? nextPage,
  }) async {
    if (justChallenges != null) {
      _uiState.userActivityFilteredJustChallenges = justChallenges;
      _uiState.userActivityFilteredPage = 0;
    }

    if (chartScaleType != null) {
      _uiState.userActivityFilteredChartScaleType = chartScaleType;
      _uiState.userActivityFilteredPage = 0;
    }

    if (nextPage == true) {
      _uiState.userActivityFilteredPage++;
    }

    _uiState.loading = true;
    notifyListeners();
    try {
      var result = await _repository.getListUserActivityFiltered(
        _uiState.userActivityFilteredPage,
        _uiState.userActivityFilteredPageSize,
        _uiState.userActivityFilteredJustChallenges,
        _uiState.userActivityFilteredChartScaleType,
      );
      if (nextPage == true) {
        if (result.isNotEmpty) {
          _uiState.listUserActivityFiltered.addAll(result);
        } else {
          _uiState.userActivityFilteredPage--;
        }
      } else {
        _uiState.listUserActivityFiltered = result;
      }
      var args = {
        'listUserActivity': _uiState.listUserActivityFiltered,
        'chartScaleType': _uiState.userActivityFilteredChartScaleType,
      };
      _uiState.userActivityChartData = await compute(
        _repository.getUserActivityChartData,
        args,
      );
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
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
    _trackingUserActivity!.stopTime =
        DateTime.now().toLocal().millisecondsSinceEpoch;
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
    locationData.locationDataId = const Uuid().v4();
    locationData.userActivityId = _trackingUserActivity!.userActivityId;
    if (_listTrackingPosition.isEmpty) {
      _listTrackingPosition.add(locationData);
      _trackingUserActivity!.maxSpeed = locationData.speed;
      _trackingUserActivity!.averageSpeed = locationData.speed;
      return;
    }
    var lastPosition = _listTrackingPosition.last;
    var distance = _trackingUserActivity!.distance;
    var calorie = _trackingUserActivity!.calorie;
    var co2 = _trackingUserActivity!.co2;
    var maxSpeed = _trackingUserActivity!.maxSpeed;
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

  Future<void> _getActiveChallengeList() async {
    _uiState.listChallengeActive = await _repository.getActiveChallengeList();
    notifyListeners();
  }

  _initAppNotification() {
    AppNotification.onMessageOpenedApp.listen((message) {
      AppNotification.showNotification(message);
      if (message.data['type'] != null &&
          message.data['type'] == 'new_challenge') {
        _getActiveChallengeList();
      }
    });

    AppNotification.onMessage.listen((message) {
      AppNotification.showNotification(message);
      if (message.data['type'] != null &&
          message.data['type'] == 'new_challenge') {
        _getActiveChallengeList();
      }
    });
  }
}
