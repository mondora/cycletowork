import 'dart:typed_data';

import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/classification.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';

abstract class AppService {
  Future<void> saveDeviceToken(String deviceToken);

  Future<void> removeDeviceToken(String deviceToken);

  Future<bool> registerChallenge(ChallengeRegistry challengeRegistry);

  Future<List<ChallengeRegistry>> getListRegisterdChallenge();

  Future<CyclistClassification?> getUserCyclistClassification(
    String challengeId,
  );

  Future<CompanyClassification?> getUserCompanyClassification(
    String challengeId,
    String companyId,
    String companySizeCategory,
  );

  Future<DepartmentClassification?> getUserDepartmentClassification(
    String challengeId,
    String companyId,
    String companySizeCategory,
    String departmentName,
  );

  Future<bool?> deleteAccount();
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

  Future<List<Company>> getCompanyListNameSearchForChalleng(
    String challengeId,
    String name,
    int oageSize,
  );

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
  Future saveUserActivity(
    UserActivity userActivity,
    List<LocationData> listLocationData,
    List<LocationData> listLocationDataUnFiltered,
  );

  Future<User?> getUserInfo(String uid);

  Future<void> saveUserInfo(User user);

  Future<List<UserActivity>> getListUserActivity({
    int page = 0,
    int pageSize = 50,
  });

  Future<List<LocationData>> getListLocationDataForActivity(
    String userActivityId,
  );

  Future<List<LocationData>> getListLocationDataUnfiltredForActivity(
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

  Future<List<DepartmentClassification>> getListDepartmentClassification(
    String challengeId,
    String companyId, {
    int page = 0,
    int pageSize = 50,
  });

  Future<void> saveDepartmentClassification(
    DepartmentClassification departmentClassification,
  );

  Future<void> setUploadedUserActivity(String userActivityId);

  Future<void> setReviewedUserActivity(String userActivityId);

  Future<UserActivity?> getUserActivity(String userActivityId);

  Future setUserActivityImageData(
    String userActivityId,
    Uint8List value,
  );
}

abstract class AppServiceOnlyRemote {
  Future saveUserActivity(
    UserActivity userActivity,
  );

  Future<bool?> saveUserActivityLocationData(
    UserActivity userActivity,
    List<LocationData> listLocationData,
    List<LocationData> listLocationDataUnFiltred,
  );

  Future<User> getUserInfo();

  Future<void> updateUserDisplayName(String displayName);

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

  Future<Company?> getCompanyFromNameInChallenge(
    String challengeId,
    String companyName,
  );

  Future<List<CompanyClassification>> getListCompanyClassificationByRankingCo2(
    String challengeId,
    String companySizeCategory, {
    int pageSize = 50,
    double? lastCo2,
  });

  Future<List<CompanyClassification>>
      getListCompanyClassificationByRankingPercentRegistered(
    String challengeId,
    String companySizeCategory, {
    int pageSize = 50,
    double? lastPercentRegistered,
  });

  Future<List<CyclistClassification>> getListCyclistClassificationByRankingCo2(
    String challengeId, {
    int pageSize = 50,
    double? lastCo2,
  });

  Future<ChallengeRegistry?> getChallengeRegistryFromBusinessEmail(
    String challengeId,
    String businessEmail,
  );

  Future<List<DepartmentClassification>>
      getListDepartmentClassificationByRankingCo2(
    String challengeId,
    String companySizeCategory,
    String companyId, {
    int pageSize = 50,
    double? lastCo2,
  });

  Future<List<Company>> getCompanyListForChallenge(
    String challengeId,
    int pageSize,
  );

  Future<String?> updateUserPhotoURL(String imagePath, String fileName);

  Future<bool?> updateUserInfoInChallenge(
    String challengeId,
    String newName,
    String newLastName,
    String newZipCode,
    String newCity,
    String newAddress,
  );
}
