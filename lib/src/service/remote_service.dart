import 'package:cycletowork/src/data/app_service.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/user_activity_summery.dart';

class RemoteService implements AppService {
  @override
  Future<bool> isOpenNewChallenge() {
    // TODO: implement isOpenNewChallenge
    throw UnimplementedError();
  }

  @override
  Future saveUserActivity(
    UserActivitySummery userActivitySummery,
    UserActivity userActivity,
    List<LocationData> listLocationData,
  ) async {
    // TODO: implement getListUserActivity
    throw UnimplementedError();
  }

  @override
  Future<List<UserActivity>> getListUserActivity({
    int page = 0,
    int pageSize = 50,
  }) {
    // TODO: implement getListUserActivity
    throw UnimplementedError();
  }

  @override
  Future<UserActivitySummery> getUserActivitySummery() async {
    // TODO: implement getUserActivitySummery
    throw UnimplementedError();
  }

  @override
  Future<bool> isChallengeActivity() {
    // TODO: implement isChallengeActivity
    throw UnimplementedError();
  }
}
