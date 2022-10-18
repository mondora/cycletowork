import 'package:cycletowork/src/database/local_database_service.dart';
import 'package:cycletowork/src/service/remote_service.dart';

abstract class RepositoryServiceLocator {
  LocalDatabaseService getLocalData();
  RemoteService getRemoteData();
}
