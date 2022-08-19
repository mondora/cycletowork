import 'dart:async';

import 'package:cycletowork/src/data/location_data.dart' as location_data;
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

enum GpsStatus {
  turnOff,
  turnOn,
  granted,
}

class Gps {
  static Future<GpsStatus> getGpsStatus() async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await isGPSEnabled();
      if (!_serviceEnabled) {
        if (!_serviceEnabled) {
          return GpsStatus.turnOff;
        }
      }

      _permissionGranted = await getPermissionStatus();
      if (_permissionGranted != PermissionStatus.authorizedAlways) {
        _permissionGranted = await requestPermission();
      }

      if (_permissionGranted == PermissionStatus.authorizedAlways) {
        return GpsStatus.turnOn;
      } else {
        return GpsStatus.granted;
      }
    } catch (e) {
      return GpsStatus.turnOff;
    }
  }

  static Future<location_data.LocationData?> getCurrentPosition() async {
    try {
      var result = await getLocation(
        settings: LocationSettings(ignoreLastKnownPosition: true),
      );
      return location_data.LocationData(
        latitude: result.latitude ?? 0,
        longitude: result.longitude ?? 0,
        accuracy: result.accuracy ?? 0,
        altitude: result.altitude ?? 0,
        speed: result.speed ?? 0,
        speedAccuracy: result.speedAccuracy ?? 0,
        bearing: result.bearing ?? 0,
        time: DateTime.now().toLocal().millisecondsSinceEpoch,
      );
    } catch (e) {
      return null;
    }
  }

  static Future initialize() async {
    // await setLocationSettings(
    //   interval: 1000,
    //   fastestInterval: 800,
    // );
  }

  static Future setSettings() async {
    await setLocationSettings(
      interval: 1000,
      fastestInterval: 800,
      accuracy: LocationAccuracy.high,
    );
  }

  static Future setNotificaion({String? title, String? subtitle}) async {
    await updateBackgroundNotification(
      title: title,
      subtitle: subtitle,
      channelName: 'Cycle2Work',
      onTapBringToFront: true,
      iconName: 'ic_notification',
    );
  }

  static Stream<location_data.LocationData> startListenOnBackground() {
    return onLocationChanged(inBackground: true).map(
      (result) {
        return location_data.LocationData(
          latitude: result.latitude ?? 0,
          longitude: result.longitude ?? 0,
          accuracy: result.accuracy ?? 0,
          altitude: result.altitude ?? 0,
          speed: result.speed ?? 0,
          speedAccuracy: result.speedAccuracy ?? 0,
          bearing: result.bearing ?? 0,
          time: DateTime.now().toLocal().millisecondsSinceEpoch,
        );
      },
    );
  }

  static Future<String> getCityName(double latitude, double longitude,
      {String? localeIdentifier}) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
      localeIdentifier: localeIdentifier,
    );
    return placemarks.first.locality ??
        placemarks.first.administrativeArea ??
        '';
  }
}
