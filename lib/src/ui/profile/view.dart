import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/profile_change_password/view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final actionColor = colorSchemeExtension.action;
    final userImageUrl = AppData.user != null ? AppData.user!.photoURL : null;
    final displayName = AppData.user != null ? AppData.user!.displayName : null;
    final email = AppData.user != null ? AppData.user!.email : null;
    final isUserUsedEmailProvider = AppData.isUserUsedEmailProvider;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0 * scale),
        physics: const ScrollPhysics(),
        children: [
          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Container(),
          //     TextButton(
          //       style: TextButton.styleFrom(
          //         padding: const EdgeInsets.all(16.0),
          //         shape: const RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(15.0),
          //           ),
          //         ),
          //         foregroundColor: colorScheme.secondary,
          //       ),
          //       onPressed: () async {
          //         await Navigator.of(context).push(
          //           MaterialPageRoute(
          //             builder: (context) => const EditProfileView(),
          //           ),
          //         );
          //       },
          //       child: Text(
          //         'Modifica',
          //         style: textTheme.caption!.copyWith(
          //           color: colorScheme.secondary,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Column(
            children: [
              CircleAvatar(
                radius: 50 * scale,
                backgroundColor: Colors.grey[400],
                backgroundImage:
                    userImageUrl != null ? NetworkImage(userImageUrl) : null,
                child: userImageUrl == null
                    ? Icon(
                        Icons.person,
                        color: actionColor,
                        size: 50 * scale,
                      )
                    : Container(),
              ),
              SizedBox(
                height: 15.0 * scale,
              ),
              Text(
                displayName ?? '',
                style: textTheme.bodyText1,
              )
            ],
          ),
          SizedBox(
            height: 30.0 * scale,
          ),
          Text(
            'ACCOUNT',
            style: textTheme.bodyText1!.apply(
              color: colorSchemeExtension.textSecondary,
            ),
          ),
          const SizedBox(
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
          const SizedBox(
            height: 10.0,
          ),
          if (isUserUsedEmailProvider)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(16.0 * scale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0 * scale),
                      ),
                    ),
                    foregroundColor: colorScheme.secondary,
                  ),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileChangePasswordView(),
                      ),
                    );
                  },
                  child: Text(
                    'Modifica Password',
                    style: textTheme.caption!.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
