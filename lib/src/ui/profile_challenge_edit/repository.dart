import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/repository_service_locator.dart';
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
    _remoteService = serviceLocator.getRemoteData();
    _localDatabase = serviceLocator.getLocalData();
  }

  Future<bool?> updateUserInfoInChallenge(
    ChallengeRegistry challengeRegistry,
  ) async {
    await _remoteService.updateUserInfoInChallenge(
      challengeRegistry.challengeId,
      challengeRegistry.name,
      challengeRegistry.lastName,
      challengeRegistry.zipCode,
      challengeRegistry.city,
      challengeRegistry.address,
    );
    await _localDatabase.registerChallenge(challengeRegistry);
    return true;
  }
}
