import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/ui/admin/dashboard/ui_state.dart';
import 'package:cycletowork/src/ui/admin/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/admin/list_company/view.dart';
import 'package:cycletowork/src/ui/admin/list_user/view.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart'
    as landing_view_model;

import 'package:cycletowork/src/ui/dashboard/widget/avatar.dart';
import 'package:cycletowork/src/utility/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  var _labelType = NavigationRailLabelType.none;
  var _expanded = true;

  @override
  Widget build(BuildContext context) {
    final screen = Screen.getScreen(context);
    final landingModel = Provider.of<landing_view_model.ViewModel>(context);
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    if (screen == ScreenSize.mobileS ||
        screen == ScreenSize.mobileM ||
        screen == ScreenSize.mobileL ||
        screen == ScreenSize.tablet) {
      setState(() {
        _labelType = NavigationRailLabelType.selected;
        _expanded = false;
      });
    } else {
      setState(() {
        _labelType = NavigationRailLabelType.none;
        _expanded = true;
      });
    }

    return ChangeNotifierProvider<ViewModel>(
      create: (_) => ViewModel.instance(),
      child: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.uiState.error) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                      SnackBar(
                        backgroundColor: colorScheme.error,
                        content: Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: colorScheme.onError,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              viewModel.uiState.errorMessage.toUpperCase(),
                              style: textTheme.button!.apply(
                                color: colorScheme.onError,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .closed
                    .then((value) => viewModel.clearError());
              },
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Pannello Admin',
                style: textTheme.headline5,
              ),
              centerTitle: true,
              actions: [
                AppAvatar(
                  userImageUrl:
                      AppData.user != null ? AppData.user!.photoURL : null,
                  userType: UserType.other,
                  isAdmin: true,
                  onPressed: null,
                  loading: viewModel.uiState.loading,
                  visible: true,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                IconButton(
                  splashRadius: 25,
                  icon: SvgPicture.asset(
                    'assets/icons/logout.svg',
                    height: 25,
                    width: 25,
                  ),
                  onPressed: landingModel.logout,
                ),
                const SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            body: Row(
              children: <Widget>[
                Container(
                  color: NavigationRailTheme.of(context).backgroundColor ??
                      Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                      Expanded(
                        child: NavigationRail(
                          selectedIndex: viewModel.pageOptionIndex,
                          onDestinationSelected: (int index) {
                            viewModel.changePage(index);
                          },
                          extended: _expanded,
                          labelType: _labelType,
                          destinations: <NavigationRailDestination>[
                            NavigationRailDestination(
                              icon: SvgPicture.asset(
                                'assets/icons/profile.svg',
                              ),
                              selectedIcon: SvgPicture.asset(
                                'assets/icons/profile.svg',
                                color: colorScheme.primary,
                              ),
                              label: const Text('Utenti'),
                            ),
                            NavigationRailDestination(
                              icon: SvgPicture.asset(
                                'assets/icons/classification.svg',
                              ),
                              selectedIcon: SvgPicture.asset(
                                'assets/icons/classification.svg',
                                color: colorScheme.primary,
                              ),
                              label: const Text('Challenge'),
                            ),
                            NavigationRailDestination(
                              icon: SvgPicture.asset(
                                'assets/icons/survey.svg',
                              ),
                              selectedIcon: SvgPicture.asset(
                                'assets/icons/survey.svg',
                                color: colorScheme.primary,
                              ),
                              label: const Text('Sondagio'),
                            ),
                            NavigationRailDestination(
                              icon: SvgPicture.asset(
                                'assets/icons/company.svg',
                              ),
                              selectedIcon: SvgPicture.asset(
                                'assets/icons/company.svg',
                                color: colorScheme.primary,
                              ),
                              label: const Text('Azienda'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 70.0,
                        margin: const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: Image.asset(
                          'assets/images/mondora_logo.png',
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Builder(
                      builder: (context) {
                        switch (viewModel.uiState.pageOption) {
                          case PageOption.user:
                            return const AdminListUserView();

                          case PageOption.challenge:
                            return const NewView();

                          case PageOption.survey:
                            return const NewView();

                          case PageOption.company:
                            return const AdminListCompanyView();
                        }
                      },
                    ),
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

class NewView extends StatelessWidget {
  const NewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.published_with_changes_outlined,
              size: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'In arrivo',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
