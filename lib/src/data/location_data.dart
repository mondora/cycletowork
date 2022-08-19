import 'dart:math' show cos, sqrt, sin, pi, atan2;
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class LocationData {
  String? locationDataId;
  String? userActivityId;
  final double latitude; // Latitude, in degrees
  final double longitude; // Longitude, in degrees
  final double accuracy; // Estimated horizontal accuracy, radial, in meters
  final double altitude; // In meters above the WGS 84 reference ellipsoid
  final double speed; // In meters/second
  final double speedAccuracy; // In meters/second, always 0 on iOS
  final int time; // timestamp of the LocationData
  final double bearing;

  LocationData({
    this.locationDataId,
    this.userActivityId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.speed,
    required this.speedAccuracy,
    required this.time,
    required this.bearing,
  });

  LocationData.fromMap(Map<String, dynamic> map)
      : locationDataId = map['locationDataId'],
        userActivityId = map['userActivityId'],
        latitude = map['latitude'],
        longitude = map['longitude'],
        accuracy = map['accuracy'],
        altitude = map['altitude'],
        speed = map['speed'],
        speedAccuracy = map['speedAccuracy'],
        time = map['time'],
        bearing = map['bearing'];

  Map<String, dynamic> toJson() => {
        'locationDataId': locationDataId,
        'userActivityId': userActivityId,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'altitude': altitude,
        'speed': speed,
        'speedAccuracy': speedAccuracy,
        'time': time,
        'bearing': bearing,
      };

  static String get tableName => 'LocationData';

  static String get tableString => '''
    CREATE TABLE IF NOT EXISTS $tableName( 
      locationDataId TEXT PRIMARY KEY  NOT NULL,
      userActivityId TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      accuracy REAL NOT NULL,
      altitude REAL NOT NULL,
      speed REAL NOT NULL,
      speedAccuracy REAL NOT NULL,
      time INTEGER NOT NULL,
      bearing REAL NOT NULL, 
      CONSTRAINT fk_LocationData_UserActivity
        FOREIGN KEY (userActivityId)
        REFERENCES ${UserActivity.tableName}(userActivityId)
    );
  ''';

  static double calculateDistanceInMeter({
    required double latitude1,
    required double longitude1,
    required double latitude2,
    required double longitude2,
  }) {
    return mp.SphericalUtil.computeDistanceBetween(
      mp.LatLng(latitude1, longitude1),
      mp.LatLng(latitude2, longitude2),
    ).toDouble();
  }

  static double calculateDistanceInRadians({
    required double latitude1,
    required double longitude1,
    required double latitude2,
    required double longitude2,
  }) {
    return mp.SphericalUtil.computeAngleBetween(
      mp.LatLng(latitude1, longitude1),
      mp.LatLng(latitude2, longitude2),
    ).toDouble();
  }

  // static LocationData getCentralGeoCoordinate(
  //   List<LocationData> geoCoordinates,
  // ) {
  //   if (geoCoordinates.length == 1) {
  //     return geoCoordinates.first;
  //   }

  //   double x = 0;
  //   double y = 0;
  //   double z = 0;

  //   for (var geoCoordinate in geoCoordinates) {
  //     var latitude = geoCoordinate.latitude * pi / 180;
  //     var longitude = geoCoordinate.longitude * pi / 180;

  //     x += cos(latitude) * cos(longitude);
  //     y += cos(latitude) * sin(longitude);
  //     z += sin(latitude);
  //   }

  //   var total = geoCoordinates.length;

  //   x = x / total;
  //   y = y / total;
  //   z = z / total;

  //   var centralLongitude = atan2(y, x);
  //   var centralSquareRoot = sqrt(x * x + y * y);
  //   var centralLatitude = atan2(z, centralSquareRoot);

  //   return LocationData(
  //     latitude: centralLatitude * 180 / pi,
  //     longitude: centralLongitude * 180 / pi,
  //     accuracy: 0,
  //     altitude: 0,
  //     speed: 0,
  //     speedAccuracy: 0,
  //     time: DateTime.now().toLocal().millisecondsSinceEpoch,
  //   );
  // }
}
