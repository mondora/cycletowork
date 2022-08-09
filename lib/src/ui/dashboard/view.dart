import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/ui/activity/view.dart';
import 'package:cycletowork/src/ui/classification/view.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/home/view.dart';
import 'package:cycletowork/src/ui/dashboard/widget/avatar.dart';
import 'package:cycletowork/src/ui/dashboard/widget/bottom_nav_bar.dart';
import 'package:cycletowork/src/ui/dashboard/widget/drawer.dart';
import 'package:cycletowork/src/ui/information/view.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:cycletowork/src/ui/profile/view.dart';
import 'package:cycletowork/src/ui/settings/view.dart';
import 'package:cycletowork/src/ui/dashboard/widget/gps_icon.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final landingModel = Provider.of<LandingViewModel>(context);

    var tabs = const [
      HomeView(),
      ClassificationView(),
      ActivityView(),
      ProfileView(),
      SettingsView(),
      InformationView(),
    ];

    return ChangeNotifierProvider<DashboardViewModel>(
      create: (_) => DashboardViewModel.instance(),
      child: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80.0,
              elevation: 0.0,
              centerTitle: true,
              title: AppGpsIcon(
                onPressed: () {
                  viewModel.refreshLocation();
                },
                gpsStatus: viewModel.gpsStatus,
                visible: viewModel.appMenuOption == AppMenuOption.home,
              ),
              actions: [
                AppAvatar(
                  userType: AppData.user != null
                      ? AppData.user!.userType
                      : UserType.other,
                  onPressed: () {
                    viewModel.changePageFromMenu(AppMenuOption.profile);
                  },
                  loading: viewModel.status == DashboardViewModelStatus.loading,
                  visible: viewModel.showAppBarAction,
                ),
                const SizedBox(
                  width: 10.0,
                ),
              ],
            ),
            drawer: AppDrawer(
              menuOption: viewModel.appMenuOption,
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
                tabs.elementAt(viewModel.appMenuOption.index),
                Positioned(
                  bottom: 0.0,
                  right: 0,
                  left: 0,
                  child: AppBottomNavBar(
                    bottomNavBarOption: viewModel.appBottomNavBarOption,
                    floatActionButtonEnabled:
                        viewModel.gpsStatus == GpsStatus.granted,
                    onPressed: (value) {
                      viewModel.changePageFromBottomNavigation(value);
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
