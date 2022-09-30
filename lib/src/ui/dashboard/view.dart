import 'package:app_settings/app_settings.dart';
import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/activity/view.dart';
import 'package:cycletowork/src/ui/classification/view.dart';
import 'package:cycletowork/src/ui/tracking_counter/view.dart';
import 'package:cycletowork/src/ui/dashboard/ui_state.dart';
import 'package:cycletowork/src/ui/dashboard/view_model.dart';
import 'package:cycletowork/src/ui/home/view.dart';
import 'package:cycletowork/src/ui/dashboard/widget/avatar.dart';
import 'package:cycletowork/src/ui/dashboard/widget/bottom_nav_bar.dart';
import 'package:cycletowork/src/ui/dashboard/widget/drawer.dart';
import 'package:cycletowork/src/ui/information/view.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart'
    as landing_view_model;
import 'package:cycletowork/src/ui/tracking_map/view.dart';
import 'package:cycletowork/src/ui/tracking_pause/view.dart';
import 'package:cycletowork/src/ui/profile/view.dart';
import 'package:cycletowork/src/ui/dashboard/widget/gps_icon.dart';
import 'package:cycletowork/src/ui/settings/view.dart';
import 'package:cycletowork/src/ui/tracking_stop/view.dart';
import 'package:cycletowork/src/ui/tracking/view.dart';
import 'package:cycletowork/src/utility/activity_recognition.dart';
import 'package:cycletowork/src/utility/gps.dart';
import 'package:cycletowork/src/widget/alart_dialog.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
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
      SettingsView(),
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
                return TrackingCounterView(
                  dismissKey: dismissKey,
                  counter: viewModel.uiState.workout!.countdown,
                  setCounter: (value) {
                    dismissKey = UniqueKey();
                    viewModel.setCounter(value);
                  },
                );
              }

              if (viewModel.uiState.dashboardPageOption ==
                  DashboardPageOption.startTracking) {
                return TrackingView(
                  showMap: viewModel.showMapTracking,
                  pauseTracking: viewModel.pauseTracking,
                  workout: viewModel.uiState.workout!,
                );
              }

              if (viewModel.uiState.dashboardPageOption ==
                  DashboardPageOption.pauseTracking) {
                return TrackingPauseView(
                  workout: viewModel.uiState.workout!,
                  isChallenge: viewModel.trackingUserActivity!.isChallenge == 1
                      ? true
                      : false,
                  playTracking: viewModel.playTracking,
                  stopTracking: viewModel.stopTracking,
                );
              }

              if (viewModel.uiState.dashboardPageOption ==
                  DashboardPageOption.stopTracking) {
                return TrackingStopView(
                  workout: viewModel.uiState.workout!,
                  isChallenge: viewModel.trackingUserActivity!.isChallenge == 1
                      ? true
                      : false,
                  onSnapshot: (value) =>
                      viewModel.setUserActivityImageData(value),
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
                  DashboardPageOption.mapTracking) {
                return TrackingMapView(
                  workout: viewModel.uiState.workout!,
                  isChallenge: viewModel.trackingUserActivity!.isChallenge == 1
                      ? true
                      : false,
                  pauseTracking: viewModel.pauseTracking,
                  hiddenMap: viewModel.hiddenMap,
                );
              }
              var isCenter = viewModel.uiState.appMenuOption.index == 0;
              var floatingActionButtonSize = (isCenter ? 100.0 : 50.0) * scale;
              return Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(size: 25.0 * scale),
                  toolbarHeight: AppData.user!.userType == UserType.other ||
                          !viewModel.uiState.showAppBarAction
                      ? 60.0 * scale
                      : 80.0 * scale,
                  elevation: 0.0,
                  centerTitle: true,
                  title: AppGpsIcon(
                    onPressed: () async {
                      var check = await _checkGpsAndPermission(context);
                      if (check) {
                        viewModel.refreshLocation();
                      }
                    },
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
                          viewModel.uiState.refreshLocationLoading ||
                          viewModel.uiState.refreshClassificationLoading,
                      visible: viewModel.uiState.showAppBarAction,
                    ),
                    SizedBox(
                      width: 10.0 * scale,
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
                            var isWakelockModeEnable =
                                context.read<AppData>().isWakelockModeEnable;
                            viewModel.startCounter(
                              context,
                              isWakelockModeEnable,
                            );
                          }
                        },
                      ),
                    ),
                    Positioned(
                      bottom: isCenter ? 80.0 * scale : 0.0,
                      right: 0,
                      left: isCenter ? 0 : null,
                      child: Container(
                        width: floatingActionButtonSize,
                        height: floatingActionButtonSize,
                        margin: EdgeInsets.only(
                          right: 20.0 * scale,
                          left: 20.0 * scale,
                          bottom: 20.0 * scale,
                        ),
                        child: FloatingActionButton(
                          onPressed: () async {
                            var check = await _checkGpsAndPermission(context);
                            if (check) {
                              var isWakelockModeEnable =
                                  context.read<AppData>().isWakelockModeEnable;
                              viewModel.startCounter(
                                context,
                                isWakelockModeEnable,
                              );
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/icons/start.svg',
                            height: floatingActionButtonSize,
                            width: floatingActionButtonSize,
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
    final scale = context.read<AppData>().scale;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = colorScheme.brightness == Brightness.light
        ? colorScheme.secondary
        : colorScheme.primary;
    var gpsStatus = await Gps.getGpsStatus();
    if (gpsStatus == GpsStatus.granted) {
      return await __checkActivityPermission(context);
    }

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
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    if (isIos) {
      await AppAlartDialog(
        context: context,
        title: '',
        subtitle: '',
        body: '',
        confirmLabel: '',
        barrierDismissible: false,
        justContent: true,
        contain: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 40 * scale,
                ),
                Text(
                  'A cosa ci serve sapere la tua posizione:',
                  style: textTheme.headline5,
                ),
                SizedBox(
                  height: 60 * scale,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 40.0 * scale,
                      color: color,
                    ),
                    SizedBox(
                      width: 15 * scale,
                    ),
                    Expanded(
                      child: Text(
                        'Per funzionare correttamente, devi consentire a Cycle2Work di rilevare la tua posizione per registrare il percorso che hai effettuato in bicicletta e calcolare quindi la quantità di CO\u2082 che hai risparmiato.',
                        style: textTheme.bodyText1,
                        maxLines: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 60.0,
              right: 0.0,
              left: 0.0,
              child: SizedBox(
                width: 250.0 * scale,
                height: 36.0,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      colorScheme.secondary,
                    ),
                  ),
                  child: Text(
                    'ACCETTO'.toUpperCase(),
                    style: textTheme.button!.copyWith(
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ).show();

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

      return await __checkActivityPermission(context);
    } else {
      var confirm = await AppAlartDialog(
        context: context,
        title: 'Permessi di localizzazione!',
        subtitle:
            "Per poter funzionare, Cycle2Work rileva la tua posizione (location) per registrare il percorso che hai effettuato in bicicletta e calcolare la quantità di CO\u2082 che hai risparmiato. Questo anche quando l'app sta funzionando in background.",
        body: '',
        confirmLabel: 'ACCETTO',
        cancelLabel: 'RIFIUTO',
        barrierDismissible: true,
        actionsAlignmentCenter: false,
      ).show();
      if (confirm == true) {
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

        return await __checkActivityPermission(context);
      } else {
        await AppAlartDialog(
          context: context,
          title: 'Permessi di localizzazione!',
          subtitle:
              "Ricorda che Cycle2Work non può funzionare senza rilevare la tua posizione (location), se desideri usare Cycle2Work in futuro devi assegnare i permessi all'app nelle impostazioni di localizzazione del tuo smartphone.",
          body: '',
          confirmLabel: 'CHIUDI',
        ).show();
      }
      return false;
    }
  }

  Future<bool> __checkActivityPermission(BuildContext context) async {
    var activityRecognitionStatus = await ActivityRecognition.checkPermission();

    if (activityRecognitionStatus == PermissionRequestResult.granted) {
      return true;
    }

    if (activityRecognitionStatus == PermissionRequestResult.denied) {
      final scale = context.read<AppData>().scale;
      final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;
      final color = colorScheme.brightness == Brightness.light
          ? colorScheme.secondary
          : colorScheme.primary;
      await AppAlartDialog(
        context: context,
        title: '',
        subtitle: '',
        body: '',
        confirmLabel: '',
        barrierDismissible: false,
        justContent: true,
        contain: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 40 * scale,
                ),
                Text(
                  'Perché vogliamo avere le informazioni relative alle tue attività:',
                  style: textTheme.headline5,
                ),
                SizedBox(
                  height: 60 * scale,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      size: 40.0 * scale,
                      color: color,
                    ),
                    SizedBox(
                      width: 15 * scale,
                    ),
                    Expanded(
                      child: Text(
                        'Per funzionare correttamente, devi consentire a Cycle2Work di accedere alle informazioni relative alle tue attività. In questo modo potrà verificare le attività che hai effettuato e confrontarle con quella che stai svolgendo per migliorare i parametri di misurazione.',
                        style: textTheme.bodyText1,
                        maxLines: 6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 60.0,
              right: 0.0,
              left: 0.0,
              child: SizedBox(
                width: 250.0 * scale,
                height: 36.0,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      colorScheme.secondary,
                    ),
                  ),
                  child: Text(
                    'ACCETTO'.toUpperCase(),
                    style: textTheme.button!.copyWith(
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ).show();

      activityRecognitionStatus = await ActivityRecognition.requestPermission();
      if (activityRecognitionStatus == PermissionRequestResult.granted) {
        return true;
      }
    }

    await AppAlartDialog(
      context: context,
      title: 'Attenzione!',
      subtitle:
          'Per poter funzionare, Cycle2Work richiede l’accesso alle informazioni relative alle tue attività. Puoi farlo nelle impostazioni di sistema.',
      body: '',
      confirmLabel: 'Ho capito',
    ).show();
    await AppSettings.openLocationSettings();
    return false;
  }
}
