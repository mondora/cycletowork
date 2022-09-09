import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/classification.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';

abstract class AppService {
  Future saveUserActivity(
    UserActivity userActivity,
    List<LocationData> listLocationData,
  );

  Future<void> saveDeviceToken(String deviceToken);

  Future<void> removeDeviceToken(String deviceToken);

  Future<void> updateUserName(String name);

  Future<bool> registerChallenge(ChallengeRegistry challengeRegistry);

  Future<List<ChallengeRegistry>> getListRegisterdChallenge();

  Future<CyclistClassification?> getUserCyclistClassification(
    String challengeId,
  );

  Future<CompanyClassification?> getUserCompanyClassification(
    String challengeId,
    String companyId,
  );
}

abstract class AppAdminService {
  Future<ListUser> getListUserAdmin(
    int pageSize,
    String? nextPageToken,
    String? emailFilter,
  );

  Future<User> getUserInfoAdmin(String uid);

  Future<bool> verifyUserAdmin(String uid);

  Future<bool> setAdminUser(String uid);

  Future<List<Company>> getCompanyList(
    int pageSize,
    String? lastCompanyName,
  );

  Future<bool> saveCompany(Company company);

  Future<bool> updateCompanyAdmin(Company company);

  Future<List<Company>> getCompanyListNameSearch(String name);

  Future<List<Survey>> getSurveyList(
    int pageSize,
    String? lastSurveyName,
  );

  Future<bool> saveSurveyAdmin(Survey survey);

  Future<List<Challenge>> getChallengeListAdmin(
    int pageSize,
    String? lastChallengeName,
  );

  Future<bool> saveChallengeAdmin(Challenge challenge);

  Future<bool> publishChallengeAdmin(Challenge challenge);

  Future<bool> verifyCompanyAdmin(Company company);
}

abstract class AppServiceOnlyLocal {
  Future<User?> getUserInfo(String uid);

  Future<void> saveUserInfo(User user);

  Future<List<UserActivity>> getListUserActivity({
    int page = 0,
    int pageSize = 50,
  });

  Future<List<LocationData>> getListLocationDataForActivity(
    String userActivityId,
  );

  Future<String?> getDeviceToken();

  Future<int?> getDeviceTokenExpireDate();

  Future<String?> getUserUID();

  Future<void> saveListChallenge(List<Challenge> listChallenge);

  Future<List<ChallengeRegistry>> getListActiveRegisterChallenge();

  Future<Challenge?> getChallengeInfo(String challengeId);

  Future<List<CompanyClassification>> getListCompanyClassification(
    String challengeId, {
    int page = 0,
    int pageSize = 50,
    bool orderByRankingCo2 = true,
  });

  Future<List<CyclistClassification>> getListCyclistClassification(
    String challengeId, {
    int page = 0,
    int pageSize = 50,
  });

  Future<void> saveCompanyClassification(
    CompanyClassification companyClassification,
  );

  Future<void> saveCyclistClassification(
    CyclistClassification cyclistClassification,
  );
}

abstract class AppServiceOnlyRemote {
  Future<User> getUserInfo();

  Future<List<UserActivity>> getListUserActivity({
    int pageSize = 50,
    String? startTime,
  });

  Future<bool> saveSurveyResponse(
    Challenge challenge,
    SurveyResponse surveyResponse,
  );

  Future<bool> sendEmailVerificationCode(String email, String displayName);

  Future<bool> verifiyEmailCode(String email, String code);

  Future<List<Challenge>> getActiveChallengeList();

  Future<List<ChallengeRegistry>> getListActiveRegisterdChallenge();

  Future<Company?> getCompanyFromName(String companyName);

  Future<List<CompanyClassification>> getListCompanyClassificationByRankingCo2(
    String challengeId, {
    int pageSize = 50,
    int? lastRankingCo2,
  });

  Future<List<CompanyClassification>>
      getListCompanyClassificationByRankingPercentRegistered(
    String challengeId,
    int companyEmployeesNumber, {
    int pageSize = 50,
    int? lastPercentRegistered,
  });

  Future<List<CyclistClassification>> getListCyclistClassificationByRankingCo2(
    String challengeId, {
    int pageSize = 50,
    int? lastRankingCo2,
  });

  Future<ChallengeRegistry?> getChallengeRegistryFromBusinessEmail(
    String challengeId,
    String businessEmail,
  );
}
