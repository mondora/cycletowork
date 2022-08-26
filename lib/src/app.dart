import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/landing/view.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class CycleToWorkApp extends StatefulWidget {
  const CycleToWorkApp({Key? key}) : super(key: key);

  @override
  State<CycleToWorkApp> createState() => _CycleToWorkAppState();
}

class _CycleToWorkAppState extends State<CycleToWorkApp> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'cycle2work_app',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        // Locale('en', ''),
        Locale('it', ''), // English, no country code
      ],
      title: 'Cycle2Work',
      theme: AppTheme.getLightTheme(false),
      // darkTheme: ThemeData.dark(),
      home: const LandingView(),
    );
  }
}
