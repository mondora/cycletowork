import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/chart_data.dart';
import 'package:cycletowork/src/data/classification.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
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
  bool refreshLocationLoading = false;
  bool refreshClassificationLoading = false;
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
  LocationData? currentPosition;
  DashboardPageOption dashboardPageOption = DashboardPageOption.home;
  AppBottomNavBarOption? appBottomNavBarOption = AppBottomNavBarOption.home;
  AppMenuOption appMenuOption = AppMenuOption.home;
  GpsStatus gpsStatus = GpsStatus.turnOff;
  List<Challenge> listChallengeActive = [];
  List<ChallengeRegistry> listChallengeRegistred = [];
  ChallengeRegistry? challengeRegistrySelected;

  bool listCompanyClassificationOrderByRankingCo2 = true;
  List<CompanyClassification> listCompanyClassificationRankingCo2 = [];
  double? lastCompanyClassificationCo2;
  int listCompanyClassificationRankingCo2PageSize = 20;
  int listCompanyClassificationRankingCo2Page = 0;

  List<CompanyClassification> listCompanyClassificationRankingRegistered = [];
  double? lastCompanyClassificationPercentRegistered;
  int listCompanyClassificationRankingRegisteredPageSize = 20;
  int listCompanyClassificationRankingRegisteredPage = 0;
  CompanyClassification? userCompanyClassification;

  List<CyclistClassification> listCyclistClassification = [];
  double? lastCyclistClassificationCo2;
  int listCyclistClassificationPageSize = 20;
  int listCyclistClassificationPage = 0;
  CyclistClassification? userCyclistClassification;

  List<DepartmentClassification> listDepartmentClassification = [];
  double? lastDepartmentClassificationCo2;
  int listDepartmentClassificationPageSize = 20;
  int listDepartmentClassificationPage = 0;
  DepartmentClassification? userDepartmentClassification;
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
