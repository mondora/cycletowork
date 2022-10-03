import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/widget/ranking_position_slider.dart';
import 'package:cycletowork/src/widget/ranking_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cycletowork/src/utility/convert.dart';

class CyclistCompanyView extends StatefulWidget {
  const CyclistCompanyView({Key? key}) : super(key: key);

  @override
  State<CyclistCompanyView> createState() => _CyclistCompanyViewState();
}

class _CyclistCompanyViewState extends State<CyclistCompanyView> {
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
      dashboardModel.refreshCyclistClassification(
        nextPage: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final measurementUnit = context.read<AppData>().measurementUnit;
    final viewModel = Provider.of<ViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final Locale appLocale = Localizations.localeOf(context);
    final distanceNumberFormat = NumberFormat(
      '##0',
      appLocale.languageCode,
    );
    final co2NumberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );

    const firstColor = Color.fromRGBO(57, 73, 171, 1);

    final listCyclistClassificationRankingCo2 =
        viewModel.uiState.listCyclistClassification;

    final firstRankingCo2 = listCyclistClassificationRankingCo2.isNotEmpty
        ? listCyclistClassificationRankingCo2.first
        : null;

    final userValues = viewModel.uiState.userCyclistClassification!;
    final userRankingCo2 = userValues.rankingCo2;

