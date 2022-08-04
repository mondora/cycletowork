import 'remote_data_source.dart';

import 'local_data_source.dart';

abstract class Repository {
  late final LocalDataSource localDataSource;
  late final RemoteDataSource remoteDataSource;

  getData(bool? refresh);
}
