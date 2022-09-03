import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/user_activity_summary.dart';

/// Manage Table Database for each version of Database.
class TableDatabase {
  /// Get queries string of create tables.
  ///
  /// [version] is version of database. version should be non-null.
  ///
  /// Return List<String> of queries.
  static List<String> getTables({required int version}) {
    if (version == 1) {
      return [
        User.tableString,
        UserActivitySummary.tableString,
        UserActivity.tableString,
        LocationData.tableString,
        Challenge.tableString,
        ChallengeRegistry.tableString,
      ];
    }
    return [];
  }
}
