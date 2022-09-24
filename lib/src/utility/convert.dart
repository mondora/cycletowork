import 'dart:typed_data';

import 'package:flutter/material.dart';

extension AppDateTime on DateTime {
  String toDayInterval(BuildContext context) {
    const biking = 'in bicicletta';
    try {
      if (hour < 12) return 'Mattinata $biking';
      if (hour >= 12 && hour < 16) return 'Pomeriggio $biking';
      return 'Notte $biking';
    } catch (e) {
      return '';
    }
  }

  String toStartTime(BuildContext context) {
    const youStartAt = 'Hai cominciato in';
    try {
      return '$youStartAt ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  DateTime getDateOfThisWeek({int offsetDay = 0}) {
    var currentDay = weekday;
    var firstDayOfWeek = subtract(
      Duration(days: currentDay - 1 - offsetDay),
    );
    return DateTime(
      firstDayOfWeek.year,
      firstDayOfWeek.month,
      firstDayOfWeek.day,
    );
  }
}

extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}

extension ListIntExtensions on List<int> {
  Uint8List toUint8List() {
    final self = this;
    return (self is Uint8List) ? self : Uint8List.fromList(this);
  }
}

extension DoubleExtensions on double {
  int toCalorieFromDistanceInMeter() {
    return (this * 50) ~/ 1609.34;
  }

  //Each 1km distance is 250g co2
  double distanceInMeterToCo2g() {
    return (this * 250) / 1000;
  }

  //Each 1m distance is 1.312 pas
  double distanceInMeterToSteps() {
    return (this * 1.312);
  }

  double gramToKg() {
    return this / 1000;
  }

  double meterToKm() {
    return this / 1000;
  }

  double meterPerSecondToKmPerHour() {
    return this * 3.6;
  }
}

extension IntExtensions on int {
  int millisecondsSinceEpochToSeconde() {
    return this ~/ 1000;
  }
}
