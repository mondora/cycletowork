import 'dart:typed_data';

import 'package:cycletowork/src/data/chart_data.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/user_activity_summery.dart';
import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';
import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:cycletowork/src/utility/tracking_drawing.dart';
import 'package:cycletowork/src/widget/chart.dart';
import 'package:flutter/material.dart';

class ServiceLocator implements RepositoryServiceLocator {
  @override
  LocalDatabaseService getLocalData() {
    return LocalDatabaseService();
  }

  @override
  RemoteService getRemoteData() {
    return RemoteService();
  }
}

class Repository {
  late final RemoteService _remoteService;
  late final LocalDatabaseService _localDatabase;

  final gpsGranted = GpsStatus.granted;

  Repository() {
    var serviceLocator = ServiceLocator();
    _localDatabase = serviceLocator.getLocalData();
    _remoteService = serviceLocator.getRemoteData();
  }

  Future<bool> isOpenNewChallenge() async {
    return false;
  }

  Future<bool> isChallengeActivity() async {
    return false;
  }

  Future<List<UserActivity>> getListUserActivity(
    int page,
    int pageSize,
  ) async {
    try {
      return await _localDatabase.getListUserActivity(
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      Logger.error(e);
      return [];
    }
  }

  Future<List<UserActivity>> getListUserActivityFiltered(
    int page,
    int pageSize,
    bool justChallenges,
    ChartScaleType chartScaleType,
  ) async {
    try {
      return await _localDatabase.getListUserActivity(
        page: page,
        pageSize: pageSize,
        justChallenges: justChallenges,
        thisWeek: chartScaleType == ChartScaleType.week,
        thisMonth: chartScaleType == ChartScaleType.month,
        thisYear: chartScaleType == ChartScaleType.year,
        timeFilter: true,
      );
    } catch (e) {
      Logger.error(e);
      return [];
    }
  }

  Future<UserActivitySummery?> getUserActivitySummery() async {
    try {
      return await _localDatabase.getUserActivitySummery();
    } catch (e) {
      Logger.error(e);
      return null;
    }
  }

  Future<bool> saveUserActivity(
    UserActivitySummery userActivitySummery,
    UserActivity userActivity,
    List<LocationData> listLocationData,
  ) async {
    try {
      await _localDatabase.saveUserActivity(
        userActivitySummery,
        userActivity,
        listLocationData,
      );
      await _remoteService.saveUserActivity(
        userActivitySummery,
        userActivity,
        listLocationData,
      );
      return true;
    } catch (e) {
      Logger.error(e);
      return false;
    }
  }

  Future<bool> isGpsGranted() async {
    var status = await Gps.getGpsStatus();
    if (status == GpsStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<GpsStatus> getGpsStatus() async {
    return await Gps.getGpsStatus();
  }

  Future<LocationData?> getCurrentPosition() async {
    return await Gps.getCurrentPosition();
  }

  Future setGpsConfig(BuildContext context) async {
    await Gps.setSettings();
    var date = DateTime.now().toLocal();
    await Gps.setNotificaion(
      title: date.toDayInterval(context),
      subtitle: date.toStartTime(context),
    );
  }

  Stream<LocationData> startListenOnBackground() {
    return Gps.startListenOnBackground();
  }

  double calculateDistanceInMeter(
    LocationData startPosition,
    LocationData stopPosition,
  ) {
    return LocationData.calculateDistanceInMeter(
      latitude1: startPosition.latitude,
      longitude1: startPosition.longitude,
      latitude2: stopPosition.latitude,
      longitude2: stopPosition.longitude,
    );
  }

  double calculateDistanceInRadians(
    LocationData startPosition,
    LocationData stopPosition,
  ) {
    return LocationData.calculateDistanceInRadians(
      latitude1: startPosition.latitude,
      longitude1: startPosition.longitude,
      latitude2: stopPosition.latitude,
      longitude2: stopPosition.longitude,
    );
  }

  Future<Uint8List> getMapImageData(
    List<LocationData> listTrackingPosition,
    Color backgroundColor,
  ) async {
    return await TrackingDrawing.getTrackingDrawing(
      listTrackingPosition: listTrackingPosition,
      backgroundColor: backgroundColor,
    );
  }

  UserActivityChartData getUserActivityChartData(Map args) {
    List<UserActivity> listUserActivity = args['listUserActivity'];
    ChartScaleType chartScaleType = args['chartScaleType'];
    List<ChartData> listCo2ChartData = [];
    List<ChartData> listDistanceChartData = [];

    if (chartScaleType == ChartScaleType.week) {
      for (var offsetDay = 0; offsetDay < 7; offsetDay++) {
        var startDate = DateTime.now().getDateOfThisWeek(offsetDay: offsetDay);
        var endDate =
            DateTime.now().getDateOfThisWeek(offsetDay: offsetDay + 1);

        var userActivitySelected = listUserActivity.where(
          (userActivity) =>
              userActivity.stopTime! >= startDate.millisecondsSinceEpoch &&
              userActivity.stopTime! < endDate.millisecondsSinceEpoch,
        );
        if (userActivitySelected.isEmpty) {
          listCo2ChartData.add(ChartData(offsetDay, 0));
          listDistanceChartData.add(ChartData(offsetDay, 0));
        } else {
          listCo2ChartData.add(
            ChartData(
              offsetDay,
              (userActivitySelected.map((e) => e.co2).reduce(
                            (a, b) => a! + b!,
                          ) ??
                      0)
                  .gramToKg(),
            ),
          );
          listDistanceChartData.add(
            ChartData(
              offsetDay,
              (userActivitySelected.map((e) => e.distance).reduce(
                            (a, b) => a! + b!,
                          ) ??
                      0)
                  .meterToKm(),
            ),
          );
        }
      }
    }

    if (chartScaleType == ChartScaleType.month) {
      for (var offsetDay = 0; offsetDay < 4; offsetDay++) {
        var dateNow = DateTime.now();
        var beginningNextMonth = (dateNow.month < 12)
            ? DateTime(dateNow.year, dateNow.month + 1, 1)
            : DateTime(dateNow.year + 1, 1, 1);

        var startDate =
            DateTime(dateNow.year, dateNow.month, (1 + (offsetDay * 7)));
        var endDate = offsetDay == 3
            ? DateTime(dateNow.year, beginningNextMonth.month, 1)
            : DateTime(dateNow.year, dateNow.month, (8 + (offsetDay * 7)));

        var userActivitySelected = listUserActivity.where(
          (userActivity) =>
              userActivity.stopTime! >= startDate.millisecondsSinceEpoch &&
              userActivity.stopTime! < endDate.millisecondsSinceEpoch,
        );
        if (userActivitySelected.isEmpty) {
          listCo2ChartData.add(ChartData(offsetDay, 0));
          listDistanceChartData.add(ChartData(offsetDay, 0));
        } else {
          listCo2ChartData.add(
            ChartData(
              offsetDay,
              (userActivitySelected.map((e) => e.co2).reduce(
                            (a, b) => a! + b!,
                          ) ??
                      0)
                  .gramToKg(),
            ),
          );
          listDistanceChartData.add(
            ChartData(
              offsetDay,
              (userActivitySelected.map((e) => e.distance).reduce(
                            (a, b) => a! + b!,
                          ) ??
                      0)
                  .meterToKm(),
            ),
          );
        }
      }
    }

    if (chartScaleType == ChartScaleType.year) {
      for (var offsetMonth = 0; offsetMonth < 12; offsetMonth++) {
        var dateNow = DateTime.now();

        var startDate = DateTime(dateNow.year, (1 + offsetMonth), 1);
        var endDate = offsetMonth == 11
            ? DateTime(dateNow.year + 1, 1, 1)
            : DateTime(dateNow.year, (1 + (offsetMonth + 1)), 1);

        var userActivitySelected = listUserActivity.where(
          (userActivity) =>
              userActivity.stopTime! >= startDate.millisecondsSinceEpoch &&
              userActivity.stopTime! < endDate.millisecondsSinceEpoch,
        );
        if (userActivitySelected.isEmpty) {
          listCo2ChartData.add(ChartData(offsetMonth, 0));
          listDistanceChartData.add(ChartData(offsetMonth, 0));
        } else {
          listCo2ChartData.add(
            ChartData(
              offsetMonth,
              (userActivitySelected.map((e) => e.co2).reduce(
                            (a, b) => a! + b!,
                          ) ??
                      0)
                  .gramToKg(),
            ),
          );
          listDistanceChartData.add(
            ChartData(
              offsetMonth,
              (userActivitySelected.map((e) => e.distance).reduce(
                            (a, b) => a! + b!,
                          ) ??
                      0)
                  .meterToKm(),
            ),
          );
        }
      }
    }

    return UserActivityChartData.instance(
      listCo2ChartData,
      listDistanceChartData,
    );
  }
}
