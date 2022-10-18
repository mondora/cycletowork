import 'package:flutter_activity_recognition/flutter_activity_recognition.dart'
    as activity_recognition;

enum PermissionRequestResult {
  /// Occurs when the user grants permission.
  granted,

  /// Occurs when the user denies permission.
  denied,

  /// Occurs when the user denies the permission once and chooses not to ask again.
  permanentlyDenied,
}

class ActivityRecognition {
  static final activityRecognition =
      activity_recognition.FlutterActivityRecognition.instance;

  static Future<PermissionRequestResult> checkPermission() async {
    final result = await activityRecognition.checkPermission();
    final resultName = result.name.toLowerCase().replaceAll('_', '');
    return PermissionRequestResult.values.firstWhere(
      (element) => element.name.toLowerCase() == resultName,
    );
  }

  static Future<PermissionRequestResult> requestPermission() async {
    final result = await activityRecognition.requestPermission();
    final resultName = result.name.toLowerCase().replaceAll('_', '');
    return PermissionRequestResult.values.firstWhere(
      (element) => element.name.toLowerCase() == resultName,
    );
  }

  static Stream<ActivityRecognitionResult> activityStream() {
    return activityRecognition.activityStream.map((activity) {
      final activityTypeName =
          activity.type.name.toLowerCase().replaceAll('_', '');
      final activityConfidenceName =
          activity.confidence.name.toLowerCase().replaceAll('_', '');
      return ActivityRecognitionResult(
        activityType: ActivityType.values.firstWhere(
          (element) => element.name.toLowerCase() == activityTypeName,
        ),
        activityConfidence: ActivityConfidence.values.firstWhere(
          (element) => element.name.toLowerCase() == activityConfidenceName,
        ),
      );
    });
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
