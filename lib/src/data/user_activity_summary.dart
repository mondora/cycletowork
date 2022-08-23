class UserActivitySummary {
  double co2;
  double distance;
  double averageSpeed;
  double maxSpeed;
  int calorie;
  int steps;

  UserActivitySummary({
    required this.co2,
    required this.distance,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.calorie,
    required this.steps,
  });

  UserActivitySummary.fromMap(Map<String, dynamic> map)
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

  static String get co2Key => 'UserActivitySummary_co2';
  static String get distanceKey => 'UserActivitySummary_distance';
  static String get averageSpeedKey => 'UserActivitySummary_averageSpeed';
  static String get maxSpeedKey => 'UserActivitySummary_maxSpeed';
  static String get calorieKey => 'UserActivitySummary_calorie';
  static String get stepsKey => 'UserActivitySummary_steps';
}
