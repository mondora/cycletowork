import 'dart:math';

import 'package:flutter/material.dart';

class CompanyClassification {
  String id;
  String challengeId;
  String name;
  double co2;
  double distance;
  int employeesNumber;
  int employeesNumberRegistered;
  double percentRegistered;
  int rankingCo2;
  int rankingPercentRegistered;
  int updateDate;
  final Color color;

  CompanyClassification({
    required this.id,
    required this.challengeId,
    required this.name,
    required this.co2,
    required this.distance,
    required this.employeesNumber,
    required this.employeesNumberRegistered,
    required this.percentRegistered,
    required this.rankingCo2,
    required this.rankingPercentRegistered,
    required this.updateDate,
  }) : color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  CompanyClassification.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        challengeId = map['challengeId'],
        name = map['name'],
        co2 = double.parse(map['co2'].toString()),
        distance = double.parse(map['distance'].toString()),
        employeesNumber = map['employeesNumber'],
        employeesNumberRegistered = map['employeesNumberRegistered'],
        percentRegistered = double.parse(map['percentRegistered'].toString()),
        rankingCo2 = map['rankingCo2'],
        rankingPercentRegistered = map['rankingPercentRegistered'],
        updateDate = map['updateDate'] ?? DateTime.now().millisecondsSinceEpoch,
        color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  Map<String, dynamic> toJson() => {
        'id': id,
        'challengeId': challengeId,
        'name': name,
        'co2': co2,
        'distance': distance,
        'employeesNumber': employeesNumber,
        'employeesNumberRegistered': employeesNumberRegistered,
        'percentRegistered': percentRegistered,
        'rankingCo2': rankingCo2,
        'rankingPercentRegistered': rankingPercentRegistered,
        'updateDate': updateDate,
        'uniqueId': id + challengeId,
      };

  static String get tableName => 'CompanyClassification';

  static String get tableString => '''
    CREATE TABLE IF NOT EXISTS $tableName(
      uniqueId TEXT PRIMARY KEY  NOT NULL,
      id TEXT  NOT NULL,
      challengeId TEXT NOT NULL, 
      name TEXT NOT NULL,
      co2 REAL NOT NULL,
      distance REAL NOT NULL,
      employeesNumber INTEGER NOT NULL,
      employeesNumberRegistered INTEGER NOT NULL,
      percentRegistered REAL NOT NULL,
      rankingCo2 INTEGER NOT NULL,
      rankingPercentRegistered INTEGER NOT NULL,
      updateDate INTEGER NOT NULL
    );
  ''';
}

class CyclistClassification {
  String uid;
  String challengeId;
  double co2;
  double distance;
  int rankingCo2;
  int updateDate;
  String? displayName;
  String? photoURL;
  Color color;

  CyclistClassification({
    required this.uid,
    required this.challengeId,
    required this.co2,
    required this.distance,
    required this.rankingCo2,
    required this.updateDate,
    this.displayName,
    this.photoURL,
  }) : color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  CyclistClassification.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        challengeId = map['challengeId'],
        displayName = map['displayName'],
        co2 = double.parse(map['co2'].toString()),
        distance = double.parse(map['distance'].toString()),
        photoURL = map['photoURL'],
        rankingCo2 = map['rankingCo2'],
        updateDate = map['updateDate'] ?? DateTime.now().millisecondsSinceEpoch,
        color = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'challengeId': challengeId,
        'displayName': displayName,
        'co2': co2,
        'distance': distance,
        'photoURL': photoURL,
        'rankingCo2': rankingCo2,
        'updateDate': updateDate,
        'uniqueId': uid + challengeId,
      };

  static String get tableName => 'CyclistClassification';

  static String get tableString => '''
    CREATE TABLE IF NOT EXISTS $tableName( 
      uniqueId TEXT PRIMARY KEY  NOT NULL,
      uid TEXT NOT NULL,
      challengeId TEXT NOT NULL, 
      co2 REAL NOT NULL,
      distance REAL NOT NULL,
      rankingCo2 INTEGER NOT NULL,
      updateDate INTEGER NOT NULL,
      displayName TEXT,
      photoURL TEXT
    );
  ''';
}
