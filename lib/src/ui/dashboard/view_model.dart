import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/ui/dashboard/repository.dart';
import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:cycletowork/src/utility/notification.dart';
import 'package:cycletowork/src/widget/chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock/wakelock.dart';

class ViewModel extends ChangeNotifier {
  final initialLatitude = 45.50315189900018;
  final initialLongitude = 9.198330425060847;
  final _minDistanceInMeterToAdd = 3;
  final _minDistanceFromLineInMeterToAdd = 2;
  final _minAccuracyToAdd = 20;
  final _delayForAverageSpeed = 10;
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
  bool _startedAfterPaused = false;
  ChallengeRegistry? _challengeActive;

  Timer? _timer;
  StreamSubscription<LocationData>? _locationSubscription;

  ViewModel() : this.instance();

  ViewModel.instance() {
    getter();
  }

  void getter() async {
    _uiState.refreshLocationLoading = true;
    _uiState.refreshClassificationLoading = true;
    notifyListeners();
    try {
      _initAppNotification();
      notifyListeners();
      AppData.isUserUsedEmailProvider = _repository.isUserUsedEmailProvider();
      await getListUserActivity();
      await getListUserActivityFilterd();
      await _getActiveChallengeList();
      await getListChallengeRegistred();
      _uiState.listCompanyClassificationOrderByRankingCo2 = false;
      await refreshCompanyClassification();
      _uiState.listCompanyClassificationOrderByRankingCo2 = true;
      await refreshCompanyClassification();
      await refreshCyclistClassification();
      await refreshDepartmentClassification();
      notifyListeners();
      _uiState.currentPosition = await _getCurrentLocation();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      _uiState.refreshLocationLoading = false;
      notifyListeners();
    }
  }

