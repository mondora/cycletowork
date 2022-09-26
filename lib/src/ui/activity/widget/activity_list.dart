import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    var scale = context.read<AppData>().scale;
    final Locale appLocale = Localizations.localeOf(context);
    final numberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );
    final numberFormatInt = NumberFormat(
      '##0',
      appLocale.languageCode,
    );

    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: userActivity.length,
      itemBuilder: (context, index) {
        var activity = userActivity[index];
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
                height: 93 * scale,
                width: 93 * scale,
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
    var scale = context.read<AppData>().scale;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final textSecondaryColor = colorSchemeExtension.textSecondary;
    final infoColor = colorSchemeExtension.info;

    return Container(
      height: 112.0 * scale,
      padding: const EdgeInsets.all(0),
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0 * scale),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              SizedBox(
                height: 93.0 * scale,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10.0 * scale),
                      height: 93 * scale,
                      width: 93 * scale,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10 * scale),
                        ),
                      ),
                      child: map != null
                          ? Stack(
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
                                        right: 8 * scale,
                                        bottom: 8 * scale,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/challenge.svg',
                                        height: 15.0 * scale,
                                        width: 15.0 * scale,
                                        color: infoColor,
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : Image.asset(
                              'assets/images/preview_${isChallenge ? 'challenge_' : ''}tracking.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15.0 * scale),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
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
                            width: 205 * scale,
                            child: Text(
                              more,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.bodyText2!.apply(
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0 * scale),
                height: 1,
                color: Colors.grey[300],
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
