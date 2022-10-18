import 'package:cycletowork/src/utility/logger.dart';
import 'package:wakelock/wakelock.dart';

class WakeLock {
  static Future<void> enable() async {
    try {
      await Wakelock.enable();
    } catch (e) {
      Logger.error(e);
    }
  }

  static Future<void> disable() async {
    try {
      await Wakelock.disable();
    } catch (e) {
      Logger.error(e);
    }
  }

  static Future<bool> get enabled async {
    return await Wakelock.enabled;
  }
}
