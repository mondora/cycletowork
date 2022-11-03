import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/activity_details/view.dart';
import 'package:cycletowork/src/ui/home/widget/confirm_challenge.dart';
import 'package:cycletowork/src/ui/register_challenge/view.dart';
import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/home/widget/activity_list.dart';
import 'package:cycletowork/src/ui/home/widget/summary_card.dart';
import 'package:cycletowork/src/widget/map.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<AppMapState> _mapKey = GlobalKey();
  final ScrollController _controller = ScrollController();
  bool isCreatedMap = false;

  @override
  void dispose() {
    _mapKey.currentState?.dispose();
    _controller.removeListener(_loadMoreUserActivity);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_loadMoreUserActivity);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Timer(const Duration(milliseconds: 2000), () => _setInAppReview()),
    );
  }

  _setInAppReview() async {
    try {
      if (kDebugMode) {
        return;
      }

      final dashboardModel = Provider.of<ViewModel>(
        context,
        listen: false,
      );
      final userHasActivity =
          dashboardModel.uiState.listUserActivity.length > 3;
      if (!userHasActivity) {
        return;
      }

      final inAppReview = InAppReview.instance;
      final isAvailableInAppReview = await inAppReview.isAvailable();
      if (!isAvailableInAppReview) {
        return;
      }

      final appData = context.read<AppData>();
      final isAppReviewed = appData.isAppReviewed;
      if (isAppReviewed) {
        return;
      }

      await inAppReview.requestReview();
      await appData.appReviewed();
    } catch (e) {
      Logger.error(e);
    }
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

  onCreatedMap() {
    isCreatedMap = true;
    final dashboardModel = Provider.of<ViewModel>(
      context,
      listen: false,
    );
    if (dashboardModel.uiState.currentPosition != null) {
      final currentPosition = dashboardModel.uiState.currentPosition!;
      _mapKey.currentState?.setMarker(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      Timer(const Duration(milliseconds: 500), () async {
        await _mapKey.currentState?.changeCamera(
          currentPosition.latitude,
          currentPosition.longitude,
          bearing: currentPosition.bearing,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final measurementUnit = context.read<AppData>().measurementUnit;
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

    final user = AppData.user!;
    final co2Kg = user.co2.gramToKg();
    final co2Pound = user.co2.gramToPound();
    final distanceKm = user.distance.meterToKm();
    final distanceMile = user.distance.meterToMile();
    final averageSpeedKmPerHour = user.averageSpeed.meterPerSecondToKmPerHour();
    final averageSpeedMilePerHour =
        user.averageSpeed.meterPerSecondToMilePerHour();
    final co2Summary = measurementUnit == AppMeasurementUnit.metric
        ? '${numberFormat.format(co2Kg)} Kg'
        : '${numberFormat.format(co2Pound)} lb';
    final distanceSummary = measurementUnit == AppMeasurementUnit.metric
        ? '${numberFormat.format(distanceKm)} km'
        : '${numberFormat.format(distanceMile)} mi';
    final averageSpeedSummary = measurementUnit == AppMeasurementUnit.metric
        ? '${numberFormat.format(averageSpeedKmPerHour)} km/h'
        : '${numberFormat.format(averageSpeedMilePerHour)} mi/h';

    final listActivityHeight =
        dashboardModel.uiState.listUserActivity.isEmpty &&
                dashboardModel.uiState.listChallengeActive.isEmpty
            ? 0.0
            : 115.0 * scale;

    if (dashboardModel.uiState.currentPosition != null && isCreatedMap) {
      final currentPosition = dashboardModel.uiState.currentPosition!;
      _mapKey.currentState?.setMarker(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      Timer(const Duration(milliseconds: 500), () async {
        await _mapKey.currentState?.changeCamera(
          currentPosition.latitude,
          currentPosition.longitude,
          bearing: currentPosition.bearing,
        );
      });
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: EdgeInsets.only(top: 25.0 * scale),
          child: AppMap(
            key: _mapKey,
            initialLatitude: initialLatitude,
            initialLongitude: initialLongitude,
            listTrackingPosition: const [],
            onCreatedMap: onCreatedMap,
          ),
        ),
        Column(
          children: [
            Material(
              elevation: 4,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              child: SlidingUpPanel(
                maxHeight: 168.0 * scale + listActivityHeight,
                minHeight: 30.0 * scale,
                defaultPanelState: PanelState.OPEN,
                color: Theme.of(context).colorScheme.background,
                boxShadow: const [],
                slideDirection: SlideDirection.DOWN,
                panelBuilder: (sc) => Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).colorScheme.background,
                      height: listActivityHeight,
                      child: ListView(
                        controller: _controller,
                        scrollDirection: Axis.horizontal,
                        children: [
                          ActivityList(
                            userActivity:
                                dashboardModel.uiState.listUserActivity,
                            listChallengeActive:
                                dashboardModel.uiState.listChallengeActive,
                            onUserActivityClick: (userActivity) async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ActivityDetailsView(
                                    userActivity: userActivity,
                                  ),
                                ),
                              );
                              dashboardModel.refreshUserActivityFromLocal(
                                userActivity.userActivityId,
                              );
                            },
                            onChallengeActiveClick: (challenge) async {
                              var title = challenge.name;
                              var isConfirmed = await ConfirmChallengeDialog(
                                context: context,
                                title: title,
                                confirmButton: 'Mi interessa'.toUpperCase(),
                                cancelButton:
                                    'Questa volta passo'.toUpperCase(),
                              ).show();
                              if (isConfirmed == true) {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterChallengeView(
                                      challenge: challenge,
                                    ),
                                  ),
                                );
                                dashboardModel
                                    .getActiveChallengeListAndClassification();
                              }
                            },
                          ),
                          if (dashboardModel.uiState.loading)
                            Container(
                              color: Theme.of(context).colorScheme.background,
                              padding:
                                  EdgeInsets.symmetric(horizontal: 20 * scale),
                              child: const Center(
                                child: AppProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (dashboardModel.uiState.listUserActivity.isNotEmpty ||
                        dashboardModel.uiState.listChallengeActive.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(
                          right: 24.0 * scale,
                          left: 24.0 * scale,
                        ),
                        child: Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                    SummaryCard(
                      co2: co2Summary,
                      distance: distanceSummary,
                      averageSpeed: averageSpeedSummary,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.drag_handle,
                          color: Colors.grey[700],
                          size: 20 * scale,
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
