import 'package:cycletowork/src/data/app_service.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/service/remote.dart';

class RemoteService
    implements AppService, AppServiceOnlyRemote, AppAdminService {
  @override
  Future saveUserActivity(
    UserActivity userActivity,
    List<LocationData> listLocationData,
  ) async {
    userActivity.imageData = null;
    var arg = {
      'userActivity': userActivity.toJson(),
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
    return User.fromMap(map);
  }

  @override
  Future<void> saveDeviceToken(String deviceToken) async {
    var arg = {'deviceToken': deviceToken};
    await Remote.callFirebaseFunctions('saveDeviceToken', arg);
  }

  @override
  Future<void> updateUserName(String name) async {
    var arg = {'displayName': name};
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
  Future<List<Company>> getCompanyListNameSearch(String name) async {
    var arg = {'name': name};
    var map =
        await Remote.callFirebaseFunctions('getCompanyListNameSearch', arg);
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
  Future<List<ChallengeRegistry>> getListRegisterdChallenge() async {
    var map =
        await Remote.callFirebaseFunctions('getListRegisterdChallenge', null);
    return map
        .map<ChallengeRegistry>((json) =>
            ChallengeRegistry.fromMap(Map<String, dynamic>.from(json)))
        .toList();
  }
}
