import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/admin/landing/view.dart';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AdminCycleToWorkApp extends StatelessWidget {
  const AdminCycleToWorkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'admin_cycle2work_app',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it', ''),
      ],
      title: 'AdminCycle2Work',
      theme: AppTheme.getLightTheme(true),
      home: const AdminLandingView(),
    );
  }
}
