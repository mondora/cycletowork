import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';
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
  Repository();

  Future<bool?> changePasswordForEmail(
    String currentPassword,
    String newPassword,
  ) async {
    return UserAuth.changePasswordForEmail(
      currentPassword,
      newPassword,
    );
  }
}
