import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/repository_service_locator.dart';
import 'package:cycletowork/src/data/survey.dart';
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
  late final LocalDatabaseService _localDatabase;

  Repository() {
    var serviceLocator = ServiceLocator();
    _localDatabase = serviceLocator.getLocalData();
    _remoteService = serviceLocator.getRemoteData();
  }

  Future<bool> saveSurveyResponse(
    Challenge challenge,
    SurveyResponse surveyResponse,
  ) async {
    return await _remoteService.saveSurveyResponse(challenge, surveyResponse);
  }

  Future<bool> sendEmailVerificationCode(
    String email,
    String displayName,
  ) async {
    return await _remoteService.sendEmailVerificationCode(email, displayName);
  }

  Future<List<Company>> getCompanyList(
    int pageSize,
    String? lastCompanyName,
  ) async {
    return await _remoteService.getCompanyList(pageSize, lastCompanyName);
  }

  Future<List<Company>> getCompanyListNameSearch(String name) async {
    return await _remoteService.getCompanyListNameSearch(name);
  }

  Future<bool> verifiyEmailCode(
    String email,
    String code,
  ) async {
    return await _remoteService.verifiyEmailCode(email, code);
  }

  Future<bool> registerChallenge(ChallengeRegistry challengeRegistry) async {
    return await _remoteService.registerChallenge(challengeRegistry);
  }
}
