import 'package:cycletowork/src/app.dart';
import 'package:cycletowork/src/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppColor.initial();

  runApp(const CycleToWorkApp());
}
