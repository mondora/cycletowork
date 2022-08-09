import 'package:cycletowork/src/utility/location_data.dart' as locationData;
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

  static Future<locationData.LocationData?> getCurrentPosition() async {
    try {
      var location = Location();
      var result = await location.getLocation();
      return locationData.LocationData(
        latitude: result.latitude,
        longitude: result.longitude,
        accuracy: result.accuracy,
        altitude: result.altitude,
        speed: result.speed,
        speedAccuracy: result.speedAccuracy,
        heading: result.heading,
        time: result.time,
        isMock: result.isMock,
      );
    } catch (e) {
      return null;
    }
  }
}
