import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/milan_bike_challenge_regulations/view.dart';
import 'package:cycletowork/src/ui/personal_data_management/view.dart';
import 'package:cycletowork/src/ui/privacy_policy/view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InformationView extends StatelessWidget {
  const InformationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Text(
              'Info',
              style: textTheme.headline5,
            ),
          ),
          _InformationItem(
            title: 'Privacy Policy',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyView(),
                ),
              );
            },
          ),
          _InformationItem(
            title: 'Regolamento Milano Bike Challenge',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const MilanoBikeChallengeRegulationsView(),
                ),
              );
            },
          ),
          _InformationItem(
            title: 'Cancellazione Account',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PersonalDataManagementView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InformationItem extends StatelessWidget {
  final String title;
  final GestureTapCancelCallback? onPressed;
  const _InformationItem({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        SizedBox(
          height: 63.0 * scale,
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
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
                  size: 25 * scale,
                ),
              ],
            ),
            onTap: onPressed,
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
