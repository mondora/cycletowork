import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/activity/widget/activity_list.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/details_tracking/view.dart';
import 'package:cycletowork/src/widget/chart.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    var scale = context.read<AppData>().scale;
    final dashboardModel = Provider.of<ViewModel>(context);
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    var listUserActivity = dashboardModel.uiState.listUserActivityFiltered;
    var listUserActivityAll = dashboardModel.uiState.listUserActivity;
    bool isNotEmptyList = listUserActivityAll.isNotEmpty;
    bool justChallenges = isNotEmptyList &&
        dashboardModel.uiState.userActivityFilteredJustChallenges;
    ChartScaleType chartScaleType =
        dashboardModel.uiState.userActivityFilteredChartScaleType;

    var userActivtyCo2ChartData =
        dashboardModel.uiState.userActivityChartData.listCo2ChartData;
    var userActivtyDistanceChartData =
        dashboardModel.uiState.userActivityChartData.listDistanceChartData;

    var isRegistredToChallenge =
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
              'Attività',
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
                        await dashboardModel.getListUserActivityFilterd(
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
                        await dashboardModel.getListUserActivityFilterd(
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
                        await dashboardModel.getListUserActivityFilterd(
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
              'Risparmio di CO\u2082(Kg)',
              style: textTheme.caption,
            ),
            Chart(
              type: ChartType.co2,
              chartData: userActivtyCo2ChartData,
              scaleType: chartScaleType,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'Chilometri percorsi',
              style: textTheme.caption,
            ),
            Chart(
              type: ChartType.distant,
              chartData: userActivtyDistanceChartData,
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
                      builder: (context) => DetailsTrackingView(
                        userActivity: userActivity,
                      ),
                    ),
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
