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
    required Color backgroundColor,
    width = 57,
    height = 57,
  }) async {
    var listPath = _getPathForStaticMapFromLocationData(listTrackingPosition);
    var retroMapStyle = [
      MapStyle(
        element: StyleElement.geometry,
        rules: [
          StyleRule.color(backgroundColor),
        ],
      ),
      const MapStyle(
        element: StyleElement.labels,
        rules: [
          StyleRule.visibility(VisibilityRule.off),
        ],
      ),
    ];

    var _staticController = StaticMapController(
      googleApiKey: dotenv.env['GOOGLE_MAP_STATIC_API_KEY']!,
      width: width,
      height: height,
      format: MapImageFormat.png32,
      styles: retroMapStyle,
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
              Marker(
                size: MarkerSize.tiny,
                locations: [
                  listPath.first,
                ],
              ),
              Marker(
                size: MarkerSize.tiny,
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
