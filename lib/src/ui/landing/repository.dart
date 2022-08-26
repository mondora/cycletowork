import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/data/user.dart';
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

  Future<void> logout() async {
    await UserAuth.logout();
  }

  Stream<bool> isAuthenticatedStateChanges() {
    return UserAuth.isAuthenticatedStateChanges();
  }

  Future<bool> isAuthenticated() async {
    return false;
  }

  Future<User> getUserInfo() async {
    return await _remoteService.getUserInfo();
  }

  Future<void> loginGoogleSignIn() async {
    await UserAuth.loginGoogleSignIn();
  }

  Future<void> saveDeviceToken() async {
    var deviceToken = await AppNotification.getToken();
    var localDeviceToken = await _localDatabase.getDeviceToken();

    if (deviceToken != null && deviceToken != localDeviceToken) {
      await _remoteService.saveDeviceToken(deviceToken);
      await _localDatabase.saveDeviceToken(deviceToken);
    }
  }

  Future<void> signupEmail(String email, String password, String? name) async {
    var result = await UserAuth.signupEmail(email, password);
    if (result == true && name != null && name != '') {
      _remoteService.updateUserName(name);
    }
  }

  Future<void> loginEmail(String email, String password) async {
    await UserAuth.loginEmail(email, password);
  }

  bool isAdmin() {
    return UserAuth.isAdmin;
  }
}
