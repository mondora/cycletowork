import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';
import 'package:uuid/uuid.dart';

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

  Future<bool?> changeDisplayName(
    String newDisplayName,
  ) async {
    await _remoteService.updateUserDisplayName(newDisplayName);
    AppData.user!.displayName = newDisplayName;
    return true;
  }

  Future<bool?> changePhotoURL(String imagePath) async {
    var fileName = const Uuid().v4();
    var result = await _remoteService.updateUserPhotoURL(imagePath, fileName);
    AppData.user!.photoURL = result;
    return true;
  }
}
