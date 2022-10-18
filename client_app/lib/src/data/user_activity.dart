import 'dart:typed_data';

class UserActivity {
  String userActivityId;
  String uid;
  int startTime;
  int stopTime;
  int duration;
  double co2;
  double distance;
  double averageSpeed;
  double maxSpeed;
  int calorie;
  int steps;
  int isChallenge;
  String? challengeId;
  String? companyId;
  String? city;
  Uint8List? imageData;
  int isUploaded;
  double maxAccuracy;
  double minAccuracy;
  int isSendedToReview;

  UserActivity({
    required this.uid,
    required this.userActivityId,
    required this.startTime,
    required this.stopTime,
    required this.duration,
    required this.co2,
    required this.distance,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.calorie,
    required this.steps,
    required this.isChallenge,
    required this.isUploaded,
    required this.maxAccuracy,
    required this.minAccuracy,
    required this.isSendedToReview,
    this.challengeId,
    this.companyId,
    this.city,
    this.imageData,
  });

  UserActivity.fromMap(Map<dynamic, dynamic> map)
      : uid = map['uid'],
        userActivityId = map['userActivityId'],
        startTime = map['startTime'],
        stopTime = map['stopTime'],
        duration = map['duration'],
        co2 = map['co2'] != null ? double.parse(map['co2'].toString()) : 0,
        distance = map['distance'] != null
            ? double.parse(map['distance'].toString())
            : 0,
        averageSpeed = map['averageSpeed'] != null
            ? double.parse(map['averageSpeed'].toString())
            : 0,
        maxSpeed = map['maxSpeed'] != null
            ? double.parse(map['maxSpeed'].toString())
            : 0,
        calorie = map['calorie'] ?? 0,
        steps = map['steps'] ?? 0,
        imageData = map['imageData'],
        isChallenge = map['isChallenge'],
        challengeId = map['challengeId'],
        companyId = map['companyId'],
        city = map['city'],
        isUploaded = map['isUploaded'] ?? 1,
        maxAccuracy = map['maxAccuracy'] != null
            ? double.parse(map['maxAccuracy'].toString())
            : 0.0,
        minAccuracy = map['minAccuracy'] != null
            ? double.parse(map['minAccuracy'].toString())
            : 0.0,
        isSendedToReview = map['isSendedToReview'] ?? 0;

  Map<String, dynamic> toJson() => {
        'uid': uid,
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
        'challengeId': challengeId,
        'companyId': companyId,
        'city': city,
        'isUploaded': isUploaded,
        'maxAccuracy': maxAccuracy,
        'minAccuracy': minAccuracy,
        'isSendedToReview': isSendedToReview,
      };

  static String get tableName => 'UserActivity';

  static String get tableString => '''
    CREATE TABLE IF NOT EXISTS $tableName( 
      userActivityId TEXT PRIMARY KEY  NOT NULL,
      uid TEXT NOT NULL,
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
      isChallenge INTEGER NOT NULL,
      challengeId TEXT,
      companyId TEXT,
      city TEXT,
      isUploaded INTEGER NOT NULL,
      maxAccuracy REAL NOT NULL,
      minAccuracy REAL NOT NULL,
      isSendedToReview INTEGER NOT NULL
    );
  ''';

  static List<String> get alterTableV2ToV3 => [
        'ALTER TABLE $tableName ADD isUploaded INTEGER NOT NULL DEFAULT 1;',
      ];

  static List<String> get alterTableV3ToV4 => [
        'ALTER TABLE $tableName ADD maxAccuracy REAL NOT NULL DEFAULT 0;',
        'ALTER TABLE $tableName ADD minAccuracy REAL NOT NULL DEFAULT 0;',
        'ALTER TABLE $tableName ADD isSendedToReview INTEGER NOT NULL DEFAULT 0;',
      ];
}
