import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/chart_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/activity/widget/activity_list.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/activity_details/view.dart';
import 'package:cycletowork/src/widget/chart.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({Key? key}) : super(key: key);

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_loadMoreUserActivity);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMoreUserActivity);
    super.dispose();
  }

  _loadMoreUserActivity() {
    if (_controller.position.maxScrollExtent == _controller.position.pixels) {
      final dashboardModel = Provider.of<ViewModel>(
        context,
        listen: false,
      );
      dashboardModel.getListUserActivityFilterd(
        nextPage: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final measurementUnit = context.read<AppData>().measurementUnit;
    final dashboardModel = Provider.of<ViewModel>(context);
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final listUserActivity = dashboardModel.uiState.listUserActivityFiltered;
    final listUserActivityAll = dashboardModel.uiState.listUserActivity;
    final isNotEmptyList = listUserActivityAll.isNotEmpty;
    final justChallenges = isNotEmptyList &&
        dashboardModel.uiState.userActivityFilteredJustChallenges;
    final chartScaleType =
        dashboardModel.uiState.userActivityFilteredChartScaleType;

    final userActivtyCo2KgChartData =
        dashboardModel.uiState.userActivityChartData.listCo2ChartData;
    final userActivtyCo2PoundChartData = dashboardModel
        .uiState.userActivityChartData.listCo2ChartData
        .map((e) => ChartData(e.x, e.y.toDouble().kgToPound()))
        .toList();
    final userActivtyDistanceKmChartData =
        dashboardModel.uiState.userActivityChartData.listDistanceChartData;
    final userActivtyDistanceMileChartData = dashboardModel
        .uiState.userActivityChartData.listDistanceChartData
        .map((e) => ChartData(e.x, e.y.toDouble().kmToMile()))
        .toList();
    final isRegistredToChallenge =
        dashboardModel.uiState.listChallengeRegistred.isNotEmpty;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 4,
        toolbarHeight: isRegistredToChallenge ? 112.0 * scale : 60.0 * scale,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10 * scale,
            ),
            Text(
              AppLocalizations.of(context)!.activity,
              style: textTheme.headline5,
            ),
            SizedBox(
              height: 10 * scale,
            ),
            if (isRegistredToChallenge)
              Container(
                margin: EdgeInsets.only(
                  top: 10.0 * scale,
                  bottom: 30.0 * scale,
                ),
                child: InputChip(
                  onSelected: (bool value) async {
                    await dashboardModel.getListUserActivityFilterd(
                      justChallenges: value,
                    );
                    await dashboardModel.getListUserActivityChartData(
                      justChallenges: value,
                    );
                  },
                  selected: justChallenges,
                  side: ChipTheme.of(context).shape!.side.copyWith(
                        color: justChallenges ? Colors.transparent : null,
                      ),
                  label: const Text(
                    'Filtra attività valide per la challenge',
                  ),
                ),
              ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
        child: ListView(
          controller: _controller,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              'Progressi',
              style: textTheme.headline6,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InputChip(
                    onSelected: (bool value) async {
                      if (value) {
                        await dashboardModel.getListUserActivityChartData(
                          chartScaleType: ChartScaleType.week,
                        );
                      }
                    },
                    selected: chartScaleType == ChartScaleType.week,
                    label: const Text(
                      'Questa settimana',
                    ),
                    side: ChipTheme.of(context).shape!.side.copyWith(
                          color: chartScaleType == ChartScaleType.week
                              ? Colors.transparent
                              : null,
                        ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  InputChip(
                    onSelected: (bool value) async {
                      if (value) {
                        await dashboardModel.getListUserActivityChartData(
                          chartScaleType: ChartScaleType.month,
                        );
                      }
                    },
                    selected: chartScaleType == ChartScaleType.month,
                    label: const Text(
                      'Questo mese',
                    ),
                    side: ChipTheme.of(context).shape!.side.copyWith(
                          color: chartScaleType == ChartScaleType.month
                              ? Colors.transparent
                              : null,
                        ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  InputChip(
                    onSelected: (bool value) async {
                      if (value) {
                        await dashboardModel.getListUserActivityChartData(
                          chartScaleType: ChartScaleType.year,
                        );
                      }
                    },
                    selected: chartScaleType == ChartScaleType.year,
                    label: const Text(
                      'Quest’anno',
                    ),
                    side: ChipTheme.of(context).shape!.side.copyWith(
                          color: chartScaleType == ChartScaleType.year
                              ? Colors.transparent
                              : null,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Text(
              'Risparmio di CO\u2082(${measurementUnit == AppMeasurementUnit.metric ? 'Kg' : 'lb'})',
              style: textTheme.caption,
            ),
            Chart(
              type: ChartType.co2,
              chartData: measurementUnit == AppMeasurementUnit.metric
                  ? userActivtyCo2KgChartData
                  : userActivtyCo2PoundChartData,
              scaleType: chartScaleType,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              '${measurementUnit == AppMeasurementUnit.metric ? 'Chilometri' : 'Miglia'} percorsi',
              style: textTheme.caption,
            ),
            Chart(
              type: ChartType.distant,
              chartData: measurementUnit == AppMeasurementUnit.metric
                  ? userActivtyDistanceKmChartData
                  : userActivtyDistanceMileChartData,
              scaleType: chartScaleType,
            ),
            const SizedBox(
              height: 30.0,
            ),
            Text(
              'Corse',
              style: textTheme.headline5,
            ),
            const SizedBox(
              height: 20.0,
            ),
            if (listUserActivity.isNotEmpty)
              ActivityList(
                userActivity: listUserActivity,
                onUserActivityClick: (userActivity) async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ActivityDetailsView(
                        userActivity: userActivity,
                      ),
                    ),
                  );
                  dashboardModel.refreshUserActivityFromLocal(
                    userActivity.userActivityId,
                  );
                },
              ),
            if (listUserActivity.isEmpty)
              Container(
                height: 115.0 * scale,
                padding:
                    EdgeInsets.only(left: 34.0 * scale, right: 27.0 * scale),
                color: Colors.grey[200],
                child: Center(
                  child: Text(
                    'Non hai ancora registrato nessuna pedalata',
                    style: textTheme.headline5!.copyWith(
                      color: colorSchemeExtension.textDisabled,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (dashboardModel.uiState.loading)
              Padding(
                padding: EdgeInsets.only(top: 20 * scale),
                child: const Center(
                  child: AppProgressIndicator(),
                ),
              ),
            SizedBox(
              height: 90.0 * scale,
            ),
          ],
        ),
      ),
    );
  }
}
