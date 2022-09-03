import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/chart_data.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/data/user_activity_summary.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/widget/chart.dart';

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

class UiState {
  bool loading = false;
  bool error = false;
  bool showAppBarAction = true;
  String errorMessage = '';
  int userActivityPage = 0;
  int userActivityPageSize = 50;
  int counter = 5;
  bool userActivityFilteredJustChallenges = false;
  ChartScaleType userActivityFilteredChartScaleType = ChartScaleType.week;
  int userActivityFilteredPage = 0;
  int userActivityFilteredPageSize = 50;
  List<UserActivity> listUserActivity = [];
  List<UserActivity> listUserActivityFiltered = [];
  UserActivityChartData userActivityChartData = UserActivityChartData();
  UserActivitySummary? userActivitySummary;
  LocationData? currentPosition;
  DashboardPageOption dashboardPageOption = DashboardPageOption.home;
  AppBottomNavBarOption? appBottomNavBarOption = AppBottomNavBarOption.home;
  AppMenuOption appMenuOption = AppMenuOption.home;
  GpsStatus gpsStatus = GpsStatus.turnOff;
  List<Challenge> listChallengeActive = [];
}

class UserActivityChartData {
  List<ChartData> listCo2ChartData = [];
  List<ChartData> listDistanceChartData = [];

  UserActivityChartData();

  factory UserActivityChartData.instance(
    List<ChartData> listCo2ChartData,
    List<ChartData> listDistanceChartData,
  ) {
    var userActivityChartData = UserActivityChartData();
    userActivityChartData.listCo2ChartData = listCo2ChartData;
    userActivityChartData.listDistanceChartData = listDistanceChartData;
    return userActivityChartData;
  }
}
