import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Text(
              'Impostazioni',
              style: textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 63.0,
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Unità di misura',
                    style: textTheme.bodyText1,
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    color: colorScheme.onBackground,
                  ),
                ],
              ),
              onTap: () {},
            ),
          ),
          Container(
            height: 1.5,
            color: const Color.fromRGBO(0, 0, 0, 0.12),
          ),
          SizedBox(
            height: 63.0,
            child: ListTile(
              // dense: true,
              // visualDensity: VisualDensity(vertical: 3),
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dark mode',
                    style: textTheme.bodyText1,
                  ),
                ],
              ),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
              onTap: () {},
            ),
          ),
          Container(
            height: 1.5,
            color: const Color.fromRGBO(0, 0, 0, 0.12),
          ),
        ],
      ),
    );
  }
}
