import 'package:logger/logger.dart' as log;

class Logger {
  static final logger = log.Logger(
    printer: log.PrettyPrinter(),
  );

  static void error(e) {
    logger.e(e.toString());
    //TODO Firebase crash
  }
}
