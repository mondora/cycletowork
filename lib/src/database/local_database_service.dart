import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/app_service.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/classification.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/database/local_database.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabaseService implements AppService, AppServiceOnlyLocal {
  final _localDatabase = LocalDatabase.db;

  @override
  Future saveUserActivity(
    UserActivity userActivity,
    List<LocationData> listLocationData,
    List<LocationData> listLocationDataUnFiltered,
  ) async {
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
    for (var element in listLocationDataUnFiltered) {
      await _localDatabase.insertData(
        tableName: LocationData.tableNameUnFiltered,
        item: element.toJson(),
      );
    }
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
    String whereCondition;
    List<dynamic> whereArgs = [];
    if (orderByStopTimeDesc) {
      orderBy = 'stopTime DESC';
    }

    whereCondition = 'uid = ?';
    whereArgs.add(AppData.user!.uid);

    if (justChallenges) {
      whereCondition = '$whereCondition  AND isChallenge = ?';
      whereArgs.add(1);
    }

    if (timeFilter) {
      whereCondition = '$whereCondition  AND startTime >= ?';
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
  Future<List<LocationData>> getListLocationDataUnfiltredForActivity(
    String userActivityId,
  ) async {
    var result = await _localDatabase.getData(
      tableName: LocationData.tableNameUnFiltered,
      whereCondition: 'userActivityId = ?',
      whereArgs: [userActivityId],
    );
    return result.map((json) => LocationData.fromMap(json)).toList();
  }

  @override
  Future<String?> getDeviceToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
      User.deviceTokensKey,
    );
  }

  @override
  Future<int?> getDeviceTokenExpireDate() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(
      User.deviceTokensExpireDateKey,
    );
  }

  @override
  Future<String?> getUserUID() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(
      User.userUIDKey,
    );
  }

  @override
  Future<void> saveDeviceToken(String deviceToken) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      User.deviceTokensKey,
      deviceToken,
    );
    var now = DateTime.now();
    var expireDate = DateTime(now.year, now.month, now.day + 20);
    await sharedPreferences.setInt(
      User.deviceTokensExpireDateKey,
      expireDate.millisecondsSinceEpoch,
    );
    await sharedPreferences.setString(
      User.userUIDKey,
      AppData.user!.uid,
    );
  }

  @override
  Future<void> removeDeviceToken(String deviceToken) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(
      User.deviceTokensKey,
    );
    await sharedPreferences.remove(
      User.deviceTokensExpireDateKey,
    );
    await sharedPreferences.remove(
      User.userUIDKey,
    );
  }

  @override
  Future<List<ChallengeRegistry>> getListActiveRegisterChallenge() async {
    var now = DateTime.now();
    String whereCondition =
        'uid = ? AND startTimeChallenge <= ? AND stopTimeChallenge >= ?';
    List<dynamic> whereArgs = [
      AppData.user!.uid,
      now.millisecondsSinceEpoch,
      now.millisecondsSinceEpoch,
    ];

    var map = await _localDatabase.getData(
      tableName: ChallengeRegistry.tableName,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );

    return map
        .map<ChallengeRegistry>(
          (json) => ChallengeRegistry.fromMapLocalDatabase(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  @override
  Future<List<ChallengeRegistry>> getListRegisterdChallenge() async {
    String whereCondition = 'uid = ?';
    List<dynamic> whereArgs = [AppData.user!.uid];
    String orderBy = 'registerDate DESC';

    var map = await _localDatabase.getData(
      tableName: ChallengeRegistry.tableName,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    return map
        .map<ChallengeRegistry>(
          (json) => ChallengeRegistry.fromMapLocalDatabase(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  @override
  Future<bool> registerChallenge(ChallengeRegistry challengeRegistry) async {
    await _localDatabase.insertData(
      tableName: ChallengeRegistry.tableName,
      item: challengeRegistry.toJsonForLocalDatabase(),
    );
    return true;
  }

  @override
  Future<void> saveUserInfo(User user) async {
    await _localDatabase.insertData(
      tableName: User.tableName,
      item: user.toJsonForLocalDatabase(),
    );
  }

  @override
  Future<void> saveListChallenge(List<Challenge> listChallenge) async {
    for (var element in listChallenge) {
      await _localDatabase.insertData(
        tableName: Challenge.tableName,
        item: element.toJsonForLocalDatabase(),
      );
    }
  }

  @override
  Future<User?> getUserInfo(String uid) async {
    String whereCondition = 'uid = ?';
    List<dynamic> whereArgs = [uid];

    var map = await _localDatabase.getData(
      tableName: User.tableName,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );
    var result = map.map<User>(
      (json) => User.fromMapLocalDatabase(Map<String, dynamic>.from(json)),
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  @override
  Future<Challenge?> getChallengeInfo(String challengeId) async {
    String whereCondition = 'challengeId = ?';
    List<dynamic> whereArgs = [challengeId];

    var map = await _localDatabase.getData(
      tableName: Challenge.tableName,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );
    var result = map.map<Challenge>(
      (json) => Challenge.fromMap(Map<String, dynamic>.from(json)),
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  @override
  Future<List<CompanyClassification>> getListCompanyClassification(
    String challengeId, {
    int page = 0,
    int pageSize = 50,
    bool orderByRankingCo2 = true,
  }) async {
    String whereCondition = 'challengeId = ?';
    List<dynamic> whereArgs = [challengeId];
    String orderBy = orderByRankingCo2 ? 'co2 DESC' : 'percentRegistered DESC';

    var map = await _localDatabase.getData(
      tableName: CompanyClassification.tableName,
      limit: pageSize,
      offset: page * pageSize,
      orderBy: orderBy,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );

    return map
        .map<CompanyClassification>(
          (json) => CompanyClassification.fromMap(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  @override
  Future<List<CyclistClassification>> getListCyclistClassification(
    String challengeId, {
    int page = 0,
    int pageSize = 50,
  }) async {
    String whereCondition = 'challengeId = ?';
    List<dynamic> whereArgs = [challengeId];
    String orderBy = 'co2 DESC';

    var map = await _localDatabase.getData(
      tableName: CyclistClassification.tableName,
      limit: pageSize,
      offset: page * pageSize,
      orderBy: orderBy,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );

    return map
        .map<CyclistClassification>(
          (json) => CyclistClassification.fromMap(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  @override
  Future<void> saveCompanyClassification(
    CompanyClassification companyClassification,
  ) async {
    await _localDatabase.insertData(
      tableName: CompanyClassification.tableName,
      item: companyClassification.toJson(),
    );
  }

  @override
  Future<void> saveCyclistClassification(
    CyclistClassification cyclistClassification,
  ) async {
    await _localDatabase.insertData(
      tableName: CyclistClassification.tableName,
      item: cyclistClassification.toJson(),
    );
  }

  @override
  Future<CompanyClassification?> getUserCompanyClassification(
    String challengeId,
    String companyId,
    String companySizeCategory,
  ) async {
    String whereCondition = 'challengeId = ? AND id = ?';
    List<dynamic> whereArgs = [challengeId, companyId];

    var map = await _localDatabase.getData(
      tableName: CompanyClassification.tableName,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );
    var result = map.map<CompanyClassification>(
      (json) => CompanyClassification.fromMap(Map<String, dynamic>.from(json)),
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  @override
  Future<CyclistClassification?> getUserCyclistClassification(
    String challengeId,
  ) async {
    String whereCondition = 'challengeId = ? AND uid = ?';
    List<dynamic> whereArgs = [challengeId, AppData.user!.uid];

    var map = await _localDatabase.getData(
      tableName: CyclistClassification.tableName,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );
    var result = map.map<CyclistClassification>(
      (json) => CyclistClassification.fromMap(Map<String, dynamic>.from(json)),
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  @override
  Future<List<DepartmentClassification>> getListDepartmentClassification(
    String challengeId,
    String companyId, {
    int page = 0,
    int pageSize = 50,
  }) async {
    String whereCondition = 'challengeId = ? AND id = ?';
    List<dynamic> whereArgs = [challengeId, companyId];
    String orderBy = 'co2 DESC';

    var map = await _localDatabase.getData(
      tableName: DepartmentClassification.tableName,
      limit: pageSize,
      offset: page * pageSize,
      orderBy: orderBy,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );

    return map
        .map<DepartmentClassification>(
          (json) => DepartmentClassification.fromMap(
            Map<String, dynamic>.from(json),
          ),
        )
        .toList();
  }

  @override
  Future<void> saveDepartmentClassification(
    DepartmentClassification departmentClassification,
  ) async {
    await _localDatabase.insertData(
      tableName: DepartmentClassification.tableName,
      item: departmentClassification.toJson(),
    );
  }

  @override
  Future<DepartmentClassification?> getUserDepartmentClassification(
    String challengeId,
    String companyId,
    String companySizeCategory,
    String departmentName,
  ) async {
    String whereCondition = 'challengeId = ? AND name = ?';
    List<dynamic> whereArgs = [challengeId, departmentName];

    var map = await _localDatabase.getData(
      tableName: DepartmentClassification.tableName,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );
    var result = map.map<DepartmentClassification>(
      (json) =>
          DepartmentClassification.fromMap(Map<String, dynamic>.from(json)),
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  @override
  Future<bool?> deleteAccount() async {
    var uid = AppData.user!.uid;
    var listTable = [
      User.tableName,
      UserActivity.tableName,
      ChallengeRegistry.tableName,
      CyclistClassification.tableName,
    ];
    var listWhere = [
      'uid = ?',
      'uid = ?',
      'uid = ?',
      'uid = ?',
    ];
    var listWhereArgs = [
      [uid],
      [uid],
      [uid],
      [uid],
    ];
    await _localDatabase.deleteDataWithBatch(
      listTable: listTable,
      listWhere: listWhere,
      listWhereArgs: listWhereArgs,
    );
    return true;
  }

  @override
  Future<void> setUploadedUserActivity(String userActivityId) async {
    String whereCondition = 'userActivityId = ?';
    List<dynamic> whereArgs = [userActivityId];
    final item = {
      'isUploaded': 1,
      'isSendedToReview': 0,
    };
    await _localDatabase.updateData(
      tableName: UserActivity.tableName,
      item: item,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<UserActivity?> getUserActivity(String userActivityId) async {
    String whereCondition = 'userActivityId = ?';
    List<dynamic> whereArgs = [userActivityId];

    var map = await _localDatabase.getData(
      tableName: UserActivity.tableName,
      whereCondition: whereCondition,
      whereArgs: whereArgs,
    );
    var result = map.map<UserActivity>(
      (json) => UserActivity.fromMap(Map<String, dynamic>.from(json)),
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
