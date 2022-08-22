import 'package:cloud_functions/cloud_functions.dart';

class Remote {
  static const _region = 'europe-west3';
  static const _timeout = Duration(minutes: 3);

  static Future<dynamic> callFirebaseFunctions(
    String functionName,
    dynamic arg,
  ) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: _region).httpsCallable(
      functionName,
      options: HttpsCallableOptions(
        timeout: _timeout,
      ),
    );

    final results = await callable.call(arg);
    return results.data;
  }
}
