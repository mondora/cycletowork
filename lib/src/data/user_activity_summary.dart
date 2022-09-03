class UserActivitySummary {
  String uid;
  double co2;
  double distance;
  double averageSpeed;
  double maxSpeed;
  int calorie;
  int steps;

  UserActivitySummary({
    required this.uid,
    required this.co2,
    required this.distance,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.calorie,
    required this.steps,
  });

  UserActivitySummary.fromEmpty()
      : uid = '',
        co2 = 0.0,
        distance = 0.0,
        averageSpeed = 0.0,
        maxSpeed = 0.0,
        calorie = 0,
        steps = 0;

  UserActivitySummary.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        co2 = map['co2'],
        distance = map['distance'],
        averageSpeed = map['averageSpeed'],
        maxSpeed = map['maxSpeed'],
        calorie = map['calorie'],
        steps = map['steps'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'co2': co2,
        'distance': distance,
        'averageSpeed': averageSpeed,
        'maxSpeed': maxSpeed,
        'calorie': calorie,
        'steps': steps,
      };

  static String get tableName => 'UserActivitySummary';

  static String get tableString => '''
    CREATE TABLE IF NOT EXISTS $tableName( 
      uid TEXT PRIMARY KEY  NOT NULL,
      co2 REAL NOT NULL,
      distance REAL NOT NULL,
      averageSpeed REAL NOT NULL,
      maxSpeed REAL NOT NULL, 
      calorie INTEGER NOT NULL,
      steps INTEGER NOT NULL
    );
  ''';
}
