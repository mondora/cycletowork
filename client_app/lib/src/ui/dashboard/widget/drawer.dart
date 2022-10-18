import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  final AppMenuOption menuOption;
  final void Function(AppMenuOption) onPressed;
  final double closeSize = 40.0;
  final fiabWorld = 'https://www.fiabitalia.it';
  const AppDrawer({
    Key? key,
    required this.menuOption,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final screenWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: colorScheme.background,
      width: screenWidth * 0.85,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: closeSize,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    SizedBox(
                      height: closeSize,
                      width: closeSize,
                      child: IconButton(
                        splashRadius: closeSize / 2,
                        iconSize: closeSize,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/close.svg',
                          height: closeSize,
                          width: closeSize,
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    for (var item in AppMenuOption.values)
                      _AppDrawerItem(
                        selected: menuOption == item,
                        title: _ItemInfo(
                          item,
                          scale,
                          menuOption == item
                              ? Colors.black
                              : colorScheme.onBackground,
                          Theme.of(context).textTheme.bodyText1!.apply(
                                color: menuOption == item
                                    ? Colors.black
                                    : colorScheme.onBackground,
                              ),
                        ).title,
                        icon: _ItemInfo(
                          item,
                          scale,
                          menuOption == item
                              ? Colors.black
                              : colorScheme.onBackground,
                          Theme.of(context).textTheme.bodyText1!.apply(
                                color: menuOption == item
                                    ? Colors.black
                                    : colorScheme.onBackground,
                              ),
                        ).icon,
                        onPressed: () {
                          onPressed(item);
                          Navigator.pop(context);
                        },
                      ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 29.0 * scale,
                        right: 24.0 * scale,
                      ),
                      child: const Divider(),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 35.0 * scale,
                        left: 47.0 * scale,
                        right: 46.0 * scale,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0 * scale),
                        ),
                        onTap: () async {
                          try {
                            final url = Uri.parse(fiabWorld);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                              );
                            }
                          } catch (e) {
                            Logger.error(e);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(20 * scale),
                          child: Image.asset('assets/images/fiab_more.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 10 * scale,
              width: 50.0 * scale,
              margin: EdgeInsets.only(
                left: 24.0 * scale,
                bottom: 20.0 * scale,
              ),
              child: Image.asset(
                'assets/images/mondora_logo.png',
                color: colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppDrawerItem extends StatelessWidget {
  final bool selected;
  final Widget title;
  final Widget icon;
  final GestureTapCallback? onPressed;
  const _AppDrawerItem({
    Key? key,
    required this.selected,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    return Container(
      margin: EdgeInsets.only(
        left: 12.0 * scale,
        right: 24.0 * scale,
      ),
      child: ListTile(
        dense: scale < 1 ? true : null,
        tileColor:
            selected == true ? Theme.of(context).colorScheme.primary : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0 * scale),
          ),
        ),
        title: Row(
          children: [
            icon,
            SizedBox(
              width: 12 * scale,
            ),
            title,
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}

class _ItemInfo {
  late Widget title;
  late Widget icon;

  _ItemInfo(
    AppMenuOption appMenuOption,
    double scale,
    Color color,
    TextStyle textStyle,
  ) {
    final iconSize = 24.0 * scale;
    switch (appMenuOption) {
      case AppMenuOption.home:
        title = Text(
          'Home',
          style: textStyle,
        );
        icon = SvgPicture.asset(
          'assets/icons/home.svg',
          height: iconSize,
          width: iconSize,
          color: color,
        );
        break;
      case AppMenuOption.classification:
        title = Text(
          'Classifica',
          style: textStyle,
        );
        icon = SvgPicture.asset(
          'assets/icons/classification.svg',
          height: iconSize,
          width: iconSize,
          color: color,
        );
        break;
      case AppMenuOption.activity:
        title = Text(
          'Attività',
          style: textStyle,
        );
        icon = SvgPicture.asset(
          'assets/icons/activity.svg',
          height: iconSize,
          width: iconSize,
          color: color,
        );
        break;
      case AppMenuOption.profile:
        title = Text(
          'Profilo',
          style: textStyle,
        );
        icon = SvgPicture.asset(
          'assets/icons/profile.svg',
          height: iconSize,
          width: iconSize,
          color: color,
        );
        break;
      case AppMenuOption.settings:
        title = Text(
          'Impostazioni',
          style: textStyle,
        );
        icon = SvgPicture.asset(
          'assets/icons/settings.svg',
          height: iconSize,
          width: iconSize,
          color: color,
        );
        break;
      case AppMenuOption.information:
        title = Text(
          'Info',
          style: textStyle,
        );
        icon = SvgPicture.asset(
          'assets/icons/information.svg',
          height: iconSize,
          width: iconSize,
          color: color,
        );
        break;
      case AppMenuOption.logout:
        title = Text(
          'Esci',
          style: textStyle,
        );
        icon = SvgPicture.asset(
          'assets/icons/logout.svg',
          height: iconSize,
          width: iconSize,
          color: color,
        );
        break;
    }
  }
}
