import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/ui/home/widget/activity_list.dart';
import 'package:cycletowork/src/ui/home/widget/summery_card.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserActivity> userActivity = [
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
      UserActivity(
        averageSpeed: 15.0,
        co2: 0.2,
        distant: 9.5,
        timestamp: (DateTime.now().millisecondsSinceEpoch),
        map: Image.asset('assets/images/test.png'),
      ),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: 200,
          color: Colors.red,
          child: Text('body'),
        ),
        Column(
          children: [
            if (userActivity.isNotEmpty)
              ActivityList(
                userActivity: userActivity,
              ),
            SlidingUpPanel(
              maxHeight: 168.0,
              minHeight: 30.0,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0.0, 2.0),
                  blurRadius: 1.0,
                ),
              ],
              slideDirection: SlideDirection.DOWN,
              panelBuilder: (sc) => Column(
                children: <Widget>[
                  SummeryCard(
                    co2: '1,3 Kg',
                    distant: '155 Km',
                    avarageSpeed: '20 km/h',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(
                        Icons.drag_handle,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
