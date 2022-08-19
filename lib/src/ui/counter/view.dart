import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/widget/slider_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CounterView extends StatelessWidget {
  final int counter;
  final Function(int) setCounter;
  final Key dismissKey;

  const CounterView({
    Key? key,
    required this.counter,
    required this.setCounter,
    required this.dismissKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final actionColor = colorSchemeExtension.action;

    return Scaffold(
      body: Center(
        child: Text(
          counter != 0 ? counter.toString() : 'VAI!',
          style: textTheme.headline1!.copyWith(
            color: colorScheme.secondary,
            fontSize: 128.0,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SliderButton(
        dismissKey: dismissKey,
        onDismissed: (dismissDirection) {
          if (dismissDirection == DismissDirection.startToEnd) {
            setCounter(0);
          } else {
            setCounter(10);
          }
        },
        leftWidget: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/icons/timer.svg',
              height: 24.0,
              width: 24.0,
              color: actionColor,
            ),
            const SizedBox(
              width: 6.0,
            ),
            Text(
              'Ritarda 10”'.toUpperCase(),
              style: textTheme.caption!.apply(
                color: actionColor,
              ),
            ),
          ],
        ),
        rightWidget: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Parti subito'.toUpperCase(),
              style: textTheme.caption!.apply(
                color: actionColor,
              ),
            ),
            const SizedBox(
              width: 6.0,
            ),
            SvgPicture.asset(
              'assets/icons/bike.svg',
              height: 24.0,
              width: 24.0,
              color: actionColor,
            ),
          ],
        ),
      ),
    );
  }
}
