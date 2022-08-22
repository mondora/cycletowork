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
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppColor.initialize();
  await Gps.initialize();
  await dotenv.load(fileName: '.env');

  await AppNotification.initialize();

  runApp(const CycleToWorkApp());
}
