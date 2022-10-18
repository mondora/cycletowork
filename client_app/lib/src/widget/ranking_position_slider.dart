import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RankingPositionSlider extends StatelessWidget {
  final int ranking;
  final String title;
  final bool isEmpty;

  const RankingPositionSlider({
    Key? key,
    required this.ranking,
    required this.title,
    required this.isEmpty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.caption!.copyWith(
            color: colorSchemeExtension.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 8 * scale,
        ),
        SizedBox(
          height: 40 * scale,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(right: 25.0 * scale),
                  height: 25 * scale,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withOpacity(0),
                        colorScheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(21.0 * scale),
                      bottomLeft: Radius.circular(21.0 * scale),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  isEmpty || ranking <= 0 ? '--' : '$ranking°',
                  style: GoogleFonts.robotoCondensed(
                    textStyle: TextStyle(
                      fontSize: 24 * scale,
                      letterSpacing: 0.15,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(
                  'assets/icons/biking.svg',
                  height: 40 * scale,
                  width: 40 * scale,
                  color: colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
