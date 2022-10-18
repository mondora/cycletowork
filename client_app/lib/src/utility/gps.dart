import 'dart:async';

import 'package:cycletowork/src/data/location_data.dart' as location_data;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as location;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

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
  static location.LocationSettings? locationSettings;
  static location.ForegroundNotificationConfig? foregroundNotificationConfig;

  static Future<GpsStatus> getGpsStatus() async {
    try {
      var isGPSEnabled = await location.Geolocator.isLocationServiceEnabled();
      if (!isGPSEnabled) {
        return GpsStatus.turnOff;
      }

      location.LocationPermission permissionStatus =
          await location.Geolocator.checkPermission();
      if (permissionStatus == location.LocationPermission.whileInUse ||
          permissionStatus == location.LocationPermission.always) {
        return GpsStatus.granted;
      } else {
        return GpsStatus.turnOn;
      }
    } catch (e) {
      return GpsStatus.turnOff;
    }
  }

  static Future<PermissionStatus> getPermissionStatus() async {
    location.LocationPermission permissionStatus =
        await location.Geolocator.checkPermission();
    if (permissionStatus == location.LocationPermission.unableToDetermine ||
        permissionStatus == location.LocationPermission.denied) {
      permissionStatus = await location.Geolocator.requestPermission();
    }

    switch (permissionStatus) {
      case location.LocationPermission.denied:
        return PermissionStatus.denied;
      case location.LocationPermission.deniedForever:
        return PermissionStatus.denied;
      case location.LocationPermission.whileInUse:
        return PermissionStatus.authorizedWhenInUse;
      case location.LocationPermission.always:
        return PermissionStatus.authorizedAlways;
      case location.LocationPermission.unableToDetermine:
        return PermissionStatus.notDetermined;
    }
  }

  static Future<location_data.LocationData?> getCurrentPosition() async {
    try {
      final result = await location.Geolocator.getCurrentPosition(
        desiredAccuracy: location.LocationAccuracy.best,
        forceAndroidLocationManager: false,
        timeLimit: const Duration(milliseconds: 5000),
      );
      return location_data.LocationData(
        latitude: result.latitude,
        longitude: result.longitude,
        accuracy: result.accuracy,
        altitude: result.altitude,
        speed: result.speed,
        speedAccuracy: result.speedAccuracy,
        bearing: result.heading,
        time: result.timestamp != null
            ? result.timestamp!.toLocal().millisecondsSinceEpoch
            : DateTime.now().toLocal().millisecondsSinceEpoch,
      );
    } catch (e) {
      return null;
    }
  }

  static Future initialize() async {}

  static Future setSettings({
    int smallestDisplacement = 0,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = location.AndroidSettings(
        accuracy: location.LocationAccuracy.best,
        distanceFilter: smallestDisplacement,
        forceLocationManager: false,
        intervalDuration: const Duration(milliseconds: 1000),
        foregroundNotificationConfig: foregroundNotificationConfig,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = location.AppleSettings(
        accuracy: location.LocationAccuracy.bestForNavigation,
        activityType: location.ActivityType.fitness,
        distanceFilter: smallestDisplacement,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = location.LocationSettings(
        accuracy: location.LocationAccuracy.best,
        distanceFilter: smallestDisplacement,
      );
    }
  }

  static Future clearSettings() async {
    locationSettings = null;
  }

  static Future setNotificaion({
    required String title,
    required String subtitle,
  }) async {
    foregroundNotificationConfig = location.ForegroundNotificationConfig(
      notificationText: subtitle,
      notificationTitle: title,
      enableWakeLock: true,
      notificationIcon: const location.AndroidResource(
        name: 'ic_notification',
      ),
    );
  }

  static Future clearNotificaion() async {
    foregroundNotificationConfig = null;
  }

  static Stream<location_data.LocationData> startListenOnBackground() {
    return location.Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).map(
      (result) {
        return location_data.LocationData(
          latitude: result.latitude,
          longitude: result.longitude,
          accuracy: result.accuracy,
          altitude: result.altitude,
          speed: result.speed,
          speedAccuracy: result.speedAccuracy,
          bearing: result.heading,
          time: result.timestamp != null
              ? result.timestamp!.toLocal().millisecondsSinceEpoch
              : DateTime.now().toLocal().millisecondsSinceEpoch,
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
