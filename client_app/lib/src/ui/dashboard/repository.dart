import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/chart_data.dart';
import 'package:cycletowork/src/data/classification.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';
import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:cycletowork/src/utility/user_auth.dart';
import 'package:cycletowork/src/widget/chart.dart';

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
  final stopDateChallengOffset = const Duration(days: 14);

  Repository() {
    var serviceLocator = ServiceLocator();
    _localDatabase = serviceLocator.getLocalData();
    _remoteService = serviceLocator.getRemoteData();
  }

  Future<ChallengeRegistry?> isChallengeActivity() async {
    var listChallengeIdRegister = AppData.user!.listChallengeIdRegister;

    if (listChallengeIdRegister == null || listChallengeIdRegister.isEmpty) {
      return null;
    }

    var listActiveRegisterChallenge =
        await _localDatabase.getListActiveRegisterChallenge();

    if (listActiveRegisterChallenge.isEmpty) {
      var listRegisterChallenge =
          await _remoteService.getListActiveRegisterdChallenge();
      if (listRegisterChallenge.isEmpty) {
        return null;
      } else {
        for (var element in listRegisterChallenge) {
          await _localDatabase.registerChallenge(element);
        }
        for (var element in listRegisterChallenge) {
          var index = listChallengeIdRegister.indexOf(element.challengeId);
          if (index >= 0) {
            return element;
          }
        }

        return null;
      }
    }

    for (var element in listActiveRegisterChallenge) {
      var index = listChallengeIdRegister.indexOf(element.challengeId);
      if (index >= 0) {
        return element;
      }
    }

    return null;
  }

  Future<List<ChallengeRegistry>> getListChallengeRegistred() async {
    var listChallengeIdRegister = AppData.user!.listChallengeIdRegister;

    if (listChallengeIdRegister == null || listChallengeIdRegister.isEmpty) {
      return [];
    }

    var listRegisterdChallenge =
        await _localDatabase.getListRegisterdChallenge();

    final isContainOpenChallenge = listRegisterdChallenge.any(
      (challenge) =>
          challenge.stopTimeChallenge > DateTime.now().millisecondsSinceEpoch,
    );
    if (listRegisterdChallenge.isNotEmpty && !isContainOpenChallenge) {
      return listRegisterdChallenge;
    }

    var listRegisterChallenge =
        await _remoteService.getListRegisterdChallenge();

    if (listRegisterChallenge.isEmpty) {
      return [];
    }
    for (var element in listRegisterChallenge) {
      await _localDatabase.registerChallenge(element);
    }

    return listRegisterChallenge;
  }

  Future<List<CompanyClassification>> getListCompanyClassificationByRankingCo2(
    ChallengeRegistry challengeRegistry,
    int page,
    int pageSize,
    double? lastCo2,
  ) async {
    var localListCompanyClassification =
        await _localDatabase.getListCompanyClassification(
      challengeRegistry.challengeId,
      page: page,
      pageSize: pageSize,
      orderByRankingCo2: true,
    );

    final stopDateChalleng = DateTime.fromMillisecondsSinceEpoch(
      challengeRegistry.stopTimeChallenge,
    ).add(stopDateChallengOffset).millisecondsSinceEpoch;
    var dateNow = DateTime.now().millisecondsSinceEpoch;
    if (localListCompanyClassification.isNotEmpty &&
        localListCompanyClassification.length > 1 &&
        stopDateChalleng < dateNow &&
        localListCompanyClassification.first.updateDate > stopDateChalleng) {
      return localListCompanyClassification;
    }

    var remoteListCompanyClassification =
        await _remoteService.getListCompanyClassificationByRankingCo2(
      challengeRegistry.challengeId,
      challengeRegistry.companySizeCategory,
      pageSize: pageSize,
      lastCo2: lastCo2,
    );

    if (remoteListCompanyClassification.isEmpty) {
      return [];
    }
    for (var element in remoteListCompanyClassification) {
      await _localDatabase.saveCompanyClassification(element);
    }

    return remoteListCompanyClassification;
  }

  Future<List<CompanyClassification>>
      getListCompanyClassificationByRankingPercentRegistered(
    ChallengeRegistry challengeRegistry,
    int page,
    int pageSize,
    double? lastPercentRegistered,
  ) async {
    var localListCompanyClassification =
        await _localDatabase.getListCompanyClassification(
      challengeRegistry.challengeId,
      page: page,
      pageSize: pageSize,
      orderByRankingCo2: false,
    );

    final stopDateChalleng = DateTime.fromMillisecondsSinceEpoch(
      challengeRegistry.stopTimeChallenge,
    ).add(stopDateChallengOffset).millisecondsSinceEpoch;
    var dateNow = DateTime.now().millisecondsSinceEpoch;
    if (localListCompanyClassification.isNotEmpty &&
        localListCompanyClassification.length > 1 &&
        stopDateChalleng < dateNow &&
        localListCompanyClassification.first.updateDate > stopDateChalleng) {
      return localListCompanyClassification;
    }

    var remoteListCompanyClassification = await _remoteService
        .getListCompanyClassificationByRankingPercentRegistered(
      challengeRegistry.challengeId,
      challengeRegistry.companySizeCategory,
      pageSize: pageSize,
      lastPercentRegistered: lastPercentRegistered,
    );

    if (remoteListCompanyClassification.isEmpty) {
      return [];
    }
    for (var element in remoteListCompanyClassification) {
      await _localDatabase.saveCompanyClassification(element);
    }

    return remoteListCompanyClassification;
  }

  Future<List<CyclistClassification>> getListCyclistClassificationByRankingCo2(
    ChallengeRegistry challengeRegistry,
    int page,
    int pageSize,
    double? lastCo2,
  ) async {
    var localListCyclistClassification =
        await _localDatabase.getListCyclistClassification(
      challengeRegistry.challengeId,
      page: page,
      pageSize: pageSize,
    );

    final stopDateChalleng = DateTime.fromMillisecondsSinceEpoch(
      challengeRegistry.stopTimeChallenge,
    ).add(stopDateChallengOffset).millisecondsSinceEpoch;
    var dateNow = DateTime.now().millisecondsSinceEpoch;
    if (localListCyclistClassification.isNotEmpty &&
        localListCyclistClassification.length > 1 &&
        stopDateChalleng < dateNow &&
        localListCyclistClassification.first.updateDate > stopDateChalleng) {
      return localListCyclistClassification;
    }

    var remoteListCyclistClassification =
        await _remoteService.getListCyclistClassificationByRankingCo2(
      challengeRegistry.challengeId,
      pageSize: pageSize,
      lastCo2: lastCo2,
    );

    if (remoteListCyclistClassification.isEmpty) {
      return [];
    }
    for (var element in remoteListCyclistClassification) {
      await _localDatabase.saveCyclistClassification(element);
    }

    return remoteListCyclistClassification;
  }

  Future<CompanyClassification?> getUserCompanyClassification(
    ChallengeRegistry challengeRegistry,
  ) async {
    var localUserCompanyClassification =
        await _localDatabase.getUserCompanyClassification(
      challengeRegistry.challengeId,
      challengeRegistry.companyId,
      challengeRegistry.companySizeCategory,
    );
    final stopDateChalleng = DateTime.fromMillisecondsSinceEpoch(
      challengeRegistry.stopTimeChallenge,
    ).add(stopDateChallengOffset).millisecondsSinceEpoch;
    var dateNow = DateTime.now().millisecondsSinceEpoch;
    if (localUserCompanyClassification != null &&
        stopDateChalleng < dateNow &&
        localUserCompanyClassification.updateDate > stopDateChalleng) {
      return localUserCompanyClassification;
    }

    var remoteUserCompanyClassification =
        await _remoteService.getUserCompanyClassification(
      challengeRegistry.challengeId,
      challengeRegistry.companyId,
      challengeRegistry.companySizeCategory,
    );

    if (remoteUserCompanyClassification == null) {
      return remoteUserCompanyClassification;
    }
    await _localDatabase.saveCompanyClassification(
      remoteUserCompanyClassification,
    );

    return remoteUserCompanyClassification;
  }

  Future<CyclistClassification?> getUserCyclistClassification(
    ChallengeRegistry challengeRegistry,
  ) async {
    var localUserCyclistClassification =
        await _localDatabase.getUserCyclistClassification(
      challengeRegistry.challengeId,
    );
    final stopDateChalleng = DateTime.fromMillisecondsSinceEpoch(
      challengeRegistry.stopTimeChallenge,
    ).add(stopDateChallengOffset).millisecondsSinceEpoch;
    var dateNow = DateTime.now().millisecondsSinceEpoch;
    if (localUserCyclistClassification != null &&
        stopDateChalleng < dateNow &&
        localUserCyclistClassification.updateDate > stopDateChalleng) {
      return localUserCyclistClassification;
    }

    var remoteUserCyclistClassification =
        await _remoteService.getUserCyclistClassification(
      challengeRegistry.challengeId,
    );

    if (remoteUserCyclistClassification == null) {
      return remoteUserCyclistClassification;
    }
    await _localDatabase.saveCyclistClassification(
      remoteUserCyclistClassification,
    );

    return remoteUserCyclistClassification;
  }

  Future<DepartmentClassification?> getUserDepartmentClassification(
    ChallengeRegistry challengeRegistry,
  ) async {
    var localUserDepartmentClassification =
        await _localDatabase.getUserDepartmentClassification(
      challengeRegistry.challengeId,
      challengeRegistry.companyId,
      challengeRegistry.companySizeCategory,
      challengeRegistry.departmentName,
    );
    final stopDateChalleng = DateTime.fromMillisecondsSinceEpoch(
      challengeRegistry.stopTimeChallenge,
    ).add(stopDateChallengOffset).millisecondsSinceEpoch;
    var dateNow = DateTime.now().millisecondsSinceEpoch;
    if (localUserDepartmentClassification != null &&
        stopDateChalleng < dateNow &&
        localUserDepartmentClassification.updateDate > stopDateChalleng) {
      return localUserDepartmentClassification;
    }

    var remoteUserDepartmentClassification =
        await _remoteService.getUserDepartmentClassification(
      challengeRegistry.challengeId,
      challengeRegistry.companyId,
      challengeRegistry.companySizeCategory,
      challengeRegistry.departmentName,
    );

    if (remoteUserDepartmentClassification == null) {
      return remoteUserDepartmentClassification;
    }
    await _localDatabase.saveDepartmentClassification(
      remoteUserDepartmentClassification,
    );

    return remoteUserDepartmentClassification;
  }

  Future<List<DepartmentClassification>>
      getListDepartmentClassificationByRankingCo2(
    ChallengeRegistry challengeRegistry,
    int page,
    int pageSize,
    double? lastCo2,
  ) async {
    var localListDepartmentClassification =
        await _localDatabase.getListDepartmentClassification(
      challengeRegistry.challengeId,
      challengeRegistry.companyId,
      page: page,
      pageSize: pageSize,
    );

    final stopDateChalleng = DateTime.fromMillisecondsSinceEpoch(
      challengeRegistry.stopTimeChallenge,
    ).add(stopDateChallengOffset).millisecondsSinceEpoch;
    var dateNow = DateTime.now().millisecondsSinceEpoch;
    if (localListDepartmentClassification.isNotEmpty &&
        localListDepartmentClassification.length > 1 &&
        stopDateChalleng < dateNow &&
        localListDepartmentClassification.first.updateDate > stopDateChalleng) {
      return localListDepartmentClassification;
    }

    var remoteListDepartmentClassification =
        await _remoteService.getListDepartmentClassificationByRankingCo2(
      challengeRegistry.challengeId,
      challengeRegistry.companySizeCategory,
      challengeRegistry.companyId,
      pageSize: pageSize,
      lastCo2: lastCo2,
    );

    if (remoteListDepartmentClassification.isEmpty) {
      return [];
    }
    for (var element in remoteListDepartmentClassification) {
      await _localDatabase.saveDepartmentClassification(element);
    }

    return remoteListDepartmentClassification;
  }

  Future<List<UserActivity>> getListUserActivity(
    int page,
    int pageSize,
  ) async {
    try {
      return await _localDatabase.getListUserActivity(
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      Logger.error(e);
      return [];
    }
  }

  Future<List<UserActivity>> getListUserActivityFiltered(
    int page,
    int pageSize,
    bool justChallenges,
    ChartScaleType chartScaleType,
    bool timeFilter,
  ) async {
    try {
      return await _localDatabase.getListUserActivity(
        page: page,
        pageSize: pageSize,
        justChallenges: justChallenges,
        thisWeek: chartScaleType == ChartScaleType.week,
        thisMonth: chartScaleType == ChartScaleType.month,
        thisYear: chartScaleType == ChartScaleType.year,
        timeFilter: timeFilter,
      );
    } catch (e) {
      Logger.error(e);
      return [];
    }
  }

  Future<UserActivity?> refreshUserActivityFromLocal(
    String userActivityId,
  ) async {
    return await _localDatabase.getUserActivity(userActivityId);
  }

  Future<bool> saveUserActivity(
    UserActivity userActivity,
    List<LocationData> listLocationData,
    List<LocationData> listLocationDataUnFiltered,
  ) async {
    try {
      await _localDatabase.saveUserActivity(
        userActivity,
        listLocationData,
        listLocationDataUnFiltered,
      );
    } catch (e) {
      Logger.error(e);
      return false;
    }
    try {
      await _remoteService.saveUserActivity(
        userActivity,
      );
      await _localDatabase.setUploadedUserActivity(
        userActivity.userActivityId,
      );
      return true;
    } catch (e) {
      Logger.error(e);
      return false;
    }
  }

  Future<GpsStatus> getGpsStatus() async {
    return await Gps.getGpsStatus();
  }

  Future<LocationData?> getCurrentPosition(
    String permissionRequestMessage,
  ) async {
    return await Gps.getCurrentPosition();
  }

  Future<List<Challenge>> getActiveChallengeList() async {
    var listChallenge = await _remoteService.getActiveChallengeList();
    if (listChallenge.isNotEmpty) {
      await _localDatabase.saveListChallenge(listChallenge);
    }
    return listChallenge;
  }

  UserActivityChartData getUserActivityChartData(Map args) {
    List<UserActivity> listUserActivity = args['listUserActivity'];
    ChartScaleType chartScaleType = args['chartScaleType'];
    List<ChartData> listCo2ChartData = [];
    List<ChartData> listDistanceChartData = [];

    if (chartScaleType == ChartScaleType.week) {
      for (var offsetDay = 0; offsetDay < 7; offsetDay++) {
        var startDate = DateTime.now().getDateOfThisWeek(offsetDay: offsetDay);
        var endDate =
            DateTime.now().getDateOfThisWeek(offsetDay: offsetDay + 1);

        var userActivitySelected = listUserActivity.where(
          (userActivity) =>
              userActivity.stopTime >= startDate.millisecondsSinceEpoch &&
              userActivity.stopTime < endDate.millisecondsSinceEpoch,
        );
        if (userActivitySelected.isEmpty) {
          listCo2ChartData.add(ChartData(offsetDay, 0));
          listDistanceChartData.add(ChartData(offsetDay, 0));
        } else {
          listCo2ChartData.add(
            ChartData(
              offsetDay,
              userActivitySelected
                  .map((e) => e.co2)
                  .reduce((a, b) => a + b)
                  .gramToKg(),
            ),
          );
          listDistanceChartData.add(
            ChartData(
              offsetDay,
              userActivitySelected
                  .map((e) => e.distance)
                  .reduce((a, b) => a + b)
                  .meterToKm(),
            ),
          );
        }
      }
    }

    if (chartScaleType == ChartScaleType.month) {
      for (var offsetDay = 0; offsetDay < 4; offsetDay++) {
        var dateNow = DateTime.now();
        var beginningNextMonth = (dateNow.month < 12)
            ? DateTime(dateNow.year, dateNow.month + 1, 1)
            : DateTime(dateNow.year + 1, 1, 1);

        var startDate =
            DateTime(dateNow.year, dateNow.month, (1 + (offsetDay * 7)));
        var endDate = offsetDay == 3
            ? DateTime(dateNow.year, beginningNextMonth.month, 1)
            : DateTime(dateNow.year, dateNow.month, (8 + (offsetDay * 7)));

        var userActivitySelected = listUserActivity.where(
          (userActivity) =>
              userActivity.stopTime >= startDate.millisecondsSinceEpoch &&
              userActivity.stopTime < endDate.millisecondsSinceEpoch,
        );
        if (userActivitySelected.isEmpty) {
          listCo2ChartData.add(ChartData(offsetDay, 0));
          listDistanceChartData.add(ChartData(offsetDay, 0));
        } else {
          listCo2ChartData.add(
            ChartData(
              offsetDay,
              userActivitySelected
                  .map((e) => e.co2)
                  .reduce((a, b) => a + b)
                  .gramToKg(),
            ),
          );
          listDistanceChartData.add(
            ChartData(
              offsetDay,
              userActivitySelected
                  .map((e) => e.distance)
                  .reduce((a, b) => a + b)
                  .meterToKm(),
            ),
          );
        }
      }
    }

    if (chartScaleType == ChartScaleType.year) {
      for (var offsetMonth = 0; offsetMonth < 12; offsetMonth++) {
        var dateNow = DateTime.now();

        var startDate = DateTime(dateNow.year, (1 + offsetMonth), 1);
        var endDate = offsetMonth == 11
            ? DateTime(dateNow.year + 1, 1, 1)
            : DateTime(dateNow.year, (1 + (offsetMonth + 1)), 1);

        var userActivitySelected = listUserActivity.where(
          (userActivity) =>
              userActivity.stopTime >= startDate.millisecondsSinceEpoch &&
              userActivity.stopTime < endDate.millisecondsSinceEpoch,
        );
        if (userActivitySelected.isEmpty) {
          listCo2ChartData.add(ChartData(offsetMonth, 0));
          listDistanceChartData.add(ChartData(offsetMonth, 0));
        } else {
          listCo2ChartData.add(
            ChartData(
              offsetMonth,
              userActivitySelected
                  .map((e) => e.co2)
                  .reduce((a, b) => a + b)
                  .gramToKg(),
            ),
          );
          listDistanceChartData.add(
            ChartData(
              offsetMonth,
              userActivitySelected
                  .map((e) => e.distance)
                  .reduce((a, b) => a + b)
                  .meterToKm(),
            ),
          );
        }
      }
    }

    return UserActivityChartData.instance(
      listCo2ChartData,
      listDistanceChartData,
    );
  }

  Future<User> getUserInfo() async {
    var user = await _remoteService.getUserInfo();
    await _localDatabase.saveUserInfo(user);
    return user;
  }

  bool isUserUsedEmailProvider() {
    return UserAuth.isUserUsedEmailProvider();
  }
}
