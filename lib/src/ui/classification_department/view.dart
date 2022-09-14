import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/widget/ranking_position_slider.dart';
import 'package:cycletowork/src/widget/ranking_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cycletowork/src/utility/convert.dart';

class DepartmentClassificationView extends StatefulWidget {
  const DepartmentClassificationView({Key? key}) : super(key: key);

  @override
  State<DepartmentClassificationView> createState() =>
      _DepartmentClassificationViewState();
}

class _DepartmentClassificationViewState
    extends State<DepartmentClassificationView> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_loadMoreClassification);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMoreClassification);
    super.dispose();
  }

  _loadMoreClassification() {
    if (_controller.position.maxScrollExtent == _controller.position.pixels) {
      final dashboardModel = Provider.of<ViewModel>(
        context,
        listen: false,
      );
      dashboardModel.refreshDepartmentClassification(
        nextPage: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    var colorScheme = Theme.of(context).colorScheme;
    final Locale appLocale = Localizations.localeOf(context);
    final distanceNumberFormat = NumberFormat(
      '##0',
      appLocale.languageCode,
    );
    final co2NumberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );

    var selectedColor = const Color.fromRGBO(199, 21, 172, 1);
    var firstColor = const Color.fromRGBO(57, 73, 171, 1);
    var maxValueWidget = CircleAvatar(
      backgroundColor: firstColor,
      child: SvgPicture.asset(
        'assets/icons/build.svg',
        height: 18.0,
        width: 18.0,
        color: colorScheme.onPrimary,
      ),
    );
    var valueWidget = CircleAvatar(
      backgroundColor: selectedColor,
      child: SvgPicture.asset(
        'assets/icons/build.svg',
        height: 18.0,
        width: 18.0,
        color: colorScheme.onPrimary,
      ),
    );

    var listDepartmentClassificationRankingCo2 =
        viewModel.uiState.listDepartmentClassification;

    var firstRankingCo2 = listDepartmentClassificationRankingCo2.isNotEmpty
        ? listDepartmentClassificationRankingCo2.first
        : null;

    var userValues = viewModel.uiState.userDepartmentClassification!;
    var userRankingCo2 = userValues.rankingCo2;

    var userRankingCo2Finded = userRankingCo2 != 0
        ? userRankingCo2
        : listDepartmentClassificationRankingCo2.isNotEmpty
            ? listDepartmentClassificationRankingCo2.indexWhere(
                  (e) => e.name == userValues.name,
                ) +
                1
            : 0;

    var expandedHeight = 235.0;
    var isVisible = true;

    return NestedScrollView(
      controller: _controller,
      floatHeaderSlivers: true,
      clipBehavior: Clip.none,
      headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
        SliverAppBar(
          pinned: true,
          snap: true,
          floating: true,
          expandedHeight: expandedHeight,
          collapsedHeight: 160.0,
          elevation: 1,
          forceElevated: true,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.biggest.height == expandedHeight) {
                isVisible = true;
              } else {
                isVisible = false;
              }
              return FlexibleSpaceBar(
                centerTitle: true,
                expandedTitleScale: 1,
                collapseMode: CollapseMode.none,
                title: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      RankingSlider(
                        percent: firstRankingCo2 != null
                            ? userValues.co2 / firstRankingCo2.co2
                            : 0,
                        maxValue: firstRankingCo2 != null
                            ? co2NumberFormat
                                .format(firstRankingCo2.co2.gramToKg())
                            : '',
                        value:
                            co2NumberFormat.format(userValues.co2.gramToKg()),
                        title: 'CO\u2082 risparmiata (Kg)',
                        isEmpty: firstRankingCo2 == null ||
                            firstRankingCo2.co2.gramToKg() < 0.01,
                        maxValueWidget: maxValueWidget,
                        valueWidget: valueWidget,
                        isFirst: userRankingCo2 != 0
                            ? userRankingCo2 == 1
                            : listDepartmentClassificationRankingCo2
                                    .isNotEmpty &&
                                listDepartmentClassificationRankingCo2
                                        .first.name ==
                                    userValues.name,
                      ),
                      if (isVisible)
                        Column(
                          key: UniqueKey(),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            RankingSlider(
                              percent: firstRankingCo2 != null
                                  ? userValues.distance /
                                      firstRankingCo2.distance
                                  : 0,
                              maxValue: firstRankingCo2 != null
                                  ? distanceNumberFormat.format(
                                      firstRankingCo2.distance.meterToKm(),
                                    )
                                  : '',
                              value: distanceNumberFormat.format(
                                userValues.distance.meterToKm(),
                              ),
                              title: 'Chilometri percorsi',
                              isEmpty: firstRankingCo2 == null ||
                                  firstRankingCo2.distance.meterToKm() < 0.9,
                              maxValueWidget: maxValueWidget,
                              valueWidget: valueWidget,
                              isFirst: userRankingCo2 != 0
                                  ? userRankingCo2 == 1
                                  : listDepartmentClassificationRankingCo2
                                          .isNotEmpty &&
                                      listDepartmentClassificationRankingCo2
                                              .first.name ==
                                          userValues.name,
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      RankingPositionSlider(
                        ranking: userRankingCo2Finded,
                        isEmpty: listDepartmentClassificationRankingCo2.isEmpty,
                        title: 'Posizione in classifica',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
      body: RefreshIndicator(
          onRefresh: viewModel.refreshDepartmentClassification,
          color: colorScheme.secondary,
          displacement: 0,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80.0),
            itemCount: listDepartmentClassificationRankingCo2.length,
            itemBuilder: (context, index) {
              var item = listDepartmentClassificationRankingCo2[index];
              return _Card(
                // ranking: item.rankingCo2,
                ranking: index + 1,
                title: item.name,
                subtitle:
                    '${distanceNumberFormat.format(item.distance.meterToKm())} km',
                value:
                    '${co2NumberFormat.format(item.co2.gramToKg())} Kg CO\u2082',
                isRankingCo2: true,
                selected: item.rankingCo2 != 0
                    ? item.rankingCo2 == userRankingCo2
                    : item.name == userValues.name,
                color: item.color,
              );
            },
          )),
    );
  }
}

class _Card extends StatelessWidget {
  static const selectedColor = Color.fromRGBO(199, 21, 172, 1);
  static const firstColor = Color.fromRGBO(57, 73, 171, 1);
  final int ranking;
  final String title;
  final String subtitle;
  final String value;
  final bool isRankingCo2;
  final bool selected;
  final Color color;

  const _Card({
    Key? key,
    required this.ranking,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isRankingCo2,
    required this.selected,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      height: 70.0,
      color: selected
          ? colorScheme.secondary.withOpacity(0.08)
          : colorScheme.background,
      child: Column(
        children: [
          SizedBox(
            height: 69.0,
            child: Row(
              children: [
                SizedBox(
                  width: 60.0,
                  child: Text(
                    ranking.toString(),
                    style: textTheme.bodyText1!.copyWith(
                      color: selected
                          ? colorScheme.secondary
                          : colorSchemeExtension.textPrimary,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: ranking == 1
                        ? firstColor
                        : selected
                            ? selectedColor
                            : color,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/build.svg',
                      height: 24.0,
                      width: 24.0,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? colorScheme.secondary
                              : colorSchemeExtension.textPrimary,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subtitle,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            style: textTheme.caption!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: colorSchemeExtension.textSecondary,
                            ),
                          ),
                          if (isRankingCo2)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 10.0,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/co2.svg',
                                  height: 24.0,
                                  width: 24.0,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  value,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: textTheme.caption!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: colorSchemeExtension.info,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                              ],
                            ),
                          if (!isRankingCo2)
                            SizedBox(
                              width: 35.0,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
