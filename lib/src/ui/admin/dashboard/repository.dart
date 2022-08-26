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
  late final LocalDatabaseService _localDatabase;

  Repository() {
    var serviceLocator = ServiceLocator();
    _localDatabase = serviceLocator.getLocalData();
    _remoteService = serviceLocator.getRemoteData();
  }

  Future<ListUser> getListUser(
    int pageSize,
    String? nextPageToken,
    String? emailFilte,
  ) async {
    return await _remoteService.getListUserAdmin(
      pageSize,
      nextPageToken,
      emailFilte,
    );
  }

  Future<User> getUserInfo(String uid) async {
    return await _remoteService.getUserInfoAdmin(uid);
  }
}
