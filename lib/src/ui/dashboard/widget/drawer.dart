import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppDrawer extends StatelessWidget {
  final AppMenuOption menuOption;
  final void Function(AppMenuOption) onPressed;
  final double closeSize = 40.0;
  const AppDrawer({
    Key? key,
    required this.menuOption,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.85,
      child: Column(
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              for (var item in AppMenuOption.values)
                _AppDrawerItem(
                  selected: menuOption == item,
                  title: _ItemInfo(item).title,
                  icon: _ItemInfo(item).icon,
                  onPressed: () {
                    onPressed(item);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 29.0,
              right: 24.0,
            ),
            child: const Divider(),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 35.0,
              left: 47.0,
              right: 46.0,
            ),
            child: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
              onTap: () {},
              child: Container(
                // margin: const EdgeInsets.only(
                //   left: 47.0,
                //   right: 46.0,
                // ),
                padding: EdgeInsets.all(20),
                child: Image.asset('assets/images/fiab_more.png'),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 10,
                    width: 50.0,
                    margin: const EdgeInsets.only(
                      left: 24.0,
                      bottom: 20.0,
                    ),
                    child: Image.asset('assets/images/mondora_logo.png'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppDrawerItem extends StatelessWidget {
  final bool selected;
  final String title;
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
    return Container(
      margin: const EdgeInsets.only(
        left: 12.0,
        right: 24.0,
      ),
      child: ListTile(
        tileColor:
            selected == true ? Theme.of(context).colorScheme.primary : null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        title: Row(
          children: [
            icon,
            const SizedBox(
              width: 12,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}

class _ItemInfo {
  late String title;
  late Widget icon;
  final iconSize = 24.0;

  _ItemInfo(AppMenuOption appMenuOption) {
    switch (appMenuOption) {
      case AppMenuOption.home:
        title = 'Home';
        icon = SvgPicture.asset(
          'assets/icons/home.svg',
          height: iconSize,
          width: iconSize,
        );
        break;
      case AppMenuOption.classification:
        title = 'Classifica';
        icon = SvgPicture.asset(
          'assets/icons/classification.svg',
          height: iconSize,
          width: iconSize,
        );
        break;
      case AppMenuOption.activity:
        title = 'Attività';
        icon = SvgPicture.asset(
          'assets/icons/activity.svg',
          height: iconSize,
          width: iconSize,
        );
        break;
      case AppMenuOption.profile:
        title = 'Profilo';
        icon = SvgPicture.asset(
          'assets/icons/profile.svg',
          height: iconSize,
          width: iconSize,
        );
        break;
      case AppMenuOption.settings:
        title = 'Impostazioni';
        icon = SvgPicture.asset(
          'assets/icons/settings.svg',
          height: iconSize,
          width: iconSize,
        );
        break;
      case AppMenuOption.information:
        title = 'Info';
        icon = SvgPicture.asset(
          'assets/icons/information.svg',
          height: iconSize,
          width: iconSize,
        );
        break;
      case AppMenuOption.logout:
        title = 'Esci';
        icon = SvgPicture.asset(
          'assets/icons/logout.svg',
          height: iconSize,
          width: iconSize,
        );
        break;
    }
  }
}
