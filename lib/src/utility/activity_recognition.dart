import 'package:flutter_activity_recognition/flutter_activity_recognition.dart'
    as activity_recognition;

enum PermissionRequestResult {
  /// Occurs when the user grants permission.
  granted,

  /// Occurs when the user denies permission.
  denied,

  /// Occurs when the user denies the permission once and chooses not to ask again.
  permanentyDenied,
}

class ActivityRecognition {
  static final activityRecognition =
      activity_recognition.FlutterActivityRecognition.instance;

  static Future<PermissionRequestResult> checkPermission() async {
    final result = await activityRecognition.checkPermission();
    return PermissionRequestResult.values.firstWhere(
      (element) => element.name.toLowerCase() == result.name.toLowerCase(),
    );
  }

  static Future<PermissionRequestResult> requestPermission() async {
    final result = await activityRecognition.requestPermission();
    return PermissionRequestResult.values.firstWhere(
      (element) => element.name.toLowerCase() == result.name.toLowerCase(),
    );
  }

  static Stream<ActivityRecognitionResult> activityStream() {
    // activityRecognition.activityStream.listen((event) {
    //   print(event.type);
    // });
    return activityRecognition.activityStream.map(
      (activity) => ActivityRecognitionResult(
        activityType: ActivityType.values.firstWhere(
          (element) =>
              element.name.toLowerCase() == activity.type.name.toLowerCase(),
        ),
        activityConfidence: ActivityConfidence.values.firstWhere(
          (element) =>
              element.name.toLowerCase() ==
              activity.confidence.name.toLowerCase(),
        ),
      ),
    );
  }
}

class ActivityRecognitionResult {
  final ActivityType activityType;
  final ActivityConfidence activityConfidence;

  ActivityRecognitionResult({
    required this.activityType,
    required this.activityConfidence,
  });
}

enum ActivityType {
  /// The device is in a vehicle, such as a car.
  inVehicle,

  /// The device is on a bicycle.
  onBicycle,

  /// The device is on a user who is running. This is a sub-activity of ON_FOOT.
  running,

  /// The device is still (not moving).
  still,

  /// The device is on a user who is walking. This is a sub-activity of ON_FOOT.
  walking,

  /// Unable to detect the current activity.
  unknown,
}

enum ActivityConfidence {
  /// High accuracy: 80~100
  high,

  /// Medium accuracy: 50~80
  medium,

  /// Low accuracy: 0~50
  low,
}
