import 'package:flutter/material.dart';

class InformationView extends StatelessWidget {
  const InformationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
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
            onPressed: () {},
          ),
          _InformationItem(
            title: 'Terms & Conditions',
            onPressed: () {},
          ),
          _InformationItem(
            title: 'Regolamento Milano Bike Challenge',
            onPressed: () {},
          ),
          _InformationItem(
            title: 'Qualsiasi cosa venga in mente',
            onPressed: () {},
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
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        SizedBox(
          height: 63.0,
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
                ),
              ],
            ),
            onTap: onPressed,
          ),
        ),
        Container(
          height: 1.5,
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ),
      ],
    );
  }
}
