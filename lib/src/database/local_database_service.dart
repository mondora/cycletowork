import 'package:cycletowork/src/data/app_service.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity_summary.dart';
import 'package:cycletowork/src/database/local_database.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabaseService implements AppService {
  final _localDatabase = LocalDatabase.db;

  @override
  Future<bool> isOpenNewChallenge() {
    throw UnimplementedError();
  }

  @override
  Future saveUserActivity(
    UserActivitySummary userActivitySummary,
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

    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setDouble(
      UserActivitySummary.averageSpeedKey,
      userActivitySummary.averageSpeed,
    );
    await sharedPreferences.setDouble(
      UserActivitySummary.maxSpeedKey,
      userActivitySummary.maxSpeed,
    );
    await sharedPreferences.setInt(
      UserActivitySummary.calorieKey,
      userActivitySummary.calorie,
    );
    await sharedPreferences.setDouble(
      UserActivitySummary.co2Key,
      userActivitySummary.co2,
    );
    await sharedPreferences.setDouble(
      UserActivitySummary.distanceKey,
      userActivitySummary.distance,
    );
    await sharedPreferences.setInt(
      UserActivitySummary.stepsKey,
      userActivitySummary.steps,
    );
  }

  @override
  Future<List<UserActivity>> getListUserActivity({
    int page = 0,
    int pageSize = 100,
    bool justChallenges = false,
    bool orderByStopTimeDesc = true,
    bool timeFilter = false,
    bool thisWeek = true,
    bool thisMonth = false,
    bool thisYear = false,
  }) async {
    String? orderBy;
    String? whereCondition;
    List<dynamic> whereArgs = [];
    if (orderByStopTimeDesc) {
      orderBy = 'stopTime DESC';
    }

    if (justChallenges) {
      whereCondition =
          '''${whereCondition != null ? '$whereCondition  AND ' : ''}
          isChallenge = ?''';
      whereArgs.add(1);
    }

    if (timeFilter) {
      whereCondition =
          '''${whereCondition != null ? '$whereCondition  AND ' : ''}
            startTime >= ?''';
      var now = DateTime.now();
      if (thisWeek) {
        var dateThisWeek = DateTime.now().getDateOfThisWeek();
        whereArgs.add(dateThisWeek.millisecondsSinceEpoch);
      }
      if (thisMonth) {
        var dateThisMonth = DateTime(now.year, now.month, 1);
        whereArgs.add(dateThisMonth.millisecondsSinceEpoch);
      }
      if (thisYear) {
        var dateThisYear = DateTime(now.year, 1, 1);
        whereArgs.add(dateThisYear.millisecondsSinceEpoch);
      }
    }

    var result = await _localDatabase.getData(
      tableName: UserActivity.tableName,
      limit: pageSize,
      offset: page * pageSize,
      orderBy: orderBy,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );
    return result.map((json) => UserActivity.fromMap(json)).toList();
  }

  @override
  Future<UserActivitySummary> getUserActivitySummary() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var averageSpeed = sharedPreferences.getDouble(
      UserActivitySummary.averageSpeedKey,
    );
    var maxSpeed = sharedPreferences.getDouble(
      UserActivitySummary.maxSpeedKey,
    );
    var calorie = sharedPreferences.getInt(
      UserActivitySummary.calorieKey,
    );
    var co2 = sharedPreferences.getDouble(
      UserActivitySummary.co2Key,
    );
    var distance = sharedPreferences.getDouble(
      UserActivitySummary.distanceKey,
    );
    var steps = sharedPreferences.getInt(
      UserActivitySummary.stepsKey,
    );
    return UserActivitySummary(
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

  @override
  Future<List<LocationData>> getListLocationDataForActivity(
    String userActivityId,
  ) async {
    var result = await _localDatabase.getData(
      tableName: LocationData.tableName,
      whereCondition: 'userActivityId = ?',
      whereArgs: [userActivityId],
    );
    return result.map((json) => LocationData.fromMap(json)).toList();
  }

  @override
  Future<User> getUserInfo() {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }

  @override
  Future<void> saveDeviceToken(String deviceToken) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      User.deviceTokensKey,
      deviceToken,
    );
  }

  @override
  Future<String?> getDeviceToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
      User.deviceTokensKey,
    );
  }

  @override
  Future<List<String>> getDeviceTokens() {
    // TODO: implement getDeviceTokens
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserName(String name) {
    // TODO: implement updateUserName
    throw UnimplementedError();
  }
}
