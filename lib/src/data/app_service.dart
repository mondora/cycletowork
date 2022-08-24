import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/user_activity_summary.dart';

abstract class AppService {
  Future saveUserActivity(
    UserActivitySummary userActivitySummary,
    UserActivity userActivity,
    List<LocationData> listLocationData,
  );

  Future<bool> isOpenNewChallenge();

  Future<bool> isChallengeActivity();

  Future<List<UserActivity>> getListUserActivity({
    int page = 0,
    int pageSize = 50,
  });

  Future<UserActivitySummary> getUserActivitySummary();

  Future<List<LocationData>> getListLocationDataForActivity(
    String userActivityId,
  );

  Future<User> getUserInfo();

  Future<void> saveDeviceToken(String deviceToken);

  Future<List<String>> getDeviceTokens();

  Future<String?> getDeviceToken();

  Future<void> updateUserName(String name);
}
