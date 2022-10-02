import 'dart:collection';
import 'dart:math' show cos, sqrt, sin, pi, atan2;
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:maps_toolkit/maps_toolkit.dart';

class LocationData {
  String? locationDataId;
  String? userActivityId;
  final double latitude; // Latitude, in degrees
  final double longitude; // Longitude, in degrees
  final double accuracy; // Estimated horizontal accuracy, radial, in meters
  final double altitude; // In meters above the WGS 84 reference ellipsoid
  double speed; // In meters/second
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

  LocationData.fromMap(Map<dynamic, dynamic> map)
      : locationDataId = map['locationDataId'],
        userActivityId = map['userActivityId'],
        latitude = map['latitude'],
        longitude = map['longitude'],
        accuracy = map['accuracy'] != null
            ? double.parse(map['accuracy'].toString())
            : 0.0,
        altitude = map['altitude'],
        speed = map['speed'],
        speedAccuracy = map['speedAccuracy'],
        time = map['time'],
        bearing = map['bearing'];

  LocationData.fromLocationData(LocationData locationData)
      : locationDataId = locationData.locationDataId,
        userActivityId = locationData.userActivityId,
        latitude = locationData.latitude,
        longitude = locationData.longitude,
        accuracy = locationData.accuracy,
        altitude = locationData.altitude,
        speed = locationData.speed,
        speedAccuracy = locationData.speedAccuracy,
        time = locationData.time,
        bearing = locationData.bearing;

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
        ON DELETE CASCADE ON UPDATE NO ACTION
    );
  ''';

  static List<String> get alterTableV1ToV2 => [
        'PRAGMA foreign_keys=off;',
        'ALTER TABLE $tableName RENAME TO ${tableName}_old;',
        tableString,
        'INSERT INTO $tableName SELECT * FROM ${tableName}_old;',
        'DROP TABLE ${tableName}_old;',
        'PRAGMA foreign_keys=on;',
      ];

  static double calculateMaxDistanceFromCenterInMeter({
    required List<LocationData> listPosition,
    required double centerPositonLatitude,
    required double centerPositonLongitude,
  }) {
    double maxDistance = 0;
    for (var position in listPosition) {
      var distance = LocationData.calculateDistanceInMeter(
        latitude1: centerPositonLatitude,
        longitude1: centerPositonLongitude,
        latitude2: position.latitude,
        longitude2: position.longitude,
      ).abs();

      maxDistance = maxDistance < distance ? distance : maxDistance;
    }
    return maxDistance * 2;
  }

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

  static LocationData getCentralGeoCoordinate(
    List<LocationData> geoCoordinates,
  ) {
    if (geoCoordinates.length == 1) {
      return geoCoordinates.first;
    }

    double x = 0;
    double y = 0;
    double z = 0;

    for (var geoCoordinate in geoCoordinates) {
      var latitude = geoCoordinate.latitude * pi / 180;
      var longitude = geoCoordinate.longitude * pi / 180;

      x += cos(latitude) * cos(longitude);
      y += cos(latitude) * sin(longitude);
      z += sin(latitude);
    }

    var total = geoCoordinates.length;

    x = x / total;
    y = y / total;
    z = z / total;

    var centralLongitude = atan2(y, x);
    var centralSquareRoot = sqrt(x * x + y * y);
    var centralLatitude = atan2(z, centralSquareRoot);

    return LocationData(
      latitude: centralLatitude * 180 / pi,
      longitude: centralLongitude * 180 / pi,
      accuracy: 0,
      altitude: 0,
      speed: 0,
      speedAccuracy: 0,
      time: DateTime.now().toLocal().millisecondsSinceEpoch,
      bearing: 0,
    );
  }

  /// Simplifies the given polyline using the Douglas-Peucker
  /// decimation algorithm. Increasing the tolerance will result in fewer points
  /// in the simplified polyline.
  /// The time complexity of Douglas-Peucker is O(n^2), so take care that you do
  /// not call this algorithm too frequently in your code.
  ///
  /// @param polyline  to be simplified.
  /// @param tolerance in meters. Increasing the tolerance will result in fewer
  ///                  points in the simplified polyline.
  /// @return a simplified polyline produced by the Douglas-Peucker algorithm
  static List<LocationData> simplify(
      List<LocationData> polyline, num tolerance) {
    final n = polyline.length;
    if (n < 1) {
      throw const FormatException('Polyline must have at least 1 point');
    }
    if (tolerance <= 0) {
      throw const FormatException('Tolerance must be greater than zero');
    }

    // late final LatLng lastPoint;

    int idx;
    var maxIdx = 0;
    final stack = Queue<List<int>>();
    final dists = List<num>.filled(n, 0);
    dists[0] = 1;
    dists[n - 1] = 1;
    num maxDist;
    num dist = 0.0;
    List<int> current;

    if (n > 2) {
      final stackVal = [0, (n - 1)];
      stack.add(stackVal);
      while (stack.isNotEmpty) {
        current = stack.removeLast();
        maxDist = 0;
        for (idx = current[0] + 1; idx < current[1]; ++idx) {
          var p = LatLng(polyline[idx].latitude, polyline[idx].longitude);
          var start = LatLng(
              polyline[current[0]].latitude, polyline[current[0]].longitude);
          var end = LatLng(
              polyline[current[1]].latitude, polyline[current[1]].longitude);
          dist = PolygonUtil.distanceToLine(p, start, end);
          if (dist > maxDist) {
            maxDist = dist;
            maxIdx = idx;
          }
        }
        if (maxDist > tolerance) {
          dists[maxIdx] = maxDist;
          final stackValCurMax = [current[0], maxIdx];
          stack.add(stackValCurMax);
          final stackValMaxCur = [maxIdx, current[1]];
          stack.add(stackValMaxCur);
        }
      }
    }

    // Generate the simplified line
    idx = 0;
    final simplifiedLine = <LocationData>[];
    for (final l in polyline) {
      if (dists[idx] != 0) {
        simplifiedLine.add(l);
      }
      idx++;
    }

    return simplifiedLine;
  }

  static double distanceToLine(
    LocationData point,
    LocationData startPoint,
    LocationData endPont,
  ) {
    var p = LatLng(point.latitude, point.longitude);
    var start = LatLng(startPoint.latitude, startPoint.longitude);
    var end = LatLng(endPont.latitude, endPont.longitude);
    return PolygonUtil.distanceToLine(p, start, end).toDouble();
  }

  static double getAverageSpeed(List<LocationData> listLocationData) {
    if (listLocationData.isEmpty) {
      return 0;
    }
    if (listLocationData.length == 1) {
      return listLocationData.first.speed;
    }
    return (listLocationData.map((e) => e.speed).reduce((a, b) => a + b)) /
        listLocationData.length;
  }
}