    final maxValueWidget = CircleAvatar(
      backgroundColor:
          firstRankingCo2 == null || firstRankingCo2.photoURL == null
              ? firstRankingCo2 != null
                  ? firstRankingCo2.color.withOpacity(0.65)
                  : firstColor.withOpacity(0.65)
              : null,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(22 * scale),
        ),
        child: firstRankingCo2 != null && firstRankingCo2.photoURL != null
            ? Image.network(firstRankingCo2.photoURL!)
            : Icon(
                Icons.star,
                size: 18.0 * scale,
                color:
                    firstRankingCo2 == null || firstRankingCo2.photoURL == null
                        ? firstRankingCo2 != null
                            ? firstRankingCo2.color
                            : firstColor
                        : null,
              ),
      ),
    );

    final valueColor = userValues.photoURL == null
        ? listCyclistClassificationRankingCo2.isEmpty
            ? userValues.color
            : listCyclistClassificationRankingCo2
                .firstWhere(
                  (e) => e.email == userValues.email,
                  orElse: (() => userValues),
                )
                .color
        : null;

    final valueWidget = CircleAvatar(
      backgroundColor:
          userValues.photoURL == null ? valueColor!.withOpacity(0.65) : null,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(22 * scale),
        ),
        child: userValues.photoURL != null
            ? Image.network(userValues.photoURL!)
            : Icon(
                Icons.star,
                size: 18.0 * scale,
                color: valueColor,
              ),
      ),
    );

    final userRankingCo2Finded = userRankingCo2 != 0
        ? userRankingCo2
        : listCyclistClassificationRankingCo2.isNotEmpty
            ? listCyclistClassificationRankingCo2.indexWhere(
                  (e) => e.email == userValues.email,
                ) +
                1
            : 0;

    final expandedHeight = 235.0 * scale;
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
          collapsedHeight: 160.0 * scale,
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
                  margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20 * scale,
                      ),
                      RankingSlider(
                        percent: firstRankingCo2 != null
                            ? userValues.co2 / firstRankingCo2.co2
                            : 0,
                        maxValue: firstRankingCo2 != null
                            ? co2NumberFormat.format(
                                measurementUnit == AppMeasurementUnit.metric
                                    ? firstRankingCo2.co2.gramToKg()
                                    : firstRankingCo2.co2.gramToPound())
                            : '',
                        value: co2NumberFormat.format(
                          measurementUnit == AppMeasurementUnit.metric
                              ? userValues.co2.gramToKg()
                              : userValues.co2.gramToPound(),
                        ),
                        title:
                            'CO\u2082 risparmiata (${measurementUnit == AppMeasurementUnit.metric ? 'Kg' : 'lb'})',
                        isEmpty: firstRankingCo2 == null ||
                            firstRankingCo2.co2.gramToKg() < 0.01,
                        maxValueWidget: maxValueWidget,
                        valueWidget: valueWidget,
                        isFirst: userRankingCo2 != 0
                            ? userRankingCo2 == 1
                            : listCyclistClassificationRankingCo2.isNotEmpty &&
                                listCyclistClassificationRankingCo2
                                        .first.email ==
                                    userValues.email,
                      ),
                      if (isVisible)
                        Column(
                          key: UniqueKey(),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10 * scale,
                            ),
                            RankingSlider(
                              percent: firstRankingCo2 != null
                                  ? userValues.distance /
                                      firstRankingCo2.distance
                                  : 0,
                              maxValue: firstRankingCo2 != null
                                  ? distanceNumberFormat.format(
                                      measurementUnit ==
                                              AppMeasurementUnit.metric
                                          ? firstRankingCo2.distance.meterToKm()
                                          : firstRankingCo2.distance
                                              .meterToMile(),
                                    )
                                  : '',
                              value: distanceNumberFormat.format(
                                measurementUnit == AppMeasurementUnit.metric
                                    ? userValues.distance.meterToKm()
                                    : userValues.distance.meterToMile(),
                              ),
                              title:
                                  '${measurementUnit == AppMeasurementUnit.metric ? 'Chilometri' : 'Miglia'} percorsi',
                              isEmpty: firstRankingCo2 == null ||
                                  firstRankingCo2.distance.meterToKm() < 0.9,
                              maxValueWidget: maxValueWidget,
                              valueWidget: valueWidget,
                              isFirst: userRankingCo2 != 0
                                  ? userRankingCo2 == 1
                                  : listCyclistClassificationRankingCo2
                                          .isNotEmpty &&
                                      listCyclistClassificationRankingCo2
                                              .first.email ==
                                          userValues.email,
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 10 * scale,
                      ),
                      RankingPositionSlider(
                        ranking: userRankingCo2Finded,
                        isEmpty: listCyclistClassificationRankingCo2.isEmpty,
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
        onRefresh: viewModel.refreshCyclistClassification,
        color: colorScheme.secondary,
        displacement: 0,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 80.0 * scale),
          itemCount: listCyclistClassificationRankingCo2.length,
          itemBuilder: (context, index) {
            final item = listCyclistClassificationRankingCo2[index];
            final subtitle = measurementUnit == AppMeasurementUnit.metric
                ? '${distanceNumberFormat.format(item.distance.meterToKm())} km'
                : '${distanceNumberFormat.format(item.distance.meterToMile())} mi';
            final value = measurementUnit == AppMeasurementUnit.metric
                ? '${co2NumberFormat.format(item.co2.gramToKg())} Kg CO\u2082'
                : '${co2NumberFormat.format(item.co2.gramToPound())} lb CO\u2082';
            return _Card(
              ranking: index + 1,
              title: item.displayName ?? item.email,
              subtitle: subtitle,
              value: value,
              isRankingCo2: true,
              selected: item.rankingCo2 != 0
                  ? item.rankingCo2 == userRankingCo2
                  : item.email == userValues.email,
              color: item.color,
              photoURL: item.photoURL,
            );
          },
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final int ranking;
  final String title;
  final String subtitle;
  final String value;
  final bool isRankingCo2;
  final bool selected;
  final Color color;
  final String? photoURL;

  const _Card({
    Key? key,
    required this.ranking,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isRankingCo2,
    required this.selected,
    required this.color,
    this.photoURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
      height: 70.0 * scale,
      color: selected
          ? colorScheme.secondary.withOpacity(0.08)
          : colorScheme.background,
      child: Column(
        children: [
          SizedBox(
            height: 69.0 * scale,
            child: Row(
              children: [
                SizedBox(
                  width: 60.0 * scale,
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
                SizedBox(
                  width: 10 * scale,
                ),
                Container(
                  height: 40 * scale,
                  width: 40 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40 * scale),
                    ),
                    color: color.withOpacity(0.65),
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40 * scale),
                      ),
                      child: photoURL != null
                          ? Image.network(photoURL!)
                          : Icon(
                              Icons.star,
                              size: 24.0 * scale,
                              color: color,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10 * scale,
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
                                SizedBox(
                                  width: 10.0 * scale,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/co2.svg',
                                  height: 24.0 * scale,
                                  width: 24.0 * scale,
                                ),
                                SizedBox(
                                  width: 5.0 * scale,
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
                                SizedBox(
                                  width: 10.0 * scale,
                                ),
                              ],
                            ),
                          if (!isRankingCo2)
                            SizedBox(
                              width: 35.0 * scale,
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
          Divider(
            height: 1 * scale,
            thickness: 1 * scale,
          ),
        ],
      ),
    );
  }
}
