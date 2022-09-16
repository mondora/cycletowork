import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MilanoBikeChallengeRegulationsView extends StatelessWidget {
  const MilanoBikeChallengeRegulationsView({super.key});
  final milanoBikeChallengeRegulationsUrl =
      'https://cycletowork.mondora.com/regolamento';
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Regolamento Milano Bike Challenge',
          style: textTheme.bodyText1,
        ),
        leading: IconButton(
          splashRadius: 25.0,
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onBackground,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: milanoBikeChallengeRegulationsUrl,
      ),
    );
  }
}
