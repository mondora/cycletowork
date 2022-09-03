import 'package:cycletowork/src/admin_app.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:cycletowork/src/app.dart';
import 'package:cycletowork/src/color.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/utility/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppColor.initialize();
  await Gps.initialize();
  await AppNotification.initialize();
  runApp(const CycleToWorkApp());
}
