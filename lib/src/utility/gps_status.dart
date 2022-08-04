import 'package:location/location.dart';

enum GpsStatus {
  turnOff,
  turnOn,
  granted,
}

class Gps {
  static Future<GpsStatus> getGpsStatus() async {
    try {
      Location location = Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return GpsStatus.turnOff;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
      }

      if (_permissionGranted != PermissionStatus.granted) {
        return GpsStatus.turnOn;
      } else {
        return GpsStatus.granted;
      }
    } catch (e) {
      return GpsStatus.turnOff;
    }
  }
}
