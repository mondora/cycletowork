import 'dart:async';

import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/ui/dashboard/widget/bottom_nav_bar.dart';
import 'package:cycletowork/src/ui/dashboard/widget/drawer.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/utility/location_data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum DashboardViewModelStatus {
  loading,
  ended,
  error,
}

class DashboardViewModel extends ChangeNotifier {
  final ignoreAppBarActionPages = [
    AppMenuOption.profile,
  ];
  static final initialLatitude = 45.50315189900018;
  static final initialLongitude = 9.198330425060847;

  DashboardViewModelStatus _status = DashboardViewModelStatus.loading;
  DashboardViewModelStatus get status => _status;

  AppMenuOption _appMenuOption = AppMenuOption.home;
  AppMenuOption get appMenuOption => _appMenuOption;

  AppBottomNavBarOption? _appBottomNavBarOption = AppBottomNavBarOption.home;
  AppBottomNavBarOption? get appBottomNavBarOption => _appBottomNavBarOption;

  bool _showAppBarAction = true;
  bool get showAppBarAction => _showAppBarAction;

  GpsStatus _gpsStatus = GpsStatus.turnOff;
  GpsStatus get gpsStatus => _gpsStatus;

  LocationData? _currentPosition;
  LocationData? get currentPosition => _currentPosition;

  // final Completer<GoogleMapController> _controller = Completer();
  // Completer<GoogleMapController> get controller => _controller;

  // final LatLng? _target;
  // LatLng? get target => _target;

  List<UserActivity> _userActivity = [];
  List<UserActivity> get userActivity => _userActivity;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  DashboardViewModel() : this.instance();

  DashboardViewModel.instance() {
    getter();
  }

  void getter() async {
    _status = DashboardViewModelStatus.loading;
    notifyListeners();
    try {
      _userActivity = await getUserActivity();
      _currentPosition = await _getCurrentLocation();

      _status = DashboardViewModelStatus.ended;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(_errorMessage);
      _status = DashboardViewModelStatus.error;
      notifyListeners();
      return;
    }
  }

  void refreshLocation() async {
    _status = DashboardViewModelStatus.loading;
    notifyListeners();
    try {
      _currentPosition = await _getCurrentLocation();
      _status = DashboardViewModelStatus.ended;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(_errorMessage);
      _status = DashboardViewModelStatus.error;
      notifyListeners();
      return;
    }
  }

  Future<LocationData?> _getCurrentLocation() async {
    if (_gpsStatus != GpsStatus.granted) {
      _gpsStatus = await Gps.getGpsStatus();
    }
    if (_gpsStatus != GpsStatus.granted) {
      return null;
    }

    var result = await Gps.getCurrentPosition();
    if (result == null || result.latitude == null || result.longitude == null) {
      return null;
    }

    return result;
  }

  Future<List<UserActivity>> getUserActivity() async {
    var list = [
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
    ];
    await Future.delayed(Duration(seconds: 1));
    return list;
  }

  void changePageFromMenu(AppMenuOption appMenuOption) {
    _appMenuOption = appMenuOption;
    _showAppBarAction = _checkShowAppBarAction(appMenuOption);
    var findBottomNavBarOption = AppBottomNavBarOption.values.where(
      (x) => x.name == appMenuOption.name,
    );
    _appBottomNavBarOption =
        findBottomNavBarOption.isNotEmpty ? findBottomNavBarOption.first : null;
    notifyListeners();
  }

  void changePageFromBottomNavigation(
    AppBottomNavBarOption appBottomNavBarOption,
  ) {
    _appBottomNavBarOption = appBottomNavBarOption;
    var findMenuOption = AppMenuOption.values
        .firstWhere((x) => x.name == appBottomNavBarOption.name);
    _appMenuOption = findMenuOption;
    _showAppBarAction = _checkShowAppBarAction(findMenuOption);
    notifyListeners();
  }

  bool _checkShowAppBarAction(AppMenuOption appMenuOption) =>
      !ignoreAppBarActionPages.any((element) => element == appMenuOption);

  void clearError() {
    _status = DashboardViewModelStatus.ended;
    _errorMessage = '';
    notifyListeners();
  }
}
