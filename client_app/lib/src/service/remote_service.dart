import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/app_service.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/classification.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/service/remote.dart';
import 'package:cycletowork/src/service/storage.dart';

class RemoteService
    implements AppService, AppServiceOnlyRemote, AppAdminService {
  @override
  Future saveUserActivity(
    UserActivity userActivity,
  ) async {
    final userActivityJson = userActivity.toJson();
    userActivityJson['imageData'] = null;
    userActivityJson['isUploaded'] = 1;
    var arg = {
      'userActivity': userActivityJson,
    };
    await Remote.callFirebaseFunctions('saveUserActivity', arg);
  }

  @override
  Future<List<UserActivity>> getListUserActivity({
    int pageSize = 50,
    String? startTime,
  }) async {
    var arg = {
      'pagination': {
        'pageSize': pageSize,
        'startTime': startTime,
      }
    };
    var map = await Remote.callFirebaseFunctions('getListUserActivity', arg);
    return map
        .map<UserActivity>(
            (json) => UserActivity.fromMap(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<User> getUserInfo() async {
    var map = await Remote.callFirebaseFunctions('getUserInfo', null);
    return User.fromMap(Map<String, dynamic>.from(map));
  }

  @override
  Future<void> saveDeviceToken(String deviceToken) async {
    var arg = {'deviceToken': deviceToken};
    await Remote.callFirebaseFunctions('saveDeviceToken', arg);
  }

  @override
  Future<void> updateUserDisplayName(String displayName) async {
    var arg = {'displayName': displayName};
    await Remote.callFirebaseFunctions('updateUserInfo', arg);
  }

  @override
  Future<ListUser> getListUserAdmin(
    int pageSize,
    String? nextPageToken,
    String? emailFilter,
  ) async {
    var arg = {
      'pagination': {
        'pageSize': pageSize,
        'nextPageToken': nextPageToken,
      },
      'filter': {
        'email': emailFilter,
      }
    };
    var map = await Remote.callFirebaseFunctions('getListUserAdmin', arg);
    return ListUser.fromMap(map);
  }

  @override
  Future<User> getUserInfoAdmin(String uid) async {
    var arg = {'uid': uid};
    var map = await Remote.callFirebaseFunctions('getUserInfoAdmin', arg);
    return User.fromMap(map);
  }

  @override
  Future<bool> verifyUserAdmin(String uid) async {
    var arg = {'uid': uid};
    return await Remote.callFirebaseFunctions('verifyUserAdmin', arg);
  }

  @override
  Future<bool> setAdminUser(String uid) async {
    var arg = {'uid': uid};
    return await Remote.callFirebaseFunctions('setAdminUser', arg);
  }

  @override
  Future<List<Company>> getCompanyList(
    int pageSize,
    String? lastCompanyName,
  ) async {
    var arg = {
      'pagination': {
        'pageSize': pageSize,
        'lastCompanyName': lastCompanyName,
      }
    };
    List map = await Remote.callFirebaseFunctions('getCompanyList', arg);
    return map
        .map<Company>(
            (json) => Company.fromMap(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<bool> saveCompany(Company company) async {
    var arg = {'company': company.toJson()};
    return await Remote.callFirebaseFunctions('saveCompany', arg);
  }

  @override
  Future<bool> updateCompanyAdmin(Company company) async {
    var arg = {'company': company.toJson()};
    return await Remote.callFirebaseFunctions('updateCompanyAdmin', arg);
  }

  @override
  Future<List<Company>> getCompanyListNameSearchForChalleng(
      String challengeId, String name, int pageSize) async {
    var arg = {
      'pagination': {
        'pageSize': pageSize,
      },
      'challengeId': challengeId,
      'name': name,
    };
    var map = await Remote.callFirebaseFunctions(
        'getCompanyListNameSearchForChalleng', arg);
    return map
        .map<Company>(
            (json) => Company.fromMap(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<List<Survey>> getSurveyList(
    int pageSize,
    String? lastSurveyName,
  ) async {
    var arg = {
      'pagination': {
        'pageSize': pageSize,
        'lastSurveyName': lastSurveyName,
      }
    };
    var map = await Remote.callFirebaseFunctions('getSurveyList', arg);
    return map.map<Survey>((json) => Survey.fromMap(json)).toList();
  }

  @override
  Future<bool> saveSurveyAdmin(Survey survey) async {
    var arg = {'survey': survey.toJson()};
    return await Remote.callFirebaseFunctions('saveSurveyAdmin', arg);
  }

  @override
  Future<List<Challenge>> getChallengeListAdmin(
    int pageSize,
    String? lastChallengeName,
  ) async {
    var arg = {
      'pagination': {
        'pageSize': pageSize,
        'lastChallengeName': lastChallengeName,
      }
    };
    var map = await Remote.callFirebaseFunctions('getChallengeListAdmin', arg);
    return map.map<Challenge>((json) => Challenge.fromMap(json)).toList();
  }

  @override
  Future<bool> saveChallengeAdmin(Challenge challenge) async {
    var arg = {'challenge': challenge.toJson()};
    return await Remote.callFirebaseFunctions('saveChallengeAdmin', arg);
  }

  @override
  Future<bool> publishChallengeAdmin(Challenge challenge) async {
    var arg = {'challenge': challenge.toJson()};
    return await Remote.callFirebaseFunctions('publishChallengeAdmin', arg);
  }

  @override
  Future<List<Challenge>> getActiveChallengeList() async {
    var map =
        await Remote.callFirebaseFunctions('getActiveChallengeList', null);
    return map.map<Challenge>((json) => Challenge.fromMap(json)).toList();
  }

  @override
  Future<bool> saveSurveyResponse(
    Challenge challenge,
    SurveyResponse surveyResponse,
  ) async {
    var arg = {
      'challenge': challenge.toJson(),
      'surveyResponse': surveyResponse.toJson(),
    };
    return await Remote.callFirebaseFunctions('saveSurveyResponse', arg);
  }

  @override
  Future<bool> verifyCompanyAdmin(Company company) async {
    var arg = {'company': company.toJson()};
    return await Remote.callFirebaseFunctions('verifyCompanyAdmin', arg);
  }

  @override
  Future<bool> sendEmailVerificationCode(
    String email,
    String displayName,
  ) async {
    var arg = {'email': email, 'displayName': displayName};
    return await Remote.callFirebaseFunctions('sendEmailVerificationCode', arg);
  }

  @override
  Future<bool> verifiyEmailCode(String email, String code) async {
    var arg = {'email': email, 'code': code};
    return await Remote.callFirebaseFunctions('verifiyEmailCode', arg);
  }

  @override
  Future<bool> registerChallenge(ChallengeRegistry challengeRegistry) async {
    var arg = {'challengeRegistry': challengeRegistry.toJson()};
    return await Remote.callFirebaseFunctions('registerChallenge', arg);
  }

  @override
  Future<void> removeDeviceToken(String deviceToken) async {
    var arg = {'deviceToken': deviceToken};
    await Remote.callFirebaseFunctions('removeDeviceToken', arg);
  }

  @override
  Future<List<ChallengeRegistry>> getListActiveRegisterdChallenge() async {
    var map = await Remote.callFirebaseFunctions(
        'getListActiveRegisterdChallenge', null);
    return map
        .map<ChallengeRegistry>((json) =>
            ChallengeRegistry.fromMap(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<Company?> getCompanyFromNameInChallenge(
    String challengeId,
    String companyName,
  ) async {
    var arg = {
      'challengeId': challengeId,
      'companyName': companyName,
    };
    var map = await Remote.callFirebaseFunctions(
      'getCompanyFromNameInChallenge',
      arg,
    );
    return map != null ? Company.fromMap(Map<String, dynamic>.from(map)) : null;
  }

  @override
  Future<List<ChallengeRegistry>> getListRegisterdChallenge() async {
    var map =
        await Remote.callFirebaseFunctions('getListRegisterdChallenge', null);
    return map
        .map<ChallengeRegistry>((json) =>
            ChallengeRegistry.fromMap(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<List<CompanyClassification>> getListCompanyClassificationByRankingCo2(
    String challengeId,
    String companySizeCategory, {
    int pageSize = 50,
    double? lastCo2,
  }) async {
    var arg = {
      'challengeId': challengeId,
      'companySizeCategory': companySizeCategory,
      'pagination': {
        'pageSize': pageSize,
        'lastCo2': lastCo2,
      }
    };
    var map = await Remote.callFirebaseFunctions(
      'getListCompanyClassificationByRankingCo2',
      arg,
    );
    return map
        .map<CompanyClassification>(
          (json) =>
              CompanyClassification.fromMap(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  @override
  Future<List<CompanyClassification>>
      getListCompanyClassificationByRankingPercentRegistered(
    String challengeId,
    String companySizeCategory, {
    int pageSize = 50,
    double? lastPercentRegistered,
  }) async {
    var arg = {
      'challengeId': challengeId,
      'companySizeCategory': companySizeCategory,
      'pagination': {
        'pageSize': pageSize,
        'lastPercentRegistered': lastPercentRegistered,
      }
    };
    var map = await Remote.callFirebaseFunctions(
      'getListCompanyClassificationByRankingPercentRegistered',
      arg,
    );
    return map
        .map<CompanyClassification>(
          (json) =>
              CompanyClassification.fromMap(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  @override
  Future<List<CyclistClassification>> getListCyclistClassificationByRankingCo2(
    String challengeId, {
    int pageSize = 50,
    double? lastCo2,
  }) async {
    var arg = {
      'challengeId': challengeId,
      'pagination': {
        'pageSize': pageSize,
        'lastCo2': lastCo2,
      }
    };
    var map = await Remote.callFirebaseFunctions(
      'getListCyclistClassificationByRankingCo2',
      arg,
    );
    return map
        .map<CyclistClassification>(
          (json) =>
              CyclistClassification.fromMap(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  @override
  Future<CompanyClassification?> getUserCompanyClassification(
    String challengeId,
    String companyId,
    String companySizeCategory,
  ) async {
    var arg = {
      'challengeId': challengeId,
      'companyId': companyId,
      'companySizeCategory': companySizeCategory,
    };
    var map =
        await Remote.callFirebaseFunctions('getUserCompanyClassification', arg);
    return map != null
        ? CompanyClassification.fromMap(Map<String, dynamic>.from(map))
        : null;
  }

  @override
  Future<CyclistClassification?> getUserCyclistClassification(
    String challengeId,
  ) async {
    var arg = {
      'challengeId': challengeId,
    };
    var map =
        await Remote.callFirebaseFunctions('getUserCyclistClassification', arg);
    return map != null
        ? CyclistClassification.fromMap(Map<String, dynamic>.from(map))
        : null;
  }

  @override
  Future<ChallengeRegistry?> getChallengeRegistryFromBusinessEmail(
    String challengeId,
    String businessEmail,
  ) async {
    var arg = {
      'challengeId': challengeId,
      'businessEmail': businessEmail,
    };
    var map = await Remote.callFirebaseFunctions(
        'getChallengeRegistryFromBusinessEmail', arg);
    return map != null
        ? ChallengeRegistry.fromMap(Map<String, dynamic>.from(map))
        : null;
  }

  @override
  Future<List<DepartmentClassification>>
      getListDepartmentClassificationByRankingCo2(
    String challengeId,
    String companySizeCategory,
    String companyId, {
    int pageSize = 50,
    double? lastCo2,
  }) async {
    var arg = {
      'challengeId': challengeId,
      'companySizeCategory': companySizeCategory,
      'companyId': companyId,
      'pagination': {
        'pageSize': pageSize,
        'lastCo2': lastCo2,
      }
    };
    var map = await Remote.callFirebaseFunctions(
      'getListDepartmentClassificationByRankingCo2',
      arg,
    );
    return map
        .map<DepartmentClassification>(
          (json) =>
              DepartmentClassification.fromMap(Map<String, dynamic>.from(json)),
        )
        .toList();
  }

  @override
  Future<DepartmentClassification?> getUserDepartmentClassification(
    String challengeId,
    String companyId,
    String companySizeCategory,
    String departmentName,
  ) async {
    var arg = {
      'challengeId': challengeId,
      'companyId': companyId,
      'companySizeCategory': companySizeCategory,
      'departmentName': departmentName,
    };
    var map = await Remote.callFirebaseFunctions(
      'getUserDepartmentClassification',
      arg,
    );
    return map != null
        ? DepartmentClassification.fromMap(Map<String, dynamic>.from(map))
        : null;
  }

  @override
  Future<List<Company>> getCompanyListForChallenge(
    String challengeId,
    int pageSize,
  ) async {
    var arg = {
      'pagination': {
        'pageSize': pageSize,
      },
      'challengeId': challengeId
    };
    var map =
        await Remote.callFirebaseFunctions('getCompanyListForChallenge', arg);
    return map
        .map<Company>(
            (json) => Company.fromMap(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<bool?> deleteAccount() async {
    await Remote.callFirebaseFunctions('deleteAccount', null);
    return true;
  }

  @override
  Future<String?> updateUserPhotoURL(
    String imagePath,
    String fileName,
  ) async {
    Map<String, String> customMetadata = {
      'uid': AppData.user!.uid,
    };
    var photoURL = await Storage.saveImageInStorage(
      imagePath,
      fileName,
      customMetadata: customMetadata,
    );
    var arg = {'photoURL': photoURL};
    await Remote.callFirebaseFunctions('updateUserInfo', arg);
    return photoURL;
  }

  @override
  Future<bool?> updateUserInfoInChallenge(
    String challengeId,
    String newName,
    String newLastName,
    String newZipCode,
    String newCity,
    String newAddress,
  ) async {
    var arg = {
      'challengeId': challengeId,
      'name': newName,
      'lastName': newLastName,
      'zipCode': newZipCode,
      'city': newCity,
      'address': newAddress,
    };
    return await Remote.callFirebaseFunctions('updateUserInfoInChallenge', arg);
  }

  @override
  Future<bool?> saveUserActivityLocationData(
    UserActivity userActivity,
    List<LocationData> listLocationData,
    List<LocationData> listLocationDataUnFiltred,
  ) async {
    final userActivityJson = userActivity.toJson();
    userActivityJson['imageData'] = null;
    userActivityJson['isSendedToReview'] = 1;
    var arg = {
      'userActivity': userActivityJson,
      'listLocationData': listLocationData.map((e) => e.toJson()).toList(),
      'listLocationDataUnFiltred':
          listLocationDataUnFiltred.map((e) => e.toJson()).toList(),
    };
    final result = await Remote.callFirebaseFunctions(
      'saveUserActivityLocationData',
      arg,
    );
    return result == true;
  }

  @override
  Future<bool> checkUserActivityAdmin() async {
    final result = await Remote.callFirebaseFunctions(
      'checkUserActivityAdmin',
      null,
    );
    return result == true;
  }

  @override
  Future saveUserActivityAdmin(UserActivity userActivity) async {
    final userActivityJson = userActivity.toJson();
    userActivityJson['imageData'] = null;
    userActivityJson['isUploaded'] = 1;
    userActivityJson['isInsertFromAdmin'] = 1;
    var arg = {
      'userActivity': userActivityJson,
    };
    await Remote.callFirebaseFunctions('saveUserActivityAdmin', arg);
  }
}
