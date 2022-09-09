import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart' as log;

class Logger {
  static final logger = log.Logger(
    printer: log.PrettyPrinter(),
  );

  static void error(e) {
    logger.e(e.toString());
    FirebaseCrashlytics.instance.recordError(e, null, fatal: true);
  }
}
