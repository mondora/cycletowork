import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActivityList extends StatelessWidget {
  final List<UserActivity> userActivity;
  const ActivityList({
    Key? key,
    required this.userActivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: userActivity.length,
      itemBuilder: (context, index) {
        var activity = userActivity[index];
        var date = DateTime.fromMillisecondsSinceEpoch(activity.timestamp);
        return _ActivityCard(
          map: activity.map,
          co2: '${activity.co2} Kg CO2',
          date: '25 aprile 2022 alle ore  08:25',
          more: '19,5 Km | velocità media 15 km/h',
          isChalleng: false,
        );
      },
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Widget map;
  final String co2;
  final String date;
  final String more;
  final bool isChalleng;
  const _ActivityCard({
    Key? key,
    required this.map,
    required this.co2,
    required this.date,
    required this.more,
    required this.isChalleng,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final textSecondaryColor = colorSchemeExtension.textSecondary;
    final infoColor = colorSchemeExtension.info;

    return Container(
      height: 112.0,
      padding: EdgeInsets.all(0),
      // margin: const EdgeInsets.only(right: 40.0),
      child: Material(
        color: Theme.of(context).colorScheme.background,
        // color: Colors.amber,

        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Container(
                height: 93.0,
                padding: EdgeInsets.all(0),
                // padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 93,
                      width: 93,
                      child: map,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 21.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            width: 210,
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
              // SizedBox(
              //   height: 10,
              // ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                height: 1,
                color: Color.fromRGBO(0, 0, 0, 0.12),
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
