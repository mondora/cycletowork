import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math' show cos, sqrt, asin;

void main() {
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  test('calculate distance 1', () async {
    List<dynamic> data = [
      {"lat": 44.968046, "lng": -94.420307},
      {"lat": 44.33328, "lng": -89.132008},
      {"lat": 33.755787, "lng": -116.359998},
      {"lat": 33.844843, "lng": -116.54911},
      {"lat": 44.92057, "lng": -93.44786},
      {"lat": 44.240309, "lng": -91.493619},
      {"lat": 44.968041, "lng": -94.419696},
      {"lat": 44.333304, "lng": -89.132027},
      {"lat": 33.755783, "lng": -116.360066},
      {"lat": 33.844847, "lng": -116.549069},
    ];
    double totalDistance = 0;
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance += calculateDistance(data[i]["lat"], data[i]["lng"],
          data[i + 1]["lat"], data[i + 1]["lng"]);
    }
    debugPrint('totalDistance(km): $totalDistance');

    double totalDistance2 = 0;
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance2 += LocationData.calculateDistanceInMeter(
        latitude1: data[i]["lat"],
        longitude1: data[i]["lng"],
        latitude2: data[i + 1]["lat"],
        longitude2: data[i + 1]["lng"],
      );
    }

    debugPrint('totalDistance2(km): ${totalDistance2.meterToKm()}');
  });

  test('calculate distance 2', () async {
    // total google map =  1117m, total ffc.gov = 1088m, {totalDistance(km): : 1.087259681975678}
    List<dynamic> data = [
      {"lat": 43.585985, "lng": -84.787444},
      {"lat": 43.582490, "lng": -84.787403}, //400m , 389m
      {"lat": 43.582497, "lng": -84.791490}, //350m, 329m
      {"lat": 43.583362, "lng": -84.791490}, //97m, 96m
      {"lat": 43.584505, "lng": -84.790903}, //130m, 136m
      {"lat": 43.585728, "lng": -84.791166}, //140m, 138m
    ];
    double totalDistance = 0;
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance += calculateDistance(data[i]["lat"], data[i]["lng"],
          data[i + 1]["lat"], data[i + 1]["lng"]);
    }
    debugPrint('totalDistance(km): $totalDistance');

    double totalDistance2 = 0;
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance2 += LocationData.calculateDistanceInMeter(
        latitude1: data[i]["lat"],
        longitude1: data[i]["lng"],
        latitude2: data[i + 1]["lat"],
        longitude2: data[i + 1]["lng"],
      );
    }

    debugPrint('totalDistance2(km): ${totalDistance2.meterToKm()}');
  });
}
