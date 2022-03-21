import 'package:cycletowork/src/app.dart';
import 'package:cycletowork/src/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppColor.initial();

  runApp(const CycleToWorkApp());
}
