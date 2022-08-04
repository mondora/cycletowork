import 'package:cycletowork/src/ui/dashboard/view.dart';
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
    return ChangeNotifierProvider<LandingViewModel>(
      create: (_) => LandingViewModel.instance(),
      child: Consumer<LandingViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.status == LandingViewModelStatus.logout) {
            return const LoginView();
          }
          if (viewModel.status == LandingViewModelStatus.home) {
            return const DashboardView();
          }
          if (viewModel.status == LandingViewModelStatus.signup) {
            return const SignupEmailView();
          }
          if (viewModel.status == LandingViewModelStatus.loading) {
            return const LoginView(loading: true);
          }

          return const LoginView();
        },
      ),
    );
  }
}
