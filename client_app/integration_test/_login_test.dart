import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cycletowork/main.dart' as app;
import 'package:path_provider_android/path_provider_android.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('verify email login', (WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(milliseconds: 2500));
    // Build our app and trigger a frame.
    DartPluginRegistrant.ensureInitialized();
    if (Platform.isAndroid) PathProviderAndroid.registerWith();
    //     if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
// if (Platform.isIOS) SharedPreferencesIOS.registerWith();

    app.main();

    // Trace the timeline of the following operation. The timeline result will
    // be written to `build/integration_response_data.json` with the key
    // `timeline`.
    await binding.traceAction(() async {
      // Trigger a frame.
      await tester.pumpAndSettle(const Duration(milliseconds: 2500));
      // await Future.delayed(const Duration(milliseconds: 2500));
      final loginButton = find.byKey(const Key('login'));
      // await tester.press(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 1000));

      final emailInput = find.byKey(const Key('email'));
      final passwordInput = find.byKey(const Key('password'));
      await tester.enterText(emailInput, dotenv.env['EMAIL_TEST'] ?? 'email');
      // await Future.delayed(const Duration(milliseconds: 1000));
      await tester.pumpAndSettle();
      await tester.enterText(
          passwordInput, dotenv.env['PASSWORD_TEST'] ?? 'password');
      FocusManager.instance.primaryFocus?.unfocus();
      await Future.delayed(const Duration(milliseconds: 1000));
      await tester.pumpAndSettle();

      final loginEmailButton = find.byKey(const Key('loginEmail'));
      await tester.tap(loginEmailButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 20000));
    });
  });
}
