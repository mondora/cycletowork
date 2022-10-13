import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';
import 'package:cycletowork/src/utility/logger.dart';

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

  Repository() {
    var serviceLocator = ServiceLocator();
    _remoteService = serviceLocator.getRemoteData();
    _localDatabase = serviceLocator.getLocalData();
  }

  Future<List<LocationData>> getListLocationData(
    String userActivityId,
  ) async {
    return await _localDatabase.getListLocationDataForActivity(
      userActivityId,
    );
  }

  Future<List<LocationData>> getListLocationDataUnfiltred(
    String userActivityId,
  ) async {
    return await _localDatabase.getListLocationDataUnfiltredForActivity(
      userActivityId,
    );
  }

  Future<bool> saveUserActivity(
    UserActivity userActivity,
  ) async {
    try {
      await _remoteService.saveUserActivity(
        userActivity,
      );
      await _localDatabase.setUploadedUserActivity(
        userActivity.userActivityId,
      );
      userActivity.isUploaded = 1;
      return true;
    } catch (e) {
      Logger.error(e);
      return false;
    }
  }

  Future<bool> saveUserActivityLocationData(
    UserActivity userActivity,
    List<LocationData> listLocationData,
    List<LocationData> listLocationDataUnFiltred,
  ) async {
    try {
      final result = await _remoteService.saveUserActivityLocationData(
        userActivity,
        listLocationData,
        listLocationDataUnFiltred,
      );
      if (result != true) {
        return false;
      }
      await _localDatabase.setReviewedUserActivity(
        userActivity.userActivityId,
      );
      userActivity.isSendedToReview = 1;
      return true;
    } catch (e) {
      Logger.error(e);
      return false;
    }
  }
}
