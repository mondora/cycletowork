import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/classification.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';

/// Manage Table Database for each version of Database.
class TableDatabase {
  /// Get queries string of create tables.
  ///
  /// [version] is version of database. version should be non-null.
  ///
  /// Return List<String> of queries.
  static List<String> getTables() {
    return [
      User.tableString,
      UserActivity.tableString,
      LocationData.tableString,
      Challenge.tableString,
      ChallengeRegistry.tableString,
      CompanyClassification.tableString,
      CyclistClassification.tableString,
      DepartmentClassification.tableString,
    ];
  }

  static List<String> getAlterTablesV1ToV2() {
    List<String> list = [];
    list.addAll(LocationData.alterTableV1ToV2);
    return list;
  }

  static List<String> getAlterTablesV2ToV3() {
    List<String> list = [];
    list.addAll(UserActivity.alterTableV2ToV3);
    return list;
  }
}
