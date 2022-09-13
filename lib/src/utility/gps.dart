import 'dart:async';

import 'package:cycletowork/src/data/location_data.dart' as location_data;
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as location;

enum GpsStatus {
  turnOff,
  turnOn,
  granted,
}

/// Status of a permission request to use location services.
enum PermissionStatus {
  /// User has not yet made a choice with regards to this application
  notDetermined,

  /// This application is not authorized to use precise
  restricted,

  /// User has explicitly denied authorization for this application, or
  /// location services are disabled in Settings.
  denied,

  /// User has granted authorization to use their location at any
  /// time. Your app may be launched into the background by
  /// monitoring APIs such as visit monitoring, region monitoring,
  /// and significant location change monitoring.
  authorizedAlways,

  /// User has granted authorization to use their location only while
  /// they are using your app.
  authorizedWhenInUse,
}

class Gps {
  static Future<GpsStatus> getGpsStatus() async {
    try {
      var isGPSEnabled = await location.isGPSEnabled();
      if (!isGPSEnabled) {
        return GpsStatus.turnOff;
      }

      location.PermissionStatus permissionStatus =
          await location.getPermissionStatus();
      if (permissionStatus == location.PermissionStatus.notDetermined) {
        permissionStatus = await location.requestPermission();
      }
      if (permissionStatus == location.PermissionStatus.authorizedAlways ||
          permissionStatus == location.PermissionStatus.authorizedWhenInUse) {
        return GpsStatus.granted;
      } else {
        return GpsStatus.turnOn;
      }
    } catch (e) {
      return GpsStatus.turnOff;
    }
  }

  static Future<PermissionStatus> getPermissionStatus() async {
    location.PermissionStatus permissionStatus =
        await location.getPermissionStatus();
    if (permissionStatus == location.PermissionStatus.notDetermined) {
      permissionStatus = await location.requestPermission();
    }
    return PermissionStatus.values
        .firstWhere((element) => element.name == permissionStatus.name);
  }

  static Future<location_data.LocationData?> getCurrentPosition() async {
    try {
      var result = await location.getLocation(
        settings: location.LocationSettings(ignoreLastKnownPosition: true),
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

  static Future initialize() async {}

  static Future setSettings({
    double smallestDisplacement = 0,
    required String permissionRequestMessage,
  }) async {
    await location.setLocationSettings(
      interval: 1000,
      fastestInterval: 1000,
      accuracy: location.LocationAccuracy.high,
      smallestDisplacement: smallestDisplacement,
      rationaleMessageForPermissionRequest: permissionRequestMessage,
      rationaleMessageForGPSRequest: permissionRequestMessage,
    );
  }

  static Future setNotificaion({String? title, String? subtitle}) async {
    await location.updateBackgroundNotification(
      title: title,
      subtitle: subtitle,
      channelName: 'Cycle2Work',
      onTapBringToFront: true,
      iconName: 'ic_notification',
    );
  }

  static Stream<location_data.LocationData> startListenOnBackground() {
    return location.onLocationChanged(inBackground: true).map(
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
