import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/ui/activity/view.dart';
import 'package:cycletowork/src/ui/classification/view.dart';
import 'package:cycletowork/src/ui/home/view.dart';
import 'package:cycletowork/src/ui/dashboard/widget/avatar.dart';
import 'package:cycletowork/src/ui/dashboard/widget/bottom_nav_bar.dart';
import 'package:cycletowork/src/ui/dashboard/widget/drawer.dart';
import 'package:cycletowork/src/ui/profile/view.dart';
import 'package:cycletowork/src/utility/gps_status.dart';
import 'package:cycletowork/src/ui/dashboard/widget/gps_icon.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        elevation: 0.0,
        centerTitle: true,
        title: AppGpsIcon(
          onPressed: () {
            print('try again to set location');
          },
          gpsStatus: GpsStatus.turnOff,
          visible: true,
        ),
        actions: [
          AppAvatar(
            userType:
                AppData.user != null ? AppData.user!.userType : UserType.other,
            onPressed: () {},
            loading: false,
            visible: true,
          ),
          const SizedBox(
            width: 10.0,
          ),
        ],
      ),
      drawer: AppDrawer(
        menuOption: AppMenuOption.home,
        onPressed: (value) {
          print(value);
        },
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // HomeView(),
          // ClassificationView(),
          // ActivityView(),
          ProfileView(),

          Positioned(
            bottom: 0.0,
            right: 0,
            left: 0,
            child: AppBottomNavBar(
              bottomNavBarOption: AppBottomNavBarOption.home,
              onPressed: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
