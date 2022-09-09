import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:cycletowork/src/utility/notification.dart';
import 'package:cycletowork/src/utility/user_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

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
    var token = await _localDatabase.getDeviceToken();
    if (token != null) {
      await _remoteService.removeDeviceToken(token);
      await _localDatabase.removeDeviceToken(token);
    }
    await UserAuth.logout();
  }

  Stream<bool> isAuthenticatedStateChanges() {
    return UserAuth.isAuthenticatedStateChanges();
  }

  bool isAuthenticated() {
    return UserAuth.isAuthenticated();
  }

  Future<User> getUserInfo() async {
    var user = await _remoteService.getUserInfo();
    var localUser = await _localDatabase.getUserInfo(user.uid);
    if (localUser == null) {
      var listUserActivity = await _remoteService.getListUserActivity(
        pageSize: 200,
      );
      for (var userActivity in listUserActivity) {
        await _localDatabase.saveUserActivity(userActivity, []);
      }
    }
    await _localDatabase.saveUserInfo(user);
    FirebaseCrashlytics.instance.setUserIdentifier(user.uid);
    return user;
  }

  Future<void> loginGoogleSignIn() async {
    await UserAuth.loginGoogleSignIn();
  }

  Future<void> saveDeviceToken() async {
    var deviceToken = await AppNotification.getToken();
    var localDeviceToken = await _localDatabase.getDeviceToken();
    var expireDate = await _localDatabase.getDeviceTokenExpireDate();
    var uid = await _localDatabase.getUserUID();

    if (deviceToken == null) {
      return;
    }

    if (deviceToken == localDeviceToken &&
        expireDate != null &&
        DateTime.now().millisecondsSinceEpoch < expireDate &&
        uid != null &&
        uid == AppData.user!.uid) {
      return;
    }

    await _remoteService.saveDeviceToken(deviceToken);
    await _localDatabase.saveDeviceToken(deviceToken);
  }

  Future<void> signupEmail(String email, String password, String? name) async {
    var result = await UserAuth.signupEmail(email, password);
    var isAuthenticated = this.isAuthenticated();
    if (result == true && name != null && name != '' && isAuthenticated) {
      Timer(const Duration(seconds: 3), () async {
        try {
          await _remoteService.updateUserName(name);
        } catch (e) {
          Logger.error(e);
        }
      });
    }
  }

  Future<void> loginEmail(String email, String password) async {
    await UserAuth.loginEmail(email, password);
  }

  Future<void> loginApple() async {
    await UserAuth.loginApple();
  }

  Future<bool> isAdmin() async {
    return await UserAuth.isAdmin();
  }
}
