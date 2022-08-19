import 'dart:typed_data';

class UserActivity {
  String? userActivityId;
  int? startTime;
  int? stopTime;
  int? duration;
  double? co2;
  double? distance;
  double? averageSpeed;
  double? maxSpeed;
  int? calorie;
  int? steps;
  Uint8List? imageData;
  int? isChallenge;

  UserActivity({
    this.userActivityId,
    this.startTime,
    this.stopTime,
    this.duration,
    this.co2,
    this.distance,
    this.averageSpeed,
    this.maxSpeed,
    this.calorie,
    this.steps,
    this.imageData,
    this.isChallenge = 0,
  });

  UserActivity.fromMap(Map<dynamic, dynamic> map)
      : userActivityId = map['userActivityId'],
        startTime = map['startTime'],
        stopTime = map['stopTime'],
        duration = map['duration'],
        co2 = map['co2'],
        distance = map['distance'],
        averageSpeed = map['averageSpeed'],
        maxSpeed = map['maxSpeed'],
        calorie = map['calorie'],
        steps = map['steps'],
        imageData = map['imageData'],
        isChallenge = map['isChallenge'];

  Map<String, dynamic> toJson() => {
        'userActivityId': userActivityId,
        'startTime': startTime,
        'stopTime': stopTime,
        'duration': duration,
        'co2': co2,
        'distance': distance,
        'averageSpeed': averageSpeed,
        'maxSpeed': maxSpeed,
        'calorie': calorie,
        'steps': steps,
        'imageData': imageData,
        'isChallenge': isChallenge,
      };

  static String get tableName => 'UserActivity';

  static String get tableString => '''
    CREATE TABLE IF NOT EXISTS $tableName( 
      userActivityId TEXT PRIMARY KEY  NOT NULL, 
      startTime INTEGER NOT NULL,
      stopTime INTEGER NOT NULL,
      duration INTEGER NOT NULL,
      co2 REAL NOT NULL,
      distance REAL NOT NULL,
      averageSpeed REAL NOT NULL,
      maxSpeed REAL NOT NULL, 
      calorie INTEGER NOT NULL,
      steps INTEGER NOT NULL,
      imageData blob,
      isChallenge INTEGER NOT NULL
    );
  ''';
}
