import 'package:cycletowork/src/ui/dashboard/view.dart';
import 'package:cycletowork/src/ui/landing/ui_state.dart';
import 'package:cycletowork/src/ui/landing/view_model.dart';
import 'package:cycletowork/src/ui/login/view.dart';
import 'package:cycletowork/src/ui/signup_email/view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingView extends StatelessWidget {
  const LandingView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewModel>(
      create: (_) => ViewModel.instance(),
      child: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.uiState.pageOption == PageOption.loading) {
            return const LoginView(loading: true);
          }

          if (viewModel.uiState.pageOption == PageOption.logout) {
            return const LoginView();
          }
          if (viewModel.uiState.pageOption == PageOption.home) {
            return const DashboardView();
          }
          if (viewModel.uiState.pageOption == PageOption.signup) {
            return const SignupEmailView();
          }

          return const LoginView();
        },
      ),
    );
  }
}
