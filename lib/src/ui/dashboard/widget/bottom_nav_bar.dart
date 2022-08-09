import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum AppBottomNavBarOption {
  home,
  activity,
  classification,
}

class AppBottomNavBar extends StatelessWidget {
  final AppBottomNavBarOption? bottomNavBarOption;
  final void Function(AppBottomNavBarOption) onPressed;
  final bool floatActionButtonEnabled;
  const AppBottomNavBar({
    Key? key,
    required this.bottomNavBarOption,
    required this.onPressed,
    required this.floatActionButtonEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          // height: 50.0,
          margin: const EdgeInsets.only(
            right: 24.0,
            left: 24.0,
            bottom: 20.0,
          ),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: const [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
            ],
          ),

          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 220.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var item in AppBottomNavBarOption.values)
                  _BottomNavBarItem(
                    selected: bottomNavBarOption == item,
                    icon: _ItemInfo(item).icon,
                    onPressed: () {
                      onPressed(item);
                    },
                  ),
              ],
            ),
          ),
        ),
        Container(
          width: 55.0,
          height: 55.0,
          margin: const EdgeInsets.only(
            right: 20.0,
            left: 20.0,
            bottom: 20.0,
          ),
          child: FloatingActionButton(
            onPressed: floatActionButtonEnabled ? () {} : null,
            child: Text(
              'IN SELLA!',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: Theme.of(context).textTheme.caption!.copyWith(
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomNavBarItem extends StatelessWidget {
  final bool selected;
  final Widget icon;
  final GestureTapCallback? onPressed;
  const _BottomNavBarItem({
    Key? key,
    required this.selected,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      width: 40.0,
      child: Material(
        color: selected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: onPressed,
          child: icon,
        ),
      ),
    );
  }
}

class _ItemInfo {
  late Widget icon;
  final iconSize = 32.0;

  _ItemInfo(AppBottomNavBarOption bottomNavBarOption) {
    switch (bottomNavBarOption) {
      case AppBottomNavBarOption.home:
        icon = SvgPicture.asset(
          'assets/icons/home_32x32.svg',
          height: iconSize,
          width: iconSize,
        );
        break;
      case AppBottomNavBarOption.activity:
        icon = SvgPicture.asset(
          'assets/icons/activity_32x32.svg',
          height: iconSize,
          width: iconSize,
        );
        break;
      case AppBottomNavBarOption.classification:
        icon = SvgPicture.asset(
          'assets/icons/classification_32x32.svg',
          height: iconSize,
          width: iconSize,
        );
        break;
    }
  }
}