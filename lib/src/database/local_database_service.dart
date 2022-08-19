import 'package:cycletowork/src/data/app_service.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity_summery.dart';
import 'package:cycletowork/src/database/local_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabaseService implements AppService {
  final _localDatabase = LocalDatabase.db;

  @override
  Future<bool> isOpenNewChallenge() {
    throw UnimplementedError();
  }

  @override
  Future saveUserActivity(
    UserActivitySummery userActivitySummery,
    UserActivity userActivity,
    List<LocationData> listLocationData,
  ) async {
    //TODO batch
    await _localDatabase.insertData(
      tableName: UserActivity.tableName,
      item: userActivity.toJson(),
    );
    for (var element in listLocationData) {
      await _localDatabase.insertData(
        tableName: LocationData.tableName,
        item: element.toJson(),
      );
    }
  }

  @override
  Future<List<UserActivity>> getListUserActivity({
    int page = 0,
    int pageSize = 50,
  }) async {
    var result = await _localDatabase.getData(
      tableName: UserActivity.tableName,
      limit: pageSize,
      offset: page * pageSize,
    );
    return result.map((json) => UserActivity.fromMap(json)).toList();
  }

  @override
  Future<UserActivitySummery> getUserActivitySummery() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var averageSpeed = sharedPreferences.getDouble(
      UserActivitySummery.averageSpeedKey,
    );
    var maxSpeed = sharedPreferences.getDouble(
      UserActivitySummery.maxSpeedKey,
    );
    var calorie = sharedPreferences.getInt(
      UserActivitySummery.calorieKey,
    );
    var co2 = sharedPreferences.getDouble(
      UserActivitySummery.co2Key,
    );
    var distance = sharedPreferences.getDouble(
      UserActivitySummery.distanceKey,
    );
    var steps = sharedPreferences.getInt(
      UserActivitySummery.stepsKey,
    );
    return UserActivitySummery(
      averageSpeed: averageSpeed ?? 0,
      maxSpeed: maxSpeed ?? 0,
      calorie: calorie ?? 0,
      co2: co2 ?? 0,
      distance: distance ?? 0,
      steps: steps ?? 0,
    );
  }

  @override
  Future<bool> isChallengeActivity() async {
    return false;
  }
}
