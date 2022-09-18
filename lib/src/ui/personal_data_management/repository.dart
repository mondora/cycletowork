import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';
import 'package:cycletowork/src/utility/notification.dart';
import 'package:cycletowork/src/utility/user_auth.dart';

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
    _localDatabase = serviceLocator.getLocalData();
    _remoteService = serviceLocator.getRemoteData();
  }

  Future<bool?> deleteAccount() async {
    await _remoteService.deleteAccount();
    await _localDatabase.deleteAccount();

    var token = await _localDatabase.getDeviceToken();
    if (token != null) {
      await _remoteService.removeDeviceToken(token);
      await _localDatabase.removeDeviceToken(token);
      await AppNotification.deleteToken();
    }
    await UserAuth.logout();

    return true;
  }
}
