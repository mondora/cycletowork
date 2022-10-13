import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/workout.dart';
import 'package:cycletowork/src/ui/dashboard/repository.dart';
import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:cycletowork/src/utility/activity_recognition.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:cycletowork/src/utility/notification.dart';
import 'package:cycletowork/src/utility/vibration.dart';
import 'package:cycletowork/src/widget/chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ViewModel extends ChangeNotifier {
  final initialLatitude = 45.50315189900018;
  final initialLongitude = 9.198330425060847;
  final _ignoreAppBarActionPages = [
    AppMenuOption.profile,
  ];
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  UserActivity? _trackingUserActivity;
  UserActivity? get trackingUserActivity => _trackingUserActivity;

  ChallengeRegistry? _challengeActive;

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
      await getListUserActivityChartData();
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

  void refreshUserActivityFromLocal(String userActivityId) async {
    final result = await _repository.refreshUserActivityFromLocal(
      userActivityId,
    );

    if (result != null) {
      var index = _uiState.listUserActivity.indexWhere(
        (element) => element.userActivityId == userActivityId,
      );
      if (index > -1) {
        _uiState.listUserActivity[index] = UserActivity.fromMap(
          result.toJson(),
        );
      }

      index = _uiState.listUserActivityFiltered.indexWhere(
        (element) => element.userActivityId == userActivityId,
      );
      if (index > -1) {
        _uiState.listUserActivityFiltered[index] = UserActivity.fromMap(
          result.toJson(),
        );
      }
      notifyListeners();
    }
  }

  Future<void> getListUserActivityChartData({
    bool? justChallenges,
    ChartScaleType? chartScaleType,
  }) async {
    if (justChallenges != null) {
      _uiState.userActivityFilteredJustChallenges = justChallenges;
    }

    if (chartScaleType != null) {
      _uiState.userActivityFilteredChartScaleType = chartScaleType;
    }

    _uiState.refreshLocationLoading = true;
    notifyListeners();
    try {
      var result = await _repository.getListUserActivityFiltered(
        0,
        10000,
        _uiState.userActivityFilteredJustChallenges,
        _uiState.userActivityFilteredChartScaleType,
        true,
      );
      var args = {
        'listUserActivity': result,
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

  Future<void> getListUserActivityFilterd({
    bool? justChallenges,
    bool? nextPage,
  }) async {
    if (justChallenges != null) {
      _uiState.userActivityFilteredJustChallenges = justChallenges;
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
        false,
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
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.refreshLocationLoading = false;
      notifyListeners();
    }
  }

  void startCounter(context, bool isWakelockModeEnable) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _challengeActive = await _repository.isChallengeActivity();
      _trackingUserActivity = UserActivity(
        userActivityId: const Uuid().v4(),
        uid: AppData.user!.uid,
        startTime: 0,
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
        isUploaded: 0,
        maxAccuracy: 0,
        minAccuracy: 0,
        isSendedToReview: 0,
      );
      _uiState.workoutError = false;
      _uiState.workout = Workout(
        ActivityType.onBicycle,
        _trackingUserActivity!.userActivityId,
        isWakeLockEnabled: isWakelockModeEnable,
        onTickEverySecond: (int countdown) {
          final isTrackingStarted = _uiState.dashboardPageOption ==
                  DashboardPageOption.startTracking ||
              _uiState.dashboardPageOption ==
                  DashboardPageOption.pauseTracking ||
              _uiState.dashboardPageOption == DashboardPageOption.mapTracking ||
              _uiState.dashboardPageOption == DashboardPageOption.stopTracking;

          if (countdown == 0 &&
              _uiState.workout!.durationInSecond > 5 &&
              !_uiState.workout!.isRecivedLocation) {
            if (!_uiState.workoutError) {
              debugPrint('Not location position');
              _uiState.workoutErrorMessage =
                  'Attenzione! Cycle2Work non sta ricevendo i dati dal tuo GPS, oppure la precisione del GPS è bassa e ciò rende imprecisa la localizzazione. Ti suggeriamo di controllare le impostazioni del tuo GPS prima di avviare la pedalata!';
              _uiState.workoutError = true;
              Vibration.vibration(3000);
              notifyListeners();
            }
          } else if (countdown == 0 &&
              _uiState.workout!.durationInSecond > 1 &&
              (_uiState.workout!.isAccuracyIncludeAbnormalMinValue ||
                  _uiState.workout!.isAccuracyIncludeAbnormalMaxValue)) {
            if (!_uiState.workoutError) {
              debugPrint('Not isAccuracyIncludeAbnormalValue position');
              _uiState.workoutErrorMessage =
                  'Attenzione! Cycle2Work non sta ricevendo i dati dal tuo GPS, oppure la precisione del GPS è bassa e ciò rende imprecisa la localizzazione. Ti suggeriamo di controllare le impostazioni del tuo GPS prima di avviare la pedalata!';
              _uiState.workoutError = true;
              Vibration.vibration(3000);
              notifyListeners();
            }
          } else {
            if (_uiState.workout!.listLocationData.isNotEmpty) {
              final lastPositionTime =
                  _uiState.workout!.listLocationData.last.time;
              final lastPositionDateTime =
                  DateTime.fromMillisecondsSinceEpoch(lastPositionTime);
              final isAfter3Seconds = DateTime.now().isAfter(
                lastPositionDateTime.add(
                  const Duration(minutes: 5),
                ),
              );
              if (isAfter3Seconds) {
                if (!_uiState.workoutError) {
                  debugPrint('Not location after 5 minutes');
                  _uiState.workoutErrorMessage =
                      'Attenzione! Cycle2Work non sta ricevendo i dati dal tuo GPS da 5 mins!';
                  _uiState.workoutError = true;
                  Vibration.vibration(3000);
                  notifyListeners();
                }
              } else {
                if (_uiState.workoutError) {
                  _uiState.workoutError = false;
                  notifyListeners();
                }
              }
            } else {
              if (_uiState.workoutError) {
                _uiState.workoutError = false;
                notifyListeners();
              }
            }
          }

          if (countdown == 0 && !isTrackingStarted) {
            _trackingUserActivity!.startTime =
                DateTime.now().toLocal().millisecondsSinceEpoch;
            _uiState.dashboardPageOption = DashboardPageOption.startTracking;
            notifyListeners();
            return;
          }

          if (_uiState.dashboardPageOption ==
                  DashboardPageOption.startCounter ||
              _uiState.dashboardPageOption ==
                  DashboardPageOption.startTracking) {
            notifyListeners();
          }
        },
        onLocationData: (locationData) {
          _uiState.currentPosition = locationData;
          if (_uiState.dashboardPageOption == DashboardPageOption.mapTracking) {
            notifyListeners();
          }
        },
      );
      var permissionRequestMessage =
          'Per poter usare Cycle2Work è necessario che tu ci dia il permesso di rilevare la tua posizione';
      await _uiState.workout!.startWorkout(context, permissionRequestMessage);
      _uiState.loading = false;
      _uiState.dashboardPageOption = DashboardPageOption.startCounter;
      notifyListeners();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      _uiState.dashboardPageOption = DashboardPageOption.home;
      _uiState.loading = false;
      notifyListeners();
    }
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
      var workout = _uiState.workout!;
      userActivity.startTime = workout.startDateInMilliSeconds;
      userActivity.stopTime = workout.stopDateInMilliSeconds;
      userActivity.duration = workout.durationInSecond;
      userActivity.co2 = workout.co2InGram;
      userActivity.distance = workout.distanceInMeter;
      userActivity.averageSpeed = workout.averageSpeedInMeterPerSecond;
      userActivity.maxSpeed = workout.maxSpeedInMeterPerSecond;
      userActivity.calorie = workout.calorie;
      userActivity.steps = workout.steps;
      userActivity.maxAccuracy = workout.accuracyAbnormalMaxValue ?? 0.0;
      userActivity.minAccuracy = workout.accuracyAbnormalMinValue ?? 0.0;

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
        _uiState.workout!.listLocationData,
        _uiState.workout!.listLocationDataUnFiltered,
      );
      await getListUserActivity();
      await getListUserActivityFilterd();
      await getListUserActivityChartData();
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

  void setCounter(int value) {
    _uiState.workout!.setCountdown(value);
    if (value == 0) {
      _uiState.dashboardPageOption = DashboardPageOption.startTracking;
    }
    notifyListeners();
  }

  void playTracking() async {
    _uiState.loading = true;
    notifyListeners();
    await _uiState.workout!.playAgainWorkout();
    _uiState.dashboardPageOption = DashboardPageOption.startTracking;
    _uiState.loading = false;
    notifyListeners();
  }

  void pauseTracking() async {
    _uiState.loading = true;
    notifyListeners();
    await _uiState.workout!.pauseWorkout();
    _uiState.dashboardPageOption = DashboardPageOption.pauseTracking;
    _uiState.loading = false;
    notifyListeners();
  }

  void stopTracking() async {
    _uiState.loading = true;
    notifyListeners();
    await _uiState.workout!.stopWorkout();
    _uiState.dashboardPageOption = DashboardPageOption.stopTracking;
    _uiState.loading = false;
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

  Future<void> refreshLocation() async {
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

      if (_uiState.userDepartmentClassification == null) {
        if (nextPage == true) {
          _uiState.listDepartmentClassificationPage--;
        }
        _uiState.refreshClassificationLoading = false;
        notifyListeners();
        return;
      }

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
    if (_uiState.gpsStatus == GpsStatus.granted) {
      var permissionRequestMessage =
          'Per poter usare Cycle2Work è necessario che tu ci dia il permesso di rilevare la tua posizione';
      return await _repository.getCurrentPosition(permissionRequestMessage);
    }
    return null;
  }

  bool _checkShowAppBarAction(AppMenuOption appMenuOption) {
    return !_ignoreAppBarActionPages.any((element) => element == appMenuOption);
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
