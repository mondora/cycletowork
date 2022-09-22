import 'package:auto_size_text/auto_size_text.dart';
import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ActivityList extends StatelessWidget {
  final List<UserActivity> userActivity;
  final List<Challenge> listChallengeActive;
  final Function(UserActivity) onUserActivityClick;
  final Function(Challenge) onChallengeActiveClick;

  const ActivityList({
    Key? key,
    required this.userActivity,
    required this.onUserActivityClick,
    required this.listChallengeActive,
    required this.onChallengeActiveClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final textSecondaryColor = colorSchemeExtension.textSecondary;
    final Locale appLocale = Localizations.localeOf(context);
    final numberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );
    final numberFormatInt = NumberFormat(
      '##0',
      appLocale.languageCode,
    );

    return Container(
      color: colorScheme.background,
      height: 115.0 * scale,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 24.0 * scale),
            child: Text(
              listChallengeActive.isEmpty
                  ? 'Ultime attività'
                  : 'Nuova Challenge!',
              style: Theme.of(context).textTheme.caption!.apply(
                    color: textSecondaryColor,
                  ),
            ),
          ),
          userActivity.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(left: 24.0 * scale, top: 8.0 * scale),
                  height: 65 * scale,
                  child: ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: listChallengeActive.length + userActivity.length,
                    itemBuilder: (context, index) {
                      if (listChallengeActive.isNotEmpty &&
                          listChallengeActive.length > index) {
                        var challenge = listChallengeActive[index];
                        return _NewChallengeCard(
                          title: challenge.name,
                          isFiabChallenge: challenge.fiabEdition,
                          onTap: () => onChallengeActiveClick(challenge),
                        );
                      }
                      var userActivityIndex = listChallengeActive.isEmpty
                          ? index
                          : index - listChallengeActive.length;
                      var activity = userActivity[userActivityIndex];
                      var date = DateTime.fromMillisecondsSinceEpoch(
                        activity.stopTime,
                      );
                      var dateString = '${DateFormat(
                        'dd MMMM yyyy',
                        appLocale.languageCode,
                      ).format(date)} alle ore ${DateFormat(
                        'HH:mm',
                        appLocale.languageCode,
                      ).format(date)}';
                      var co2String =
                          '${numberFormat.format(activity.co2.gramToKg())} Kg CO\u2082';
                      var moreString =
                          '${numberFormat.format(activity.distance.meterToKm())} km | velocità media ${numberFormatInt.format(activity.averageSpeed.meterPerSecondToKmPerHour())} km/h';
                      var map = activity.imageData != null
                          ? Image.memory(
                              activity.imageData!,
                              fit: BoxFit.cover,
                            )
                          : null;
                      var isChallenge = activity.isChallenge == 1;
                      return _ActivityCard(
                        map: map,
                        co2: co2String,
                        date: dateString,
                        more: moreString,
                        isChallenge: isChallenge,
                        onTap: () => onUserActivityClick(activity),
                      );
                    },
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(left: 24.0 * scale, top: 8.0 * scale),
                  height: 65 * scale,
                  child: ListView(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        height: 65 * scale,
                        child: ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: listChallengeActive.length,
                          itemBuilder: (context, index) {
                            var challenge = listChallengeActive[index];
                            return _NewChallengeCard(
                              title: challenge.name,
                              isFiabChallenge: challenge.fiabEdition,
                              onTap: () => onChallengeActiveClick(challenge),
                            );
                          },
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.60),
                        highlightColor: Colors.white,
                        direction: ShimmerDirection.ltr,
                        child: const _EmptyActivityCard(),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.70),
                        highlightColor: Colors.white,
                        direction: ShimmerDirection.ltr,
                        child: const _EmptyActivityCard(),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class _NewChallengeCard extends StatelessWidget {
  final String title;
  final bool isFiabChallenge;
  final Function()? onTap;

  const _NewChallengeCard({
    Key? key,
    required this.title,
    required this.isFiabChallenge,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 300 * scale,
      margin: EdgeInsets.only(right: 10.0 * scale),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(right: 50.0 * scale),
                  width: 130 * scale,
                  child: AutoSizeText(
                    title,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    style: textTheme.button!.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Ink.image(
                image: AssetImage(
                  'assets/images/challenge${isFiabChallenge ? '_fiab' : ''}.png',
                ),
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _EmptyActivityCard extends StatelessWidget {
  const _EmptyActivityCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    return Container(
      width: 300 * scale,
      margin: const EdgeInsets.only(right: 0.0),
      child: Container(
        padding: EdgeInsets.all(5 * scale),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 57 * scale,
              width: 57 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10 * scale),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0 * scale),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.0 * scale,
                    height: 7.0 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10 * scale),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5 * scale,
                  ),
                  Container(
                    width: 200.0 * scale,
                    height: 7.0 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10 * scale),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5 * scale,
                  ),
                  Container(
                    width: 200.0 * scale,
                    height: 7.0 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10 * scale),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Widget? map;
  final String co2;
  final String date;
  final String more;
  final bool isChallenge;
  final Function()? onTap;

  const _ActivityCard({
    Key? key,
    required this.map,
    required this.co2,
    required this.date,
    required this.more,
    required this.isChallenge,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final textSecondaryColor = colorSchemeExtension.textSecondary;
    final infoColor = colorSchemeExtension.info;

    return Container(
      width: 300 * scale,
      margin: const EdgeInsets.only(right: 0.0),
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0 * scale),
          ),
          child: Container(
            padding: EdgeInsets.all(5 * scale),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 57 * scale,
                  width: 57 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10 * scale),
                    ),
                  ),
                  child: map != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              child: map!,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10 * scale),
                              ),
                            ),
                            if (isChallenge)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: 6 * scale,
                                    bottom: 4 * scale,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/challenge.svg',
                                    height: 8.0 * scale,
                                    width: 8.0 * scale,
                                    color: infoColor,
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Image.asset(
                          'assets/images/preview_${isChallenge ? 'challenge_' : ''}tracking_small.png',
                          fit: BoxFit.cover,
                        ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0 * scale),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/co2.svg',
                            height: 24.0 * scale,
                            width: 24.0 * scale,
                            color: infoColor,
                          ),
                          SizedBox(
                            width: 6 * scale,
                          ),
                          Text(
                            co2,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: infoColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ],
                      ),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(
                        width: 210 * scale,
                        child: Text(
                          more,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2!.apply(
                                color: textSecondaryColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
