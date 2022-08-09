import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/home/widget/activity_list.dart';
import 'package:cycletowork/src/ui/home/widget/summery_card.dart';
import 'package:cycletowork/src/widget/map.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<AppMapState> _mapKey = GlobalKey();

  @override
  void dispose() {
    if (_mapKey.currentState != null) {
      _mapKey.currentState!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardModel = Provider.of<DashboardViewModel>(context);
    _updateCamera(double latitude, double longitude) async {
      if (_mapKey.currentState != null) {
        await _mapKey.currentState!.changeCamera(latitude, longitude);
      }
    }

    if (dashboardModel.currentPosition != null) {
      _updateCamera(
        dashboardModel.currentPosition!.latitude!,
        dashboardModel.currentPosition!.longitude!,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        AppMap(
          key: _mapKey,
          initialLatitude: DashboardViewModel.initialLatitude,
          initialLongitude: DashboardViewModel.initialLongitude,
        ),
        Column(
          children: [
            if (dashboardModel.userActivity.isNotEmpty)
              ActivityList(
                userActivity: dashboardModel.userActivity,
              ),
            SlidingUpPanel(
              maxHeight: 168.0,
              minHeight: 30.0,
              color: Theme.of(context).colorScheme.background,
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
