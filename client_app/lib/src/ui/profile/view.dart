import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/profile_challenge_edit/view.dart';
import 'package:cycletowork/src/ui/profile_edit/view.dart';
import 'package:cycletowork/src/ui/profile_change_password/view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final viewModel = Provider.of<ViewModel>(context);
    var listChallengeRegistred = viewModel.uiState.listChallengeRegistred;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final actionColor = colorSchemeExtension.action;
    final userImageUrl = AppData.user != null ? AppData.user!.photoURL : null;
    final displayName = AppData.user != null ? AppData.user!.displayName : null;
    final email = AppData.user != null ? AppData.user!.email : null;
    final isUserUsedEmailProvider = AppData.isUserUsedEmailProvider;
    final color = colorScheme.brightness == Brightness.light
        ? colorScheme.secondary
        : colorScheme.primary;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0 * scale),
        physics: const ScrollPhysics(),
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(16.0 * scale),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0 * scale),
                    ),
                  ),
                  foregroundColor: color,
                ),
                onPressed: () async {
                  bool? haveToRefresh = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileEditView(),
                    ),
                  );
                  if (haveToRefresh == true) {
                    context.read<ViewModel>().getUserInfo();
                  }
                },
                child: Text(
                  'Modifica',
                  style: textTheme.caption!.copyWith(
                    color: color,
                  ),
                ),
              ),
            ],
          ),
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
          _ListItem(
            title: 'Email',
            value: email,
          ),
          if (isUserUsedEmailProvider)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ListItem(
                  title: 'Password',
                  value: '*************',
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(16.0 * scale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0 * scale),
                      ),
                    ),
                    foregroundColor: color,
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
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ListView.builder(
            physics: const ScrollPhysics(),
            padding: EdgeInsets.only(top: 20 * scale),
            shrinkWrap: true,
            itemCount: listChallengeRegistred.length,
            itemBuilder: (context, index) {
              var challengeRegistry = listChallengeRegistred[index];
              return _ChallengeRegisterdData(
                challengeRegistry: challengeRegistry,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChallengeRegisterdData extends StatelessWidget {
  final ChallengeRegistry challengeRegistry;

  const _ChallengeRegisterdData({
    Key? key,
    required this.challengeRegistry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now().millisecondsSinceEpoch;
    final isChallengeOpen = challengeRegistry.stopTimeChallenge > now;
    final color = colorScheme.brightness == Brightness.light
        ? colorScheme.secondary
        : colorScheme.primary;
    final backgroundColor = colorScheme.brightness == Brightness.light
        ? const Color.fromRGBO(239, 239, 239, 1)
        : Colors.grey[800];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: backgroundColor,
          height: 100 * scale,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: FloatingActionButton(
                  heroTag: null,
                  mini: true,
                  onPressed: isChallengeOpen
                      ? () async {
                          bool? haveToRefresh =
                              await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileChallengeEditView(
                                challengeRegistry: challengeRegistry,
                              ),
                            ),
                          );
                          if (haveToRefresh == true) {
                            context
                                .read<ViewModel>()
                                .getListChallengeRegistred();
                          }
                        }
                      : null,
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    isChallengeOpen
                        ? Icons.edit_outlined
                        : Icons.edit_off_outlined,
                    color: isChallengeOpen
                        ? color
                        : colorSchemeExtension.textDisabled,
                    size: 20 * scale,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0 * scale),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'I tuoi dati di iscrizione alla challenge',
                      style: textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      challengeRegistry.challengeName,
                      style: textTheme.headline6,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (challengeRegistry.isChampion)
          SizedBox(
            height: 50.0 * scale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Sei il Champion della tua azienda',
                  style: textTheme.bodyText2,
                ),
                SizedBox(
                  width: 10 * scale,
                ),
                const Icon(
                  Icons.verified,
                ),
              ],
            ),
          ),
        _ListItem(
          title: 'Nome',
          value: challengeRegistry.name,
        ),
        _ListItem(
          title: 'Cognome',
          value: challengeRegistry.lastName,
        ),
        _ListItem(
          title: 'Email aziendale',
          value: challengeRegistry.businessEmail,
        ),
        _ListItem(
          title: 'Azienda',
          value: challengeRegistry.companyName,
        ),
        if (challengeRegistry.departmentName.isNotEmpty)
          _ListItem(
            title: 'Dipartimento',
            value: challengeRegistry.departmentName,
          ),
        _ListItem(
          title: 'Città',
          value: challengeRegistry.city,
        ),
        _ListItem(
          title: 'Indirizzo',
          value: challengeRegistry.address,
        ),
        _ListItem(
          title: 'CAP',
          value: challengeRegistry.zipCode,
        ),
        SizedBox(
          height: 80.0 * scale,
        )
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  final String title;
  final String? value;

  const _ListItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5.0 * scale,
        ),
        Text(
          title,
          style: textTheme.caption!.apply(
            color: colorSchemeExtension.textSecondary,
          ),
        ),
        Text(
          value ?? '',
          style: textTheme.bodyText1,
        ),
        SizedBox(
          height: 5.0 * scale,
        ),
      ],
    );
  }
}
