import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SummaryCard extends StatelessWidget {
  final String co2;
  final String distance;
  final String averageSpeed;
  const SummaryCard({
    Key? key,
    required this.co2,
    required this.distance,
    required this.averageSpeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final infoColor = colorSchemeExtension.info;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        SizedBox(
          height: 15 * scale,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/co2.svg',
              height: 56.0 * scale,
              width: 56.0 * scale,
              color: infoColor,
            ),
            SizedBox(
              width: 6 * scale,
            ),
            Text(
              co2,
              style: textTheme.headline4!.copyWith(
                color: infoColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 13 * scale,
        ),
        SizedBox(
          height: 48.0 * scale,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: VerticalDivider(
                  thickness: 1.0,
                  width: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              Stack(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Center(
                          child: Text(
                            distance,
                            style: textTheme.headline5,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                averageSpeed,
                                style: textTheme.headline5,
                              ),
                              Text(
                                'VEL. MEDIA',
                                style: textTheme.caption!.apply(
                                  color: colorSchemeExtension.textDisabled,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10 * scale,
        ),
      ],
    );
  }
}
