import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SummeryCard extends StatelessWidget {
  final String co2;
  final String distance;
  final String averageSpeed;
  const SummeryCard({
    Key? key,
    required this.co2,
    required this.distance,
    required this.averageSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final infoColor = colorSchemeExtension.info;

    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/co2.svg',
              height: 56.0,
              width: 56.0,
              color: infoColor,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              co2,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: infoColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const SizedBox(
          height: 13,
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                distance,
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                width: 40,
              ),
              const VerticalDivider(
                thickness: 1.0,
              ),
              const SizedBox(
                width: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    averageSpeed,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    'VEL. MEDIA',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
