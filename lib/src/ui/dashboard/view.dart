import 'package:app_settings/app_settings.dart';
import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/activity/view.dart';
import 'package:cycletowork/src/ui/classification/view.dart';
import 'package:cycletowork/src/ui/counter/view.dart';
import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/home/view.dart';
import 'package:cycletowork/src/ui/dashboard/widget/avatar.dart';
import 'package:cycletowork/src/ui/dashboard/widget/bottom_nav_bar.dart';
import 'package:cycletowork/src/ui/dashboard/widget/drawer.dart';
import 'package:cycletowork/src/ui/information/view.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart'
    as landing_view_model;
import 'package:cycletowork/src/ui/map_tracking/view.dart';
import 'package:cycletowork/src/ui/pause_tracking/view.dart';
import 'package:cycletowork/src/ui/profile/view.dart';
import 'package:cycletowork/src/ui/settings/view.dart';
import 'package:cycletowork/src/ui/dashboard/widget/gps_icon.dart';
import 'package:cycletowork/src/ui/stop_tracking/view.dart';
import 'package:cycletowork/src/ui/tracking/view.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/widget/alart_dialog.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final landingModel = Provider.of<landing_view_model.ViewModel>(context);
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var dismissKey = UniqueKey();

    var tabs = const [
      HomeView(),
      ActivityView(),
      ClassificationView(),
      ProfileView(),
      // SettingsView(),
      InformationView(),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        right: false,
        left: false,
        child: ChangeNotifierProvider<ViewModel>(
          create: (_) => ViewModel.instance(),
          child: Consumer<ViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.uiState.loading) {
                return const Scaffold(
                  body: Center(
                    child: AppProgressIndicator(),
                  ),
                );
              }

              if (viewModel.uiState.dashboardPageOption ==
                  DashboardPageOption.startCounter) {
                return CounterView(
                  dismissKey: dismissKey,
                  counter: viewModel.uiState.counter,
                  setCounter: (value) {
                    dismissKey = UniqueKey();
                    viewModel.setCounter(value);
                  },
                );
              }

              if (viewModel.uiState.dashboardPageOption ==
                  DashboardPageOption.startTracking) {
                return TrackingView(
                  trackingUserActivity: viewModel.trackingUserActivity!,
                  showMap: viewModel.showMapTracking,
                  pauseTracking: viewModel.pauseTracking,
                  lastLocation: viewModel.listTrackingPosition.isNotEmpty
                      ? viewModel.listTrackingPosition.last
                      : null,
                );
              }

              if (viewModel.uiState.dashboardPageOption ==
                  DashboardPageOption.pauseTracking) {
                return PauseTrackingView(
                  listTrackingPosition: viewModel.listTrackingPosition,
                  trackingUserActivity: viewModel.trackingUserActivity!,
                  playTracking: viewModel.playTracking,
                  stopTracking: viewModel.stopTracking,
                );
              }

              if (viewModel.uiState.dashboardPageOption ==
                  DashboardPageOption.stopTracking) {
                return StopTrackingView(
                  listTrackingPosition: viewModel.listTrackingPosition,
                  trackingUserActivity: viewModel.trackingUserActivity!,
                  saveTracking: () async {
                    var result = await viewModel.saveTracking(context);

                    final snackBar = SnackBar(
                      backgroundColor: result
                          ? colorSchemeExtension.success
                          : colorScheme.error,
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!result)
                              Icon(
                                Icons.error,
                                color: colorScheme.onError,
                              ),
                            if (!result)
                              const SizedBox(
                                width: 5,
                              ),
                            Expanded(
                              child: Text(
                                result
                                    ? 'LA TUA NUOVA ATTIVITÀ È STATA SALVATA!'
                                    : 'PURTROPPO LA TUA NUOVA ATTIVITÀ NON È STATA SALVATA!'
                                        .toUpperCase(),
                                style: textTheme.caption!.apply(
                                  color: colorScheme.onError,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 15,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  removeTracking: viewModel.removeTracking,
                );
              }

              if (viewModel.uiState.dashboardPageOption ==
                  DashboardPageOption.showMapTracking) {
                return ShowMapTracking(
                  listTrackingPosition: viewModel.listTrackingPosition,
                  trackingUserActivity: viewModel.trackingUserActivity!,
                  currentPosition: viewModel.uiState.currentPosition!,
                  pauseTracking: viewModel.pauseTracking,
                  hiddenMap: viewModel.hiddenMap,
                );
              }
              var isCenter = viewModel.uiState.appMenuOption.index == 0;
              var floatingActionButtonSize = isCenter ? 100.0 : 50.0;
              return Scaffold(
                appBar: AppBar(
                  toolbarHeight:
                      AppData.user!.userType == UserType.other ? 60.0 : 80.0,
                  elevation: 0.0,
                  centerTitle: true,
                  title: AppGpsIcon(
                    onPressed: viewModel.refreshLocation,
                    gpsStatus: viewModel.uiState.gpsStatus,
                    visible:
                        viewModel.uiState.appMenuOption == AppMenuOption.home,
                  ),
                  actions: [
                    AppAvatar(
                      userImageUrl:
                          AppData.user != null ? AppData.user!.photoURL : null,
                      userType: AppData.user != null
                          ? AppData.user!.userType
                          : UserType.other,
                      onPressed: () {
                        viewModel.changePageFromMenu(AppMenuOption.profile);
                      },
                      loading: viewModel.uiState.loading ||
                          viewModel.uiState.refreshLocationLoading,
                      visible: viewModel.uiState.showAppBarAction,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
                drawer: AppDrawer(
                  menuOption: viewModel.uiState.appMenuOption,
                  onPressed: (value) {
                    if (value == AppMenuOption.logout) {
                      landingModel.logout();
                    } else {
                      viewModel.changePageFromMenu(value);
                    }
                  },
                ),
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    tabs.elementAt(viewModel.uiState.appMenuOption.index),
                    // ClassificationView(),
                    Positioned(
                      bottom: 0.0,
                      right: 0,
                      left: 0,
                      child: AppBottomNavBar(
                        bottomNavBarOption:
                            viewModel.uiState.appBottomNavBarOption,
                        floatActionButtonEnabled: true,
                        isCenter: viewModel.uiState.appMenuOption.index == 0,
                        onChange: (value) {
                          viewModel.changePageFromBottomNavigation(value);
                        },
                        onPressed: () async {
                          var check = await _checkGpsAndPermission(context);
                          if (check) {
                            viewModel.startCounter(context);
                          }
                        },
                      ),
                    ),
                    Positioned(
                      bottom: isCenter ? 80.0 : 0.0,
                      right: 0,
                      left: isCenter ? 0 : null,
                      child: Container(
                        width: floatingActionButtonSize,
                        height: floatingActionButtonSize,
                        margin: const EdgeInsets.only(
                          right: 20.0,
                          left: 20.0,
                          bottom: 20.0,
                        ),
                        child: FittedBox(
                          child: FloatingActionButton(
                            onPressed: () async {
                              var check = await _checkGpsAndPermission(context);
                              if (check) {
                                viewModel.startCounter(context);
                              }
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: isCenter ? 8 : 11,
                                ),
                                Text(
                                  'IN',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.italic,
                                        fontSize: isCenter ? 14 : 12,
                                      ),
                                ),
                                Text(
                                  'SELLA!',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.italic,
                                        fontSize: isCenter ? 14 : 12,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _checkGpsAndPermission(BuildContext context) async {
    var gpsStatus = await Gps.getGpsStatus();
    if (gpsStatus == GpsStatus.turnOff) {
      await AppAlartDialog(
        context: context,
        title: 'Attenzione!',
        subtitle: 'Il GPS del tuo smartphone è spento.',
        body: 'Per poter usare Cycle2Work devi attivarlo nelle impostazioni.',
        confirmLabel: 'Ho capito',
      ).show();
      await AppSettings.openDeviceSettings();
      return false;
    }
    var permissionStatus = await Gps.getPermissionStatus();
    if (permissionStatus == PermissionStatus.denied) {
      await AppAlartDialog(
        context: context,
        title: 'Attenzione!',
        subtitle: 'Cycle2Work non è in grado di rilevare la tua posizione.',
        body:
            'Per poter usare Cycle2Work è necessario che tu ci dia il permesso di rilevare la tua posizione. Puoi farlo nelle impostazioni di sistema.',
        confirmLabel: 'Ho capito',
      ).show();
      await AppSettings.openLocationSettings();
      return false;
    }
    if (permissionStatus == PermissionStatus.restricted) {
      await AppAlartDialog(
        context: context,
        title: 'Attenzione!',
        subtitle:
            'Cycle2Work non è in grado di rilevare la tua posizione in modo preciso.',
        body:
            'Per poter usare al meglio Cycle2Work è necessario abilitare il rilevamento preciso della posizione. Puoi farlo nelle impostazioni di sistema.',
        confirmLabel: 'Ho capito',
      ).show();
      await AppSettings.openLocationSettings();
      return false;
    }
    return true;
  }
}
