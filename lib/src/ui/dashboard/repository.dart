import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/user_activity_summery.dart';
import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class DashboardServiceLocator implements RepositoryServiceLocator {
  @override
  LocalDatabaseService getLocalData() {
    return LocalDatabaseService();
  }

  @override
  RemoteService getRemoteData() {
    return RemoteService();
  }
}

class DashboardRepository {
  late final RemoteService _remoteService;
  late final LocalDatabaseService _localDatabase;

  final gpsGranted = GpsStatus.granted;

  DashboardRepository() {
    var dashboardServiceLocator = DashboardServiceLocator();
    _localDatabase = dashboardServiceLocator.getLocalData();
    _remoteService = dashboardServiceLocator.getRemoteData();
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
}
