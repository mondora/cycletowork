import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';

enum TrackingOption {
  distance,
  duration,
  avarageSpeed,
  calorie,
  steps,
  maxSpeed,
}

class UiState {
  bool loading = true;
  bool error = false;
  String errorMessage = '';
  UserActivity? userActivity;
  List<LocationData> listLocationData = [];
  String city = '';
}
