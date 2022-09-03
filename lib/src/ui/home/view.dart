import 'dart:async';

import 'package:cycletowork/src/ui/details_tracking/view.dart';
import 'package:cycletowork/src/ui/home/widget/confirm_challenge.dart';
import 'package:cycletowork/src/ui/register_challenge/view.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
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
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _mapKey.currentState?.dispose();
    _controller.removeListener(_loadMoreUserActivity);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initCamera());
    _controller.addListener(_loadMoreUserActivity);
  }

  _loadMoreUserActivity() {
    if (_controller.position.maxScrollExtent == _controller.position.pixels) {
      final dashboardModel = Provider.of<ViewModel>(
        context,
        listen: false,
      );
      dashboardModel.getListUserActivity(
        nextPage: true,
      );
    }
  }

  _initCamera() async {
    final dashboardModel = Provider.of<ViewModel>(context, listen: false);
    var currentPosition = dashboardModel.uiState.currentPosition;
    if (currentPosition == null) {
      return;
    }

    Timer(const Duration(seconds: 1), () {
      _updateCamera(
        currentPosition.latitude,
        currentPosition.longitude,
        currentPosition.bearing,
      );
    });
  }

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
        (dashboardModel.uiState.userActivitySummary?.co2 ?? 0).gramToKg();
    final distance =
        (dashboardModel.uiState.userActivitySummary?.distance ?? 0).meterToKm();
    final averageSpeed =
        (dashboardModel.uiState.userActivitySummary?.averageSpeed ?? 0)
            .meterPerSecondToKmPerHour();

    if (dashboardModel.uiState.currentPosition != null) {
      Timer(const Duration(seconds: 1), () {
        _updateCamera(
          dashboardModel.uiState.currentPosition!.latitude,
          dashboardModel.uiState.currentPosition!.longitude,
          dashboardModel.uiState.currentPosition!.bearing,
        );
      });
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 100.0),
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
            Container(
              color: Theme.of(context).colorScheme.background,
              height: 115.0,
              child: ListView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                children: [
                  ActivityList(
                    userActivity: dashboardModel.uiState.listUserActivity,
                    listChallengeActive:
                        dashboardModel.uiState.listChallengeActive,
                    onUserActivityClick: (userActivity) async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailsTrackingView(
                            userActivity: userActivity,
                          ),
                        ),
                      );
                    },
                    onChallengeActiveClick: (challenge) async {
                      var title = challenge.name;
                      var isConfirmed = await ConfirmChallengeDialog(
                        context: context,
                        title: title,
                        confirmButton: 'Mi interessa'.toUpperCase(),
                        cancelButton: 'Questa volta passo'.toUpperCase(),
                      ).show();
                      if (isConfirmed == true) {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterChallengeView(
                              challenge: challenge,
                            ),
                          ),
                        );
                        dashboardModel.getActiveChallengeList();
                      }
                    },
                  ),
                  if (dashboardModel.uiState.loading)
                    Container(
                      color: Theme.of(context).colorScheme.background,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Center(
                        child: AppProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
            Material(
              elevation: 4,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              child: SlidingUpPanel(
                maxHeight: 168.0,
                minHeight: 30.0,
                defaultPanelState: PanelState.OPEN,
                color: Theme.of(context).colorScheme.background,
                boxShadow: const [],
                slideDirection: SlideDirection.DOWN,
                panelBuilder: (sc) => Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                        right: 24.0,
                        left: 24.0,
                      ),
                      child: Container(
                        height: 1,
                        color: const Color.fromRGBO(0, 0, 0, 0.12),
                      ),
                    ),
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
                        ),
                      ],
                    ),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
