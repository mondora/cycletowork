import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ActivityList extends StatelessWidget {
  final List<UserActivity> userActivity;
  final Function(UserActivity) onUserActivityClick;

  const ActivityList({
    Key? key,
    required this.userActivity,
    required this.onUserActivityClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      color: Theme.of(context).colorScheme.background,
      height: 115.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 24.0),
            child: Text(
              'Ultime attività',
              style: Theme.of(context).textTheme.caption!.apply(
                    color: textSecondaryColor,
                  ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 24.0, top: 8.0),
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userActivity.length,
              itemBuilder: (context, index) {
                var activity = userActivity[index];
                var date = DateTime.fromMillisecondsSinceEpoch(
                  activity.stopTime!,
                );
                var dateString = '${DateFormat(
                  'dd MMMM yyyy',
                  appLocale.languageCode,
                ).format(date)} alle ore ${DateFormat(
                  'HH:mm',
                  appLocale.languageCode,
                ).format(date)}';
                var co2String =
                    '${numberFormat.format(activity.co2!.gramToKg())} Kg CO2';
                var moreString =
                    '${numberFormat.format(activity.distance!.meterToKm())} Km | velocità media ${numberFormatInt.format(activity.averageSpeed!.meterPerSecondToKmPerHour())} km/h';
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
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 24.0,
              left: 24.0,
              top: 27.0,
            ),
            child: Container(
              height: 1,
              color: const Color.fromRGBO(0, 0, 0, 0.12),
            ),
          ),
        ],
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
  final Function() onTap;

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
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final textSecondaryColor = colorSchemeExtension.textSecondary;
    final infoColor = colorSchemeExtension.info;

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 0.0),
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 57,
                  width: 57,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: map != null
                          ? (map! as Image).image
                          : Image.asset(
                              'assets/images/${isChallenge ? 'challenge_' : ''}map_tracking.png',
                            ).image,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/co2.svg',
                            height: 24.0,
                            width: 24.0,
                            color: infoColor,
                          ),
                          const SizedBox(
                            width: 6,
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
                        width: 210,
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
