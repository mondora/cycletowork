import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/dashboard/widget/avatar.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final actionColor = colorSchemeExtension.action;
    final userImageUrl = AppData.user != null ? AppData.user!.imageUrl : null;
    final displayName = AppData.user != null ? AppData.user!.displayName : null;
    final email = AppData.user != null ? AppData.user!.email : null;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: colorScheme.secondary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Modifica',
                  style: textTheme.caption!.copyWith(
                    color: colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[400],
                backgroundImage:
                    userImageUrl != null ? NetworkImage(userImageUrl) : null,
                child: userImageUrl == null
                    ? Icon(
                        Icons.person,
                        color: actionColor,
                        size: 50,
                      )
                    : Container(),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                displayName ?? '',
                style: textTheme.bodyText1,
              )
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            'ACCOUNT',
            style: textTheme.bodyText1!.apply(
              color: colorSchemeExtension.textSecondary,
            ),
          ),
          SizedBox(
            height: 6.0,
          ),
          Text(
            'Email',
            style: textTheme.caption!.apply(
              color: colorSchemeExtension.textSecondary,
            ),
          ),
          Text(
            email ?? '',
            style: textTheme.bodyText1,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Password',
            style: textTheme.caption!.apply(
              color: colorSchemeExtension.textSecondary,
            ),
          ),
          Text(
            '*************',
            style: textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}