import 'package:cycletowork/src/data/chart_data.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/activity/widget/activity_list.dart';
import 'package:cycletowork/src/widget/chart.dart';
import 'package:flutter/material.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    List<UserActivity> userActivity = [
      // UserActivity(
      //   averageSpeed: 15.0,
      //   co2: 0.2,
      //   distant: 9.5,
      //   timestamp: (DateTime.now().millisecondsSinceEpoch),
      //   map: Image.asset('assets/images/test.png'),
      // ),
      // UserActivity(
      //   averageSpeed: 15.0,
      //   co2: 0.2,
      //   distant: 9.5,
      //   timestamp: (DateTime.now().millisecondsSinceEpoch),
      //   map: Image.asset('assets/images/test.png'),
      // ),
      // UserActivity(
      //   averageSpeed: 15.0,
      //   co2: 0.2,
      //   distant: 9.5,
      //   timestamp: (DateTime.now().millisecondsSinceEpoch),
      //   map: Image.asset('assets/images/test.png'),
      // ),
      // UserActivity(
      //   averageSpeed: 15.0,
      //   co2: 0.2,
      //   distant: 9.5,
      //   timestamp: (DateTime.now().millisecondsSinceEpoch),
      //   map: Image.asset('assets/images/test.png'),
      // ),
      // UserActivity(
      //   averageSpeed: 15.0,
      //   co2: 0.2,
      //   distant: 9.5,
      //   timestamp: (DateTime.now().millisecondsSinceEpoch),
      //   map: Image.asset('assets/images/test.png'),
      // ),
      // UserActivity(
      //   averageSpeed: 15.0,
      //   co2: 0.2,
      //   distant: 9.5,
      //   timestamp: (DateTime.now().millisecondsSinceEpoch),
      //   map: Image.asset('assets/images/test.png'),
      // ),
      // UserActivity(
      //   averageSpeed: 15.0,
      //   co2: 0.2,
      //   distant: 9.5,
      //   timestamp: (DateTime.now().millisecondsSinceEpoch),
      //   map: Image.asset('assets/images/test.png'),
      // ),
    ];

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        // elevation: 2,
        toolbarHeight: 112.0,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Attività',
              style: textTheme.headline5,
            ),
            SizedBox(
              height: 20,
            ),
            InputChip(
              onSelected: (bool value) {},
              // selected: true,
              // isEnabled: false,
              side: ChipTheme.of(context).shape!.side.copyWith(
                    color: false ? Colors.transparent : null,
                  ),
              label: Text(
                'Filtra attività valide per la challenge',
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Progressi',
              style: textTheme.headline6,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InputChip(
                    onSelected: (bool value) {},
                    selected: true,
                    // isEnabled: false,
                    label: Text(
                      'Questa settimana',
                    ),
                    side: ChipTheme.of(context).shape!.side.copyWith(
                          color: true ? Colors.transparent : null,
                        ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  InputChip(
                    onSelected: (bool value) {},
                    selected: false,
                    // isEnabled: false,
                    label: Text(
                      'Questo mese',
                    ),
                    side: ChipTheme.of(context).shape!.side.copyWith(
                          color: false ? Colors.transparent : null,
                        ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  InputChip(
                    onSelected: (bool value) {},
                    selected: false,
                    // isEnabled: false,
                    label: Text(
                      'Quest’anno',
                    ),
                    side: ChipTheme.of(context).shape!.side.copyWith(
                          color: false ? Colors.transparent : null,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
              'Risparmio di Co2 (Kg)',
              style: textTheme.caption,
            ),
            Chart(
              type: ChartType.co2,
              chartData: [
                ChartData(0, 0.4),
                ChartData(1, 0.2),
                // ChartData(2, 0.4),
                // ChartData(3, 0.3),

                // ChartData(4, 0),
                // ChartData(5, 0),
                // ChartData(6, 0.7),
              ],
              scaleType: ChartScaleType.month,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Chilometri percorsi',
              style: textTheme.caption,
            ),
            Chart(
              type: ChartType.distant,
              chartData: [
                ChartData(0, 40),
                ChartData(1, 20),
                ChartData(2, 40),
                ChartData(3, 30),
                ChartData(4, 0),
                ChartData(5, 0),
                ChartData(6, 70),
              ],
              scaleType: ChartScaleType.week,
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Corse',
              style: textTheme.headline5,
            ),
            SizedBox(
              height: 20.0,
            ),
            if (userActivity.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 90.0),
                child: ActivityList(
                  userActivity: userActivity,
                ),
              ),
            if (userActivity.isEmpty)
              Container(
                height: 115.0,
                padding: const EdgeInsets.only(left: 34.0, right: 27.0),
                margin: const EdgeInsets.only(bottom: 90.0),
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
          ],
        ),
      ),
    );
  }
}
