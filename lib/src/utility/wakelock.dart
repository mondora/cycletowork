import 'package:wakelock/wakelock.dart';

class WakeLock {
  static Future<void> enable() async {
    await Wakelock.enable();
  }

  static Future<void> disable() async {
    await Wakelock.disable();
  }

  static Future<bool> get enabled async {
    return await Wakelock.enabled;
  }
}
