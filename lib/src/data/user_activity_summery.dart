class UserActivitySummery {
  double co2;
  double distance;
  double averageSpeed;
  double maxSpeed;
  int calorie;
  int steps;

  UserActivitySummery({
    required this.co2,
    required this.distance,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.calorie,
    required this.steps,
  });

  UserActivitySummery.fromMap(Map<String, dynamic> map)
      : co2 = map['co2'],
        distance = map['distance'],
        averageSpeed = map['averageSpeed'],
        maxSpeed = map['maxSpeed'],
        calorie = map['calorie'],
        steps = map['steps'];

  Map<String, dynamic> toJson() => {
        'co2': co2,
        'distance': distance,
        'averageSpeed': averageSpeed,
        'maxSpeed': maxSpeed,
        'calorie': calorie,
        'steps': steps,
      };

  static String get co2Key => 'UserActivitySummery_co2';
  static String get distanceKey => 'UserActivitySummery_distance';
  static String get averageSpeedKey => 'UserActivitySummery_averageSpeed';
  static String get maxSpeedKey => 'UserActivitySummery_maxSpeed';
  static String get calorieKey => 'UserActivitySummery_calorie';
  static String get stepsKey => 'UserActivitySummery_steps';
}
