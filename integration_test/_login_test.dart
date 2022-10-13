import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cycletowork/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('verify email login', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    app.main();

    // Trace the timeline of the following operation. The timeline result will
    // be written to `build/integration_response_data.json` with the key
    // `timeline`.
    await binding.traceAction(() async {
      // Trigger a frame.
      await tester.pumpAndSettle();
      // await Future.delayed(const Duration(milliseconds: 2500));
      final loginButton = find.byKey(const Key('login'));
      // await tester.press(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 1000));

      // final emailInput = find.byWidgetPredicate(
      //   (Widget widget) =>
      //       widget is TextFormField && widget.key == const Key('email'),
      // );
      // await tester.enterText(emailInput, '');
      await Future.delayed(const Duration(milliseconds: 500));
    });
  });
}
