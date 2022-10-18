import 'package:vibration/vibration.dart' as vb;

class Vibration {
  static Future<void> vibration(int millisecond) async {
    final result = await vb.Vibration.hasCustomVibrationsSupport();
    if (result == true) {
      vb.Vibration.vibrate(duration: millisecond);
    } else {
      vb.Vibration.vibrate();
      await Future.delayed(const Duration(milliseconds: 500));
      vb.Vibration.vibrate();
      await Future.delayed(const Duration(milliseconds: 500));
      vb.Vibration.vibrate();
      await Future.delayed(const Duration(milliseconds: 500));
      vb.Vibration.vibrate();
    }
  }
}
