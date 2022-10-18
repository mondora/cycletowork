import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';

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

  Repository() {
    var serviceLocator = ServiceLocator();
    _remoteService = serviceLocator.getRemoteData();
  }

  Future<ListUser> getListUser(
    int pageSize,
    String? nextPageToken,
    String? emailFilte,
  ) async {
    return await _remoteService.getListUserAdmin(
      pageSize,
      nextPageToken,
      emailFilte,
    );
  }

  Future<User> getUserInfo(String uid) async {
    return await _remoteService.getUserInfoAdmin(uid);
  }

  Future<List<Company>> getCompanyList(
    int pageSize,
    String? lastCompanyName,
  ) async {
    return await _remoteService.getCompanyList(pageSize, lastCompanyName);
  }

  Future<bool> saveCompany(Company company) async {
    return await _remoteService.saveCompany(company);
  }

  Future<bool> updateCompany(Company company) async {
    return await _remoteService.updateCompanyAdmin(company);
  }

  Future<List<Company>> getCompanyListNameSearchForChalleng(
    String challengeId,
    String name,
    int pageSize,
  ) async {
    return await _remoteService.getCompanyListNameSearchForChalleng(
      challengeId,
      name,
      pageSize,
    );
  }

  Future<List<Survey>> getSurveyList(
    int pageSize,
    String? lastSurveyName,
  ) async {
    return await _remoteService.getSurveyList(pageSize, lastSurveyName);
  }

  Future<bool> saveSurvey(Survey survey) async {
    return await _remoteService.saveSurveyAdmin(survey);
  }

  Future<List<Challenge>> getChallengeList(
    int pageSize,
    String? lastChallengeName,
  ) async {
    return await _remoteService.getChallengeListAdmin(
      pageSize,
      lastChallengeName,
    );
  }

  Future<bool> saveChallenge(Challenge challenge) async {
    return await _remoteService.saveChallengeAdmin(challenge);
  }

  Future<bool> publishChallenge(Challenge challenge) async {
    return await _remoteService.publishChallengeAdmin(challenge);
  }

  Future<bool> verifyCompany(Company company) async {
    return await _remoteService.verifyCompanyAdmin(company);
  }
}
