import 'package:localstore/localstore.dart';

class LocalDataSource {
  static final Localstore _database = Localstore.instance;
  static Localstore get database => _database;

  factory LocalDataSource() => LocalDataSource._internal();

  LocalDataSource._internal();
}
