import 'package:cycletowork/src/data/app_service.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity_summery.dart';
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

    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setDouble(
      UserActivitySummery.averageSpeedKey,
      userActivitySummery.averageSpeed,
    );
    await sharedPreferences.setDouble(
      UserActivitySummery.maxSpeedKey,
      userActivitySummery.maxSpeed,
    );
    await sharedPreferences.setInt(
      UserActivitySummery.calorieKey,
      userActivitySummery.calorie,
    );
    await sharedPreferences.setDouble(
      UserActivitySummery.co2Key,
      userActivitySummery.co2,
    );
    await sharedPreferences.setDouble(
      UserActivitySummery.distanceKey,
      userActivitySummery.distance,
    );
    await sharedPreferences.setInt(
      UserActivitySummery.stepsKey,
      userActivitySummery.steps,
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
      if (justChallenges) {
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
}
