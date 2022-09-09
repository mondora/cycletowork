import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';

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

  Repository() {
    var serviceLocator = ServiceLocator();
    _remoteService = serviceLocator.getRemoteData();
  }

  Future<User> getUserInfo(String uid) async {
    return await _remoteService.getUserInfoAdmin(uid);
  }

  Future<bool> verifyUser(String uid) async {
    return await _remoteService.verifyUserAdmin(uid);
  }

  Future<bool> setAdminUser(String uid) async {
    return await _remoteService.setAdminUser(uid);
  }
}
