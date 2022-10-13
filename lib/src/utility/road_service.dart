import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/utility/network_utility.dart';
import 'dart:convert';

class RoadService {
  /// [apiKEY] Your application's API key. This key identifies your application.
  final String apiKEY;

  /// [search] returns a list of places based on a user's location or search string.
  late SnapToRoads snapToRoads;

  Duration timeout = const Duration(milliseconds: 5000);

  RoadService(this.apiKEY, {Duration? timeout}) {
    if (timeout != null) {
      this.timeout = timeout;
    }
    snapToRoads = SnapToRoads(apiKEY, this.timeout);
  }
}

class SnapToRoads {
  static const _authority = 'roads.googleapis.com';
  static const _unencodedPathSnapToRoads = 'v1/snapToRoads';
  final String apiKEY;
  final Duration timeout;

  SnapToRoads(this.apiKEY, this.timeout);

  Future<SnapToRoadsResponse?> getSnapToRoads(
    List<LocationData> path, {
    bool interpolate = true,
  }) async {
    assert(path.isNotEmpty);
    assert(path.length <= 100);
    final queryParameters = _createSnapToRoadsParameters(
      apiKEY,
      path,
      interpolate,
    );

    final uri = NetworkUtility.createUri(
      null,
      _authority,
      _unencodedPathSnapToRoads,
      queryParameters,
    );
    final response = await NetworkUtility.fetchUrl(
      uri,
      timeout: timeout,
    );
    if (response != null) {
      return SnapToRoadsResponse.parseSnapToRoadsResponse(
        response,
      );
    }
    return null;
  }

  Map<String, String?> _createSnapToRoadsParameters(
    String apiKEY,
    List<LocationData> path,
    bool interpolate,
  ) {
    Map<String, String> queryParameters = {
      'key': apiKEY,
      'interpolate': interpolate.toString(),
    };

    String result = '';
    for (int i = 0; i < path.length; i++) {
      result += '${path[i].latitude},${path[i].longitude}';
      if (i + 1 != path.length) {
        result += '|';
      }
    }
    var item = {
      'path': result,
    };
    queryParameters.addAll(item);

    return queryParameters;
  }
}

class SnapToRoadsResponse {
  final List<SnappedPoint> snappedPoints;

  SnapToRoadsResponse.fromMap(Map<String, dynamic> map)
      : snappedPoints = map['snappedPoints']
            .map<SnappedPoint>(
                (json) => SnappedPoint.fromMap(Map<String, dynamic>.from(json)))
            .toList();

  Map<String, dynamic> toJson() => {
        'snappedPoints': snappedPoints.map((e) => e.toJson()).toList(),
      };

  static SnapToRoadsResponse parseSnapToRoadsResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return SnapToRoadsResponse.fromMap(parsed);
  }
}

class SnappedPoint {
  final Location location;
  final int? originalIndex;
  final String placeId;

  SnappedPoint(
    this.location,
    this.originalIndex,
    this.placeId,
  );

  SnappedPoint.fromMap(Map<String, dynamic> map)
      : location = Location.fromMap(Map<String, dynamic>.from(map['location'])),
        originalIndex = map['originalIndex'],
        placeId = map['placeId'];

  Map<String, dynamic> toJson() => {
        'location': location.toJson(),
        'originalIndex': originalIndex,
        'placeId': placeId,
      };
}

class Location {
  final double latitude;
  final double longitude;

  Location.fromMap(Map<String, dynamic> map)
      : latitude = map['latitude'],
        longitude = map['longitude'];

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
