import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'package:cycletowork/src/app.dart';
import 'package:cycletowork/src/color.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/utility/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
    }

    await dotenv.load(fileName: '.env');

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await AppColor.initialize();
    await Gps.initialize();
    await AppNotification.initialize();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppData.instance()),
        ],
        child: const CycleToWorkApp(),
      ),
    );
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}
