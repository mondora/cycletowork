import 'package:cycletowork/src/ui/dashboard/view.dart';
import 'package:cycletowork/src/ui/landing/ui_state.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:cycletowork/src/ui/login/view.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

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

            if (viewModel.uiState.pageOption == PageOption.loading) {
              return const Scaffold(
                body: Center(
                  child: AppProgressIndicator(),
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
