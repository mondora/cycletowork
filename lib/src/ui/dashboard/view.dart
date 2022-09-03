import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user.dart';
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final landingModel = Provider.of<landing_view_model.ViewModel>(context);
    var localeIdentifier = Localizations.localeOf(context).languageCode;
    var dismissKey = UniqueKey();

    var tabs = const [
      HomeView(),
      ActivityView(),
      ClassificationView(),
      ProfileView(),
      SettingsView(),
      InformationView(),
    ];

    return ChangeNotifierProvider<ViewModel>(
      create: (_) => ViewModel.instance(),
      child: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
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
              // showMap: viewModel.listTrackingPosition.length > 1
              //     ? viewModel.showMapTracking
              //     : null,
              showMap: viewModel.showMapTracking,
              pauseTracking: viewModel.pauseTracking,
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
              saveTracking: () => viewModel.saveTracking(localeIdentifier),
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

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80.0,
              elevation: 0.0,
              centerTitle: true,
              title: AppGpsIcon(
                onPressed: viewModel.refreshLocation,
                gpsStatus: viewModel.uiState.gpsStatus,
                visible: viewModel.uiState.appMenuOption == AppMenuOption.home,
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
                  loading: viewModel.uiState.loading,
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
                Positioned(
                  bottom: 0.0,
                  right: 0,
                  left: 0,
                  child: AppBottomNavBar(
                    bottomNavBarOption: viewModel.uiState.appBottomNavBarOption,
                    floatActionButtonEnabled: true,
                    onChange: (value) {
                      viewModel.changePageFromBottomNavigation(value);
                    },
                    onPressed: () {
                      // TODO checl location permission
                      if (true) {
                        viewModel.startCounter(context);
                      } else {
                        //TDOD show message then open settings
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
