import 'package:cycletowork/src/data/app_service.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/user_activity_summery.dart';
import 'package:cycletowork/src/service/remote.dart';

class RemoteService implements AppService {
  @override
  Future<bool> isOpenNewChallenge() {
    // TODO: implement isOpenNewChallenge
    throw UnimplementedError();
  }

  @override
  Future saveUserActivity(
    UserActivitySummery userActivitySummery,
    UserActivity userActivity,
    List<LocationData> listLocationData,
  ) async {
    // TODO: implement getListUserActivity
    throw UnimplementedError();
  }

  @override
  Future<List<UserActivity>> getListUserActivity({
    int page = 0,
    int pageSize = 50,
  }) {
    // TODO: implement getListUserActivity
    throw UnimplementedError();
  }

  @override
  Future<UserActivitySummery> getUserActivitySummery() async {
    // TODO: implement getUserActivitySummery
    throw UnimplementedError();
  }

  @override
  Future<bool> isChallengeActivity() {
    // TODO: implement isChallengeActivity
    throw UnimplementedError();
  }

  @override
  Future<List<LocationData>> getListLocationDataForActivity(
    String userActivityId,
  ) async {
    // TODO: implement getListLocationDataForActivity
    throw UnimplementedError();
  }

  @override
  Future<User> getUserInfo() async {
    // TODO: implement getListLocationDataForActivity
    throw UnimplementedError();
  }

  @override
  Future<String?> getDeviceToken() {
    // TODO: implement getDeviceToken
    throw UnimplementedError();
  }

  @override
  Future<void> saveDeviceToken(String deviceToken) async {
    var arg = {'deviceToken': deviceToken};
    await Remote.callFirebaseFunctions('saveDeviceToken', arg);
  }

  @override
  Future<List<String>> getDeviceTokens() {
    // TODO: implement getDeviceTokens
    throw UnimplementedError();
  }
}
