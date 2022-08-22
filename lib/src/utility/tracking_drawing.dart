import 'dart:async';
import 'dart:typed_data';

import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

class TrackingDrawing {
  static Future<Uint8List> getTrackingDrawing({
    required List<LocationData> listTrackingPosition,
    width = 320,
    height = 320,
  }) async {
    var listPath = _getPathForStaticMapFromLocationData(listTrackingPosition);

    var _staticController = StaticMapController(
      googleApiKey: dotenv.env['GOOGLE_MAP_STATIC_API_KEY']!,
      width: width,
      height: height,
      format: MapImageFormat.png32,
      paths: listPath.length > 1
          ? <Path>[
              Path(
                color: Colors.black,
                weight: 2,
                points: listPath,
              ),
            ]
          : [],
      markers: listPath.isNotEmpty
          ? <Marker>[
              Marker.custom(
                anchor: MarkerAnchor.center,
                icon: 'https://i.ibb.co/58rHbHb/start-position.png',
                locations: [
                  listPath.first,
                ],
              ),
              Marker.custom(
                anchor: MarkerAnchor.center,
                icon: 'https://i.ibb.co/d45s3yj/end-position.png',
                locations: [
                  listPath.last,
                ],
              ),
            ]
          : [],
    );

    return await _staticController.getUint8List();
  }

  static List<Location> _getPathForStaticMapFromLocationData(
    List<LocationData> listLocationData,
  ) {
    return listLocationData
        .map(
          (locationData) => Location(
            locationData.latitude,
            locationData.longitude,
          ),
        )
        .toList();
  }
}
