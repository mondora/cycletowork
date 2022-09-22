import 'package:cycletowork/src/data/app_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    var appData = context.read<AppData>();
    var scale = appData.scale;
    var isWakelockModeEnable = context.watch<AppData>().isWakelockModeEnable;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 10 * scale,
          ),
          Center(
            child: Text(
              'Impostazioni',
              style: textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 10 * scale,
          ),
          // SizedBox(
          //   height: 63.0,
          //   child: ListTile(
          //     leading: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           'Unità di misura',
          //           style: textTheme.bodyText1,
          //         ),
          //       ],
          //     ),
          //     trailing: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(
          //           Icons.arrow_forward_ios,
          //           color: colorScheme.onBackground,
          //         ),
          //       ],
          //     ),
          //     onTap: () {},
          //   ),
          // ),
          // Container(
          //   height: 1.5,
          //   color: const Color.fromRGBO(0, 0, 0, 0.12),
          // ),
          // SizedBox(
          //   height: 63.0,
          //   child: ListTile(
          //     // dense: true,
          //     // visualDensity: VisualDensity(vertical: 3),
          //     leading: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           'Dark mode',
          //           style: textTheme.bodyText1,
          //         ),
          //       ],
          //     ),
          //     trailing: Switch(
          //       value: false,
          //       onChanged: (value) {},
          //     ),
          //     onTap: () {},
          //   ),
          // ),
          // Container(
          //   height: 1.5,
          //   color: const Color.fromRGBO(0, 0, 0, 0.12),
          // ),
          SizedBox(
            height: 63.0,
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Wakelock mode',
                    style: textTheme.bodyText1,
                  ),
                ],
              ),
              trailing: Switch(
                value: isWakelockModeEnable,
                onChanged: (value) async {
                  await appData.setWakelockModeEnable(value);
                  // if (value == true) {
                  //   await Wakelock.enable();
                  //   setState(() {
                  //     wakelockEnabled = true;
                  //   });
                  // } else {
                  //   await Wakelock.disable();
                  //   setState(() {
                  //     wakelockEnabled = false;
                  //   });
                  // }
                },
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
