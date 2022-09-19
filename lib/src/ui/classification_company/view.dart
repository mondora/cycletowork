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

class ClassificationCompanyView extends StatefulWidget {
  const ClassificationCompanyView({Key? key}) : super(key: key);

  @override
  State<ClassificationCompanyView> createState() =>
      _ClassificationCompanyViewState();
}

class _ClassificationCompanyViewState extends State<ClassificationCompanyView> {
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
      dashboardModel.refreshCompanyClassification(
        nextPage: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
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
    final percentNumberFormat = NumberFormat(
      '##0',
      appLocale.languageCode,
    );

    var selectedColor = const Color.fromRGBO(199, 21, 172, 1);
    var firstColor = const Color.fromRGBO(57, 73, 171, 1);
    var maxValueWidget = CircleAvatar(
      backgroundColor: firstColor,
      child: SvgPicture.asset(
        'assets/icons/build.svg',
        height: 18.0 * scale,
        width: 18.0 * scale,
        color: colorScheme.onPrimary,
      ),
    );
    var valueWidget = CircleAvatar(
      backgroundColor: selectedColor,
      child: SvgPicture.asset(
        'assets/icons/build.svg',
        height: 18.0 * scale,
        width: 18.0 * scale,
        color: colorScheme.onPrimary,
      ),
    );
    var isRankingCo2 =
        viewModel.uiState.listCompanyClassificationOrderByRankingCo2;

    var listCompanyClassificationRankingCo2 =
        viewModel.uiState.listCompanyClassificationRankingCo2;

    var listCompanyClassificationRankingRegistered =
        viewModel.uiState.listCompanyClassificationRankingRegistered;
    var firstRankingPercent =
        listCompanyClassificationRankingRegistered.isNotEmpty
            ? listCompanyClassificationRankingRegistered.first
            : null;

    var firstRankingCo2 = listCompanyClassificationRankingCo2.isNotEmpty
        ? listCompanyClassificationRankingCo2.first
        : null;

    var userValues = viewModel.uiState.userCompanyClassification!;
    var userRankingCo2 = userValues.rankingCo2;
    var userRankingPercent = userValues.rankingPercentRegistered;
    var userRankingCo2Finded = userRankingCo2 != 0
        ? userRankingCo2
        : listCompanyClassificationRankingCo2.isNotEmpty
            ? listCompanyClassificationRankingCo2.indexWhere(
                  (e) => e.name == userValues.name,
                ) +
                1
            : 0;
    var userRankingRegisteredFinded = userRankingPercent != 0
        ? userRankingPercent
        : listCompanyClassificationRankingRegistered.isNotEmpty
            ? listCompanyClassificationRankingRegistered.indexWhere(
                  (e) => e.name == userValues.name,
                ) +
                1
            : 0;
    var expandedHeight = (isRankingCo2 ? 275.0 : 225.0) * scale;
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
                      if (isVisible)
                        Container(
                          margin: EdgeInsets.only(top: 20 * scale),
                          height: 35 * scale,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            children: [
                              InputChip(
                                onSelected: (bool value) async {
                                  viewModel
                                      .setListCompanyClassificationOrderByRankingCo2(
                                    !value,
                                  );
                                },
                                selected: !isRankingCo2,
                                label: const Text(
                                  'Impegno aziendale',
                                ),
                                side:
                                    ChipTheme.of(context).shape!.side.copyWith(
                                          color: !isRankingCo2
                                              ? Colors.transparent
                                              : null,
                                        ),
                              ),
                              SizedBox(
                                width: 10.0 * scale,
                              ),
                              InputChip(
                                onSelected: (bool value) async {
                                  viewModel
                                      .setListCompanyClassificationOrderByRankingCo2(
                                    value,
                                  );
                                },
                                selected: isRankingCo2,
                                label: const Text(
                                  'km e CO\u2082 risparmiata',
                                ),
                                side:
                                    ChipTheme.of(context).shape!.side.copyWith(
                                          color: isRankingCo2
                                              ? Colors.transparent
                                              : null,
                                        ),
                              ),
                              SizedBox(
                                width: 10.0 * scale,
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 20 * scale,
                      ),
                      if (isRankingCo2)
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
                              : listCompanyClassificationRankingCo2
                                      .isNotEmpty &&
                                  listCompanyClassificationRankingCo2
                                          .first.name ==
                                      userValues.name,
                        ),
                      if (!isRankingCo2)
                        RankingSlider(
                          percent: firstRankingPercent != null
                              ? userValues.percentRegistered /
                                  firstRankingPercent.percentRegistered
                              : 0,
                          maxValue: firstRankingPercent != null
                              ? '${percentNumberFormat.format(firstRankingPercent.percentRegistered)}%'
                              : '',
                          value:
                              '${percentNumberFormat.format(userValues.percentRegistered)}%',
                          title: 'Partecipanti / totale dipendenti',
                          isEmpty: firstRankingPercent == null ||
                              firstRankingPercent.percentRegistered == 0,
                          maxValueWidget: maxValueWidget,
                          valueWidget: valueWidget,
                          isFirst: userRankingPercent != 0
                              ? userRankingPercent == 1
                              : listCompanyClassificationRankingRegistered
                                      .isNotEmpty &&
                                  listCompanyClassificationRankingRegistered
                                          .first.name ==
                                      userValues.name,
                        ),
                      if (isVisible)
                        Column(
                          key: UniqueKey(),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10 * scale,
                            ),
                            if (isRankingCo2)
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
                                    : listCompanyClassificationRankingCo2
                                            .isNotEmpty &&
                                        listCompanyClassificationRankingCo2
                                                .first.name ==
                                            userValues.name,
                              ),
                          ],
                        ),
                      SizedBox(
                        height: 10 * scale,
                      ),
                      RankingPositionSlider(
                        ranking: isRankingCo2
                            ? userRankingCo2Finded
                            : userRankingRegisteredFinded,
                        isEmpty: listCompanyClassificationRankingCo2.isEmpty,
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
        onRefresh: viewModel.refreshCompanyClassification,
        color: colorScheme.secondary,
        displacement: 0,
        child: isRankingCo2
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 80.0 * scale),
                itemCount: listCompanyClassificationRankingCo2.length,
                itemBuilder: (context, index) {
                  var item = listCompanyClassificationRankingCo2[index];
                  return _Card(
                    ranking: index + 1,
                    title: item.name,
                    subtitle:
                        '${distanceNumberFormat.format(item.distance.meterToKm())} km',
                    value:
                        '${co2NumberFormat.format(item.co2.gramToKg())} Kg CO\u2082',
                    isRankingCo2: isRankingCo2,
                    selected: item.rankingCo2 != 0
                        ? item.rankingCo2 == userRankingCo2
                        : item.name == userValues.name,
                    color: item.color,
                  );
                },
              )
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 80.0 * scale),
                itemCount: listCompanyClassificationRankingRegistered.length,
                itemBuilder: (context, index) {
                  var item = listCompanyClassificationRankingRegistered[index];
                  return _Card(
                    ranking: index + 1,
                    title: item.name,
                    subtitle:
                        '${item.employeesNumberRegistered} su ${item.employeesNumber} dipendenti',
                    value:
                        '${percentNumberFormat.format(item.percentRegistered)}%',
                    isRankingCo2: false,
                    selected: item.rankingCo2 != 0
                        ? item.rankingPercentRegistered == userRankingPercent
                        : item.name == userValues.name,
                    color: item.color,
                  );
                },
              ),
      ),
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
                      height: 24.0 * scale,
                      width: 24.0 * scale,
                      color: colorScheme.onPrimary,
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
