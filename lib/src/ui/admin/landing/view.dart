import 'package:cycletowork/src/ui/admin/dashboard/view.dart';
import 'package:cycletowork/src/ui/admin/login/view.dart';
import 'package:cycletowork/src/ui/landing/ui_state.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminLandingView extends StatelessWidget {
  const AdminLandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ChangeNotifierProvider<ViewModel>(
        create: (_) => ViewModel.instance(isAdmin: true),
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
            if (viewModel.uiState.pageOption == PageOption.loading) {
              return const AdminLoginView(loading: true);
            }

            if (viewModel.uiState.pageOption == PageOption.logout) {
              return const AdminLoginView();
            }
            if (viewModel.uiState.pageOption == PageOption.home) {
              return const AdminDashboardView();
            }

            return const AdminLoginView();
          },
        ),
      ),
    );
  }
}
