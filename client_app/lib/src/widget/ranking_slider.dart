import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingSlider extends StatelessWidget {
  final double percent;
  final String maxValue;
  final Widget maxValueWidget;
  final String value;
  final Widget valueWidget;
  final String title;
  final bool isEmpty;
  final bool isFirst;

  const RankingSlider({
    Key? key,
    required this.percent,
    required this.maxValue,
    required this.value,
    required this.title,
    required this.isEmpty,
    required this.maxValueWidget,
    required this.valueWidget,
    required this.isFirst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    const minPercentFilter = 0.08;

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
          height: 5 * scale,
        ),
        SizedBox(
          height: 30 * scale,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              var width = constraints.biggest.width;
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      height: 20 * scale,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0 * scale),
                        ),
                      ),
                    ),
                  ),
                  if (!isFirst)
                    Positioned(
                      left: 0,
                      right: isEmpty || percent < minPercentFilter
                          ? null
                          : width - (width * percent),
                      top: 5 * scale,
                      child: Container(
                        height: 20 * scale,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0 * scale),
                          ),
                        ),
                      ),
                    ),
                  if (percent >= 0.2 && !isEmpty && !isFirst)
                    Positioned(
                      top: 6,
                      right: width - (width * percent) + 35,
                      child: Center(
                        child: Text(
                          isEmpty ? '--' : value,
                          style: textTheme.caption,
                        ),
                      ),
                    ),
                  if (!isFirst)
                    Positioned(
                      left: percent <= minPercentFilter || isEmpty ? 0 : null,
                      right: percent > minPercentFilter && !isEmpty
                          ? width - (width * percent)
                          : null,
                      child: Container(
                        width: 30 * scale,
                        height: 30 * scale,
                        decoration: BoxDecoration(
                          color: colorScheme.background,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: valueWidget,
                        ),
                      ),
                    ),
                  if (isEmpty && !isFirst)
                    Positioned(
                      top: 6 * scale,
                      left: 35 * scale,
                      child: Center(
                        child: Text(
                          '--',
                          style: textTheme.caption!.copyWith(
                            color: colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  if (percent <= 0.8 || isFirst)
                    Positioned(
                      top: 6 * scale,
                      right: 35 * scale,
                      child: Center(
                        child: Text(
                          isEmpty ? '--' : maxValue,
                          style: textTheme.caption!.copyWith(
                            color: colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 30 * scale,
                      height: 30 * scale,
                      decoration: BoxDecoration(
                        color: colorScheme.background,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: maxValueWidget,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
