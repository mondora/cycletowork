import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AppBottomNavBar extends StatelessWidget {
  final AppBottomNavBarOption? bottomNavBarOption;
  final void Function(AppBottomNavBarOption) onChange;
  final GestureTapCallback? onPressed;
  final bool floatActionButtonEnabled;
  final bool isCenter;

  const AppBottomNavBar({
    Key? key,
    required this.bottomNavBarOption,
    required this.onChange,
    required this.floatActionButtonEnabled,
    required this.onPressed,
    required this.isCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment:
          isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            right: 24.0 * scale,
            left: 24.0 * scale,
            bottom: 20.0 * scale,
          ),
          padding: EdgeInsets.all(5 * scale),
          decoration: BoxDecoration(
            color: colorScheme.brightness == Brightness.light
                ? colorScheme.background
                : Colors.black,
            borderRadius: BorderRadius.circular(15.0 * scale),
            boxShadow: const [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
            ],
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 227.0 * scale,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var item in AppBottomNavBarOption.values)
                  _BottomNavBarItem(
                    selected: bottomNavBarOption == item,
                    icon: _ItemInfo(
                      item,
                      scale,
                      bottomNavBarOption == item
                          ? Colors.black
                          : colorScheme.onBackground,
                    ).icon,
                    onPressed: () {
                      onChange(item);
                    },
                  ),
              ],
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
    final scale = context.read<AppData>().scale;
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = selected
        ? colorScheme.primary
        : colorScheme.brightness == Brightness.light
            ? colorScheme.background
            : Colors.black;

    return SizedBox(
      height: 40.0 * scale,
      width: 40.0 * scale,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0 * scale),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0 * scale),
          onTap: onPressed,
          child: icon,
        ),
      ),
    );
  }
}

class _ItemInfo {
  late Widget icon;

  _ItemInfo(
      AppBottomNavBarOption bottomNavBarOption, double scale, Color color) {
    final iconSize = 32.0 * scale;
    switch (bottomNavBarOption) {
      case AppBottomNavBarOption.home:
        icon = SvgPicture.asset(
          'assets/icons/home_32x32.svg',
          height: iconSize,
          width: iconSize,
          color: color,
        );
        break;
      case AppBottomNavBarOption.activity:
        icon = SvgPicture.asset(
          'assets/icons/activity_32x32.svg',
          height: iconSize,
          width: iconSize,
          color: color,
        );
        break;
      case AppBottomNavBarOption.classification:
        icon = SvgPicture.asset(
          'assets/icons/classification_32x32.svg',
          height: iconSize,
          width: iconSize,
          color: color,
        );
        break;
    }
  }
}
