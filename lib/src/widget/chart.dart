import 'package:cycletowork/src/data/chart_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

enum ChartType {
  co2,
  distant,
  speed,
  altitude,
}

enum ChartScaleType {
  week,
  month,
  year,
  time,
}

class Chart extends StatelessWidget {
  final ChartType type;
  final ChartScaleType scaleType;
  final double height;
  final List<ChartData> chartData;
  const Chart({
    Key? key,
    this.height = 130,
    required this.type,
    required this.chartData,
    required this.scaleType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatterY = charts.BasicNumericTickFormatterSpec(
      (value) {
        switch (scaleType) {
          case ChartScaleType.week:
            if (value == 0) {
              return "L";
            } else if (value == 1) {
              return "M";
            } else if (value == 2) {
              return "M";
            } else if (value == 3) {
              return "G";
            } else if (value == 4) {
              return "V";
            } else if (value == 5) {
              return "S";
            } else if (value == 6) {
              return "D";
            }
            return "L";

          case ChartScaleType.month:
            return 'S ${(value! + 1).toStringAsFixed(0)}';

          case ChartScaleType.year:
            if (value == 0) {
              return "G";
            } else if (value == 1) {
              return "F";
            } else if (value == 2) {
              return "M";
            } else if (value == 3) {
              return "A";
            } else if (value == 4) {
              return "M";
            } else if (value == 5) {
              return "G";
            } else if (value == 6) {
              return "L";
            } else if (value == 7) {
              return "A";
            } else if (value == 8) {
              return "S";
            } else if (value == 9) {
              return "O";
            } else if (value == 10) {
              return "N";
            } else if (value == 11) {
              return "D";
            }

            return "L";

          case ChartScaleType.time:
            return value.toString();
        }
      },
    );

    var date = DateTime.now();
    var dayOfMonth = DateTime(date.year, date.month + 1, 0).day;

    if (type == ChartType.speed || type == ChartType.altitude) {
      return SizedBox(
        height: height,
        child: charts.TimeSeriesChart(
          _getChatTimeSeriesList(context, chartData, type),
          animate: true,
          defaultRenderer: charts.LineRendererConfig(
            includePoints: true,
            includeArea: true,
            includeLine: true,
            roundEndCaps: true,
            stacked: true,
          ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec: const charts.BasicNumericTickProviderSpec(
              desiredMinTickCount: 3,
              dataIsInWholeNumbers: false,
            ),
            viewport: type == ChartType.speed
                ? const charts.NumericExtents(0, 60)
                : const charts.NumericExtents(0, 1000),
          ),
          //   domainAxis: charts.NumericAxisSpec(
          //   tickProviderSpec: charts.BasicNumericTickProviderSpec(
          //     desiredTickCount: scaleType == ChartScaleType.week
          //         ? 7
          //         : scaleType == ChartScaleType.month
          //             ? 4 // (dayOfMonth / 7).toInt()
          //             : 12,
          //   ),
          //   tickFormatterSpec: formatterY,
          // ),
          customSeriesRenderers: [
            charts.PointRendererConfig(
              customRendererId: 'customPoint',
            ),
          ],
          dateTimeFactory: const charts.LocalDateTimeFactory(),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: charts.LineChart(
        _getChatSeriesList(context, chartData, type),
        animate: true,
        defaultRenderer: charts.LineRendererConfig(
          includePoints: true,
          includeArea: true,
          includeLine: true,
          roundEndCaps: true,
          stacked: true,
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          tickProviderSpec: const charts.BasicNumericTickProviderSpec(
            desiredMinTickCount: 3,
            dataIsInWholeNumbers: false,
          ),
          viewport: type == ChartType.co2
              ? const charts.NumericExtents(0.0, 1.0)
              : const charts.NumericExtents(0, 60),
        ),
        domainAxis: charts.NumericAxisSpec(
          tickProviderSpec: charts.BasicNumericTickProviderSpec(
            desiredTickCount: scaleType == ChartScaleType.week
                ? 7
                : scaleType == ChartScaleType.month
                    ? 4 // (dayOfMonth / 7).toInt()
                    : 12,
          ),
          tickFormatterSpec: formatterY,
        ),
      ),
    );
  }

  List<charts.Series<dynamic, num>> _getChatSeriesList(
    BuildContext context,
    List<ChartData> chartData,
    ChartType type,
  ) {
    var secondaryColor = Theme.of(context).colorScheme.secondary;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final successColor = colorSchemeExtension.success;

    final color = type == ChartType.co2 ? secondaryColor : successColor;

    return [
      charts.Series<ChartData, int>(
        id: 'chart$type',
        colorFn: (_, __) => charts.Color(
          r: color.red,
          g: color.green,
          b: color.blue,
        ),
        domainFn: (ChartData sales, _) => sales.x,
        measureFn: (ChartData sales, _) => sales.y,
        data: chartData,
      ),
    ];
  }

  List<charts.Series<dynamic, DateTime>> _getChatTimeSeriesList(
    BuildContext context,
    List<ChartData> chartData,
    ChartType type,
  ) {
    var secondaryColor = Theme.of(context).colorScheme.secondary;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final successColor = colorSchemeExtension.success;

    final color = type == ChartType.speed ? secondaryColor : successColor;

    return [
      charts.Series<ChartData, DateTime>(
        id: 'chart$type',
        colorFn: (_, __) => charts.Color(
          r: color.red,
          g: color.green,
          b: color.blue,
        ),
        domainFn: (ChartData sales, _) => sales.x,
        measureFn: (ChartData sales, _) => sales.y,
        data: chartData,
      ),
    ];
  }
}
