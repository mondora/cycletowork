import 'package:flutter/material.dart';

class UserActivity {
  final double co2;
  final int timestamp;
  final double distant;
  final double averageSpeed;
  final bool isChallenge;
  final Widget map;

  UserActivity({
    required this.co2,
    required this.timestamp,
    required this.distant,
    required this.averageSpeed,
    required this.map,
    this.isChallenge = false,
  });
}
