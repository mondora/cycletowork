import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/user_activity_summery.dart';
import 'package:cycletowork/src/utility/gps.dart';

enum DashboardPageOption {
  home,
  startCounter,
  startTracking,
  showMapTracking,
  pauseTracking,
  stopTracking,
}

enum AppBottomNavBarOption {
  home,
  activity,
  classification,
}

enum AppMenuOption {
  home,
  activity,
  classification,
  profile,
  settings,
  information,
  logout,
}

class DashboardUiState {
  bool loading = false;
  bool error = false;
  bool showAppBarAction = true;
  String errorMessage = '';
  int userActivityPage = 0;
  int userActivityPageSize = 50;
  int counter = 5;
  List<UserActivity> listUserActivity = [];
  UserActivitySummery? userActivitySummery;
  LocationData? currentPosition;
  DashboardPageOption dashboardPageOption = DashboardPageOption.home;
  AppBottomNavBarOption? appBottomNavBarOption = AppBottomNavBarOption.home;
  AppMenuOption appMenuOption = AppMenuOption.home;
  GpsStatus gpsStatus = GpsStatus.turnOff;
}