  void startCounter(context, bool isWakelockModeEnable) async {
    _uiState.loading = true;
    notifyListeners();
    _uiState.counter = 5;
    _trackingPaused = false;
    _startedAfterPaused = false;
    if (isWakelockModeEnable) {
      await Wakelock.enabled;
    }
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
      city: '',
    );
    _listTrackingPosition = [];
    await _getCurrentLocation();
    _uiState.loading = false;
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
            _trackingUserActivity!.duration++;
          }
          if (!_isTrackingStarted()) {
            _trackingUserActivity!.startTime =
                DateTime.now().toLocal().millisecondsSinceEpoch;
            _uiState.dashboardPageOption = DashboardPageOption.startTracking;
            notifyListeners();
            return;
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

  void getUserInfo() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      AppData.user = await _repository.getUserInfo();
      AppData.isUserUsedEmailProvider = _repository.isUserUsedEmailProvider();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void getActiveChallengeListAndClassification() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      AppData.user = await _repository.getUserInfo();
      await _getActiveChallengeList();
      await getListChallengeRegistred();
      _uiState.listCompanyClassificationOrderByRankingCo2 = false;
      await refreshCompanyClassification();
      _uiState.listCompanyClassificationOrderByRankingCo2 = true;
      await refreshCompanyClassification();
      await refreshCyclistClassification();
      await refreshDepartmentClassification();
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
    var permissionRequestMessage =
        'Per poter usare Cycle2Work è necessario che tu ci dia il permesso di rilevare la tua posizione';
    await _repository.setGpsConfig(
      context,
      0,
      permissionRequestMessage,
    );

    _locationSubscription =
        _repository.startListenOnBackground().handleError((dynamic e) async {
      if (e is PlatformException) {
        _uiState.errorMessage = e.toString();
        _uiState.error = true;
        Logger.error(e);
      }
      _timer?.cancel();
      await _locationSubscription?.cancel();
      _locationSubscription = null;
      _uiState.dashboardPageOption = DashboardPageOption.home;
    }).listen((LocationData locationData) {
      _uiState.currentPosition = locationData;
      if (_uiState.counter == 0 && !_trackingPaused) {
        _addToListTrackingPosition(locationData);
        if (_uiState.dashboardPageOption == DashboardPageOption.mapTracking) {
          notifyListeners();
        }
      }
    });
  }

  setUserActivityImageData(Uint8List? value) {
    _trackingUserActivity!.imageData = value;
  }

  setUserActivityCity(String value) {
    _trackingUserActivity!.city = value;
  }

  Future<bool> saveTracking(BuildContext context) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var userActivity = _trackingUserActivity!;
      AppData.user!.calorie += userActivity.calorie;
      AppData.user!.co2 += userActivity.co2;
      AppData.user!.distance += userActivity.distance;
      AppData.user!.steps += userActivity.steps;
      AppData.user!.maxSpeed = AppData.user!.maxSpeed < userActivity.maxSpeed
          ? userActivity.maxSpeed
          : AppData.user!.maxSpeed;
      AppData.user!.averageSpeed =
          (AppData.user!.averageSpeed + userActivity.averageSpeed) / 2;

      var result = await _repository.saveUserActivity(
        userActivity,
        _listTrackingPosition,
      );
      await getListUserActivity();
      await getListUserActivityFilterd();
      _uiState.dashboardPageOption = DashboardPageOption.home;
      _uiState.loading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      _uiState.dashboardPageOption = DashboardPageOption.home;
      _uiState.loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getListUserActivity({
    bool? nextPage,
  }) async {
    if (nextPage == true) {
      _uiState.userActivityPage++;
    }

    _uiState.refreshLocationLoading = true;
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
      _uiState.refreshLocationLoading = false;
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

    _uiState.refreshLocationLoading = true;
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
      _uiState.refreshLocationLoading = false;
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
    _startedAfterPaused = true;
    _trackingPaused = false;
    _uiState.dashboardPageOption = DashboardPageOption.startTracking;
    notifyListeners();
  }

  void showMapTracking() {
    _uiState.dashboardPageOption = DashboardPageOption.mapTracking;
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
    _uiState.dashboardPageOption = DashboardPageOption.pauseTracking;
    notifyListeners();
  }

  void stopTracking() async {
    _uiState.loading = true;
    notifyListeners();
    _trackingPaused = true;
    _timer?.cancel();
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    await Wakelock.disable();

    _locationSubscription = null;
    _trackingUserActivity!.stopTime =
        DateTime.now().toLocal().millisecondsSinceEpoch;
    _uiState.dashboardPageOption = DashboardPageOption.stopTracking;
    _uiState.loading = false;
    notifyListeners();
  }

  void refreshLocation() async {
    _uiState.refreshLocationLoading = true;
    notifyListeners();
    try {
      _uiState.currentPosition = await _getCurrentLocation();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.refreshLocationLoading = false;
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

  Future<void> refreshDepartmentClassification({
    bool? nextPage,
  }) async {
    if (_uiState.listChallengeRegistred.isEmpty ||
        _uiState.challengeRegistrySelected == null ||
        _uiState.challengeRegistrySelected!.departmentName == '') {
      return;
    }

    _uiState.refreshClassificationLoading = true;
    notifyListeners();
    try {
      var challengeRegistry = _uiState.challengeRegistrySelected!;
      _uiState.userDepartmentClassification =
          await _repository.getUserDepartmentClassification(
        challengeRegistry,
      );

      if (nextPage == true) {
        _uiState.listDepartmentClassificationPage++;
      } else {
        _uiState.lastDepartmentClassificationCo2 = null;
        _uiState.listDepartmentClassificationPage = 0;
        _uiState.listDepartmentClassification = [];
      }

      var pageSize = _uiState.listDepartmentClassificationPageSize;
      var page = _uiState.listDepartmentClassificationPage;
      var lastCo2 = _uiState.lastDepartmentClassificationCo2;

      var result =
          await _repository.getListDepartmentClassificationByRankingCo2(
        challengeRegistry,
        page,
        pageSize,
        lastCo2,
      );
      if (nextPage == true) {
        if (result.isNotEmpty) {
          _uiState.listDepartmentClassification.addAll(result);
          _uiState.lastDepartmentClassificationCo2 = result.last.co2;
        } else {
          _uiState.listDepartmentClassificationPage--;
        }
      } else {
        if (result.isNotEmpty) {
          _uiState.listDepartmentClassification = result;
          _uiState.lastDepartmentClassificationCo2 = result.last.co2;
        }
      }
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.refreshClassificationLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCyclistClassification({
    bool? nextPage,
  }) async {
    if (_uiState.listChallengeRegistred.isEmpty ||
        _uiState.challengeRegistrySelected == null) {
      return;
    }

    _uiState.refreshClassificationLoading = true;
    notifyListeners();
    try {
      var challengeRegistry = _uiState.challengeRegistrySelected!;
      _uiState.userCyclistClassification =
          await _repository.getUserCyclistClassification(
        challengeRegistry,
      );

      if (nextPage == true) {
        _uiState.listCyclistClassificationPage++;
      } else {
        _uiState.lastCyclistClassificationCo2 = null;
        _uiState.listCyclistClassificationPage = 0;
        _uiState.listCyclistClassification = [];
      }

      var pageSize = _uiState.listCyclistClassificationPageSize;
      var page = _uiState.listCyclistClassificationPage;
      var lastCo2 = _uiState.lastCyclistClassificationCo2;

      var result = await _repository.getListCyclistClassificationByRankingCo2(
        challengeRegistry,
        page,
        pageSize,
        lastCo2,
      );
      if (nextPage == true) {
        if (result.isNotEmpty) {
          _uiState.listCyclistClassification.addAll(result);
          _uiState.lastCyclistClassificationCo2 = result.last.co2;
        } else {
          _uiState.listCyclistClassificationPage--;
        }
      } else {
        if (result.isNotEmpty) {
          _uiState.listCyclistClassification = result;
          _uiState.lastCyclistClassificationCo2 = result.last.co2;
        }
      }
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.refreshClassificationLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCompanyClassification({
    bool? nextPage,
  }) async {
    if (_uiState.listChallengeRegistred.isEmpty ||
        _uiState.challengeRegistrySelected == null) {
      return;
    }

    _uiState.refreshClassificationLoading = true;
    notifyListeners();
    try {
      var challengeRegistry = _uiState.challengeRegistrySelected!;
      _uiState.userCompanyClassification =
          await _repository.getUserCompanyClassification(
        challengeRegistry,
      );
      if (_uiState.listCompanyClassificationOrderByRankingCo2) {
        if (nextPage == true) {
          _uiState.listCompanyClassificationRankingCo2Page++;
        } else {
          _uiState.lastCompanyClassificationCo2 = null;
          _uiState.listCompanyClassificationRankingCo2Page = 0;
          _uiState.listCompanyClassificationRankingCo2 = [];
        }

        var pageSize = _uiState.listCompanyClassificationRankingCo2PageSize;
        var page = _uiState.listCompanyClassificationRankingCo2Page;
        var lastCo2 = _uiState.lastCompanyClassificationCo2;

        var result = await _repository.getListCompanyClassificationByRankingCo2(
          challengeRegistry,
          page,
          pageSize,
          lastCo2,
        );
        if (nextPage == true) {
          if (result.isNotEmpty) {
            _uiState.listCompanyClassificationRankingCo2.addAll(result);
            _uiState.lastCompanyClassificationCo2 = result.last.co2;
          } else {
            _uiState.listCompanyClassificationRankingCo2Page--;
          }
        } else {
          if (result.isNotEmpty) {
            _uiState.listCompanyClassificationRankingCo2 = result;
            _uiState.lastCompanyClassificationCo2 = result.last.co2;
          }
        }
      } else {
        if (nextPage == true) {
          _uiState.listCompanyClassificationRankingRegisteredPage++;
        } else {
          _uiState.lastCompanyClassificationPercentRegistered = null;
          _uiState.listCompanyClassificationRankingRegisteredPage = 0;
          _uiState.listCompanyClassificationRankingRegistered = [];
        }

        var pageSize =
            _uiState.listCompanyClassificationRankingRegisteredPageSize;
        var page = _uiState.listCompanyClassificationRankingRegisteredPage;
        var lastPercentRegistered =
            _uiState.lastCompanyClassificationPercentRegistered;

        var result = await _repository
            .getListCompanyClassificationByRankingPercentRegistered(
          challengeRegistry,
          page,
          pageSize,
          lastPercentRegistered,
        );
        if (nextPage == true) {
          if (result.isNotEmpty) {
            _uiState.listCompanyClassificationRankingRegistered.addAll(result);
            _uiState.lastCompanyClassificationPercentRegistered =
                result.last.percentRegistered;
          } else {
            _uiState.listCompanyClassificationRankingRegisteredPage--;
          }
        } else {
          if (result.isNotEmpty) {
            _uiState.listCompanyClassificationRankingRegistered = result;
            _uiState.lastCompanyClassificationPercentRegistered =
                result.last.percentRegistered;
          }
        }
      }
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.refreshClassificationLoading = false;
      notifyListeners();
    }
  }

  void setListCompanyClassificationOrderByRankingCo2(bool value) {
    _uiState.listCompanyClassificationOrderByRankingCo2 = value;
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
      var permissionRequestMessage =
          'Per poter usare Cycle2Work è necessario che tu ci dia il permesso di rilevare la tua posizione';
      return await _repository.getCurrentPosition(permissionRequestMessage);
    }
    return null;
  }

  bool _checkShowAppBarAction(AppMenuOption appMenuOption) {
    return !_ignoreAppBarActionPages.any((element) => element == appMenuOption);
  }

  bool _isTrackingStarted() {
    return _uiState.dashboardPageOption == DashboardPageOption.startTracking ||
        _uiState.dashboardPageOption == DashboardPageOption.pauseTracking ||
        _uiState.dashboardPageOption == DashboardPageOption.mapTracking ||
        _uiState.dashboardPageOption == DashboardPageOption.stopTracking;
  }

  void _addToListTrackingPosition(LocationData locationData) {
    locationData.locationDataId = const Uuid().v4();
    locationData.userActivityId = _trackingUserActivity!.userActivityId;
    if (_listTrackingPosition.isEmpty || _startedAfterPaused) {
      if (_startedAfterPaused) {
        _startedAfterPaused = false;
      }
      locationData.speed = 0.0;
      _listTrackingPosition.add(locationData);
      _trackingUserActivity!.maxSpeed = locationData.speed;
      _trackingUserActivity!.averageSpeed = locationData.speed;
      return;
    }

    if (locationData.accuracy < 0) {
      return;
    }

    if (locationData.accuracy > _minAccuracyToAdd) {
      return;
    }

    var lastPosition = _listTrackingPosition.last;
    var distance = _trackingUserActivity!.distance;
    // var calorie = _trackingUserActivity!.calorie;
    var co2 = _trackingUserActivity!.co2;
    var maxSpeed = _trackingUserActivity!.maxSpeed;
    var newDistance = _repository
        .calculateDistanceInMeter(
          lastPosition,
          locationData,
        )
        .abs();

    if (newDistance < locationData.accuracy) {
      return;
    }

    // var newCalorie = newDistance.toCalorieFromDistanceInMeter();
    var newCo2 = newDistance.distanceInMeterToCo2g();
    // var newSpeed = locationData.speed > 1 ? locationData.speed : 0.0;
    var durationLastLocation =
        locationData.time.millisecondsSinceEpochToSeconde() -
            lastPosition.time.millisecondsSinceEpochToSeconde();
    var newSpeed =
        durationLastLocation != 0 ? newDistance / durationLastLocation : 0.0;
    newSpeed = newSpeed > 1 ? newSpeed : 0;
    locationData.speed = newSpeed;
    _trackingUserActivity!.maxSpeed = maxSpeed < newSpeed ? newSpeed : maxSpeed;
    if (newDistance < _minDistanceInMeterToAdd) {
      lastPosition.speed = newSpeed;
      return;
    }

    _trackingUserActivity!.distance = distance + newDistance;

    _trackingUserActivity!.co2 = co2 + newCo2;
    _trackingUserActivity!.steps +=
        newDistance.distanceInMeterToSteps().toInt();

    _trackingUserActivity!.calorie =
        _trackingUserActivity!.distance.toCalorieFromDistanceInMeter();
    if (_listTrackingPosition.length < 2) {
      _listTrackingPosition.add(locationData);

      if (_trackingUserActivity!.duration > _delayForAverageSpeed) {
        _trackingUserActivity!.averageSpeed =
            _listTrackingPosition.map((e) => e.speed).reduce((a, b) => a + b) /
                2;
      }
    } else {
      var point = lastPosition;
      var endPont = locationData;
      var startPoint = _listTrackingPosition[_listTrackingPosition.length - 2];
      var distance = LocationData.distanceToLine(point, startPoint, endPont);
      if (distance >= _minDistanceFromLineInMeterToAdd) {
        _listTrackingPosition.add(locationData);
      } else {
        _listTrackingPosition[_listTrackingPosition.length - 1] = locationData;
      }
      var totalDistance = _trackingUserActivity!.distance;
      var totalDuration = _trackingUserActivity!.duration;
      if (_trackingUserActivity!.duration > _delayForAverageSpeed) {
        _trackingUserActivity!.averageSpeed = totalDistance / totalDuration;
      }
    }
  }

  Future<void> _getActiveChallengeList() async {
    _uiState.listChallengeActive = await _repository.getActiveChallengeList();
    notifyListeners();
  }

  Future<void> getListChallengeRegistred() async {
    var result = await _repository.getListChallengeRegistred();
    if (result.isNotEmpty) {
      _uiState.listChallengeRegistred = result;
      _uiState.challengeRegistrySelected = result.first;
    } else {
      _uiState.refreshClassificationLoading = false;
    }
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
