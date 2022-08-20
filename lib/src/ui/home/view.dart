import 'package:cycletowork/src/ui/details_tracking/view.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:flutter/material.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/home/widget/activity_list.dart';
import 'package:cycletowork/src/ui/home/widget/summery_card.dart';
import 'package:cycletowork/src/widget/map.dart';
import 'package:intl/intl.dart';
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
    _mapKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardModel = Provider.of<ViewModel>(context);
    final initialLatitude = dashboardModel.uiState.currentPosition != null
        ? dashboardModel.uiState.currentPosition!.latitude
        : dashboardModel.initialLatitude;

    final initialLongitude = dashboardModel.uiState.currentPosition != null
        ? dashboardModel.uiState.currentPosition!.longitude
        : dashboardModel.initialLongitude;

    final Locale appLocale = Localizations.localeOf(context);
    final numberFormat = NumberFormat(
      '##0.00',
      appLocale.languageCode,
    );

    final co2 =
        (dashboardModel.uiState.userActivitySummery?.co2 ?? 0).gramToKg();
    final distance =
        (dashboardModel.uiState.userActivitySummery?.distance ?? 0).meterToKm();
    final averageSpeed =
        (dashboardModel.uiState.userActivitySummery?.averageSpeed ?? 0)
            .meterPerSecondToKmPerHour();

    _updateCamera(
      double latitude,
      double longitude,
      double bearing,
    ) async {
      if (_mapKey.currentState != null) {
        await _mapKey.currentState!.changeCamera(
          latitude,
          longitude,
          bearing: bearing,
        );
      }
    }

    if (dashboardModel.uiState.currentPosition != null) {
      _updateCamera(
        dashboardModel.uiState.currentPosition!.latitude,
        dashboardModel.uiState.currentPosition!.longitude,
        dashboardModel.uiState.currentPosition!.bearing,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: EdgeInsets.only(
            top:
                dashboardModel.uiState.listUserActivity.isNotEmpty ? 100.0 : 20,
          ),
          child: AppMap(
            type: AppMapType.dynamic,
            key: _mapKey,
            initialLatitude: initialLatitude,
            initialLongitude: initialLongitude,
            listTrackingPosition: const [],
          ),
        ),
        Column(
          children: [
            if (dashboardModel.uiState.listUserActivity.isNotEmpty)
              ActivityList(
                userActivity: dashboardModel.uiState.listUserActivity,
                onUserActivityClick: (userActivity) async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsTrackingView(
                        userActivity: userActivity,
                      ),
                    ),
                  );
                },
              ),
            SlidingUpPanel(
              maxHeight: 168.0,
              minHeight: 30.0,
              defaultPanelState: PanelState.OPEN,
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
                    co2: '${numberFormat.format(co2)} Kg',
                    distance: '${numberFormat.format(distance)} Km',
                    averageSpeed: '${numberFormat.format(averageSpeed)} km/h',
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
