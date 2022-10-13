import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/dashboard/view.dart';
import 'package:cycletowork/src/ui/landing/ui_state.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:cycletowork/src/ui/landing_login/view.dart';
import 'package:cycletowork/src/ui/landing_login_email/view.dart';
import 'package:cycletowork/src/ui/landing_signup_email/view.dart';
import 'package:cycletowork/src/utility/notification.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingView extends StatefulWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  void initState() {
    super.initState();
    if (!kDebugMode) {
      AppNotification.requestPermission();
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _configScreen(context),
    );
  }

  _configScreen(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    if (width < 375.0) {
      var scale = width / 375.0;
      context.read<AppData>().setScaleThemeData(scale);
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var width = MediaQuery.of(context).size.width;
    var scale = 1.0;
    if (width < 375.0) {
      scale = width / 375.0;
    }
    var currenScreenScale = context.read<AppData>().scale;

    return Scaffold(
      body: ChangeNotifierProvider<ViewModel>(
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
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  viewModel.uiState.errorMessage.toUpperCase(),
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
                      )
                      .closed
                      .then((value) => viewModel.clearError());
                },
              );
            }

            if (viewModel.uiState.pageOption == PageOption.loginEmail) {
              return const LoginEmailView();
            }

            if (viewModel.uiState.pageOption == PageOption.signupEmail) {
              return const SignupEmailView();
            }

            if (viewModel.uiState.loading == true ||
                currenScreenScale != scale) {
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.primary,
                body: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        image: AssetImage(
                          'assets/images/login.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: AppProgressIndicator(
                        color: colorScheme.secondary,
                      ),
                    )
                  ],
                ),
              );
            }

            if (viewModel.uiState.pageOption == PageOption.logout) {
              return const LoginView();
            }
            if (viewModel.uiState.pageOption == PageOption.home) {
              return const DashboardView();
            }

            return const LoginView();
          },
        ),
      ),
    );
  }
}
