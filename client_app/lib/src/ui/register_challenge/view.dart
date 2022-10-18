import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/ui/register_challenge/ui_state.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:cycletowork/src/ui/register_challenge_champion/view.dart';
import 'package:cycletowork/src/ui/register_challenge_champion_data/view.dart';
import 'package:cycletowork/src/ui/register_challenge_cyclist/view.dart';
import 'package:cycletowork/src/ui/register_challenge_cyclist_data/view.dart';
import 'package:cycletowork/src/ui/register_challenge_email_verifiy/view.dart';
import 'package:cycletowork/src/ui/register_challenge_select_type/view.dart';
import 'package:cycletowork/src/ui/register_challenge_thanks/view.dart';
import 'package:cycletowork/src/ui/survey/view.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterChallengeView extends StatelessWidget {
  final Challenge challenge;
  const RegisterChallengeView({
    Key? key,
    required this.challenge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewModel>(
      create: (_) => ViewModel.instance(challenge, context),
      child: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
          var textTheme = Theme.of(context).textTheme;
          var colorScheme = Theme.of(context).colorScheme;

          if (viewModel.uiState.error) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                      SnackBar(
                        backgroundColor: colorScheme.error,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: colorScheme.onError,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                viewModel.uiState.errorMessage.toUpperCase(),
                                style: textTheme.caption!.apply(
                                  color: colorScheme.onError,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
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

          if (viewModel.uiState.loading) {
            return const Scaffold(
              body: Center(
                child: AppProgressIndicator(),
              ),
            );
          }

          if (viewModel.uiState.pageOption == PageOption.selectType) {
            return const RegisterChallengSelectTypeView();
          }

          if (viewModel.uiState.pageOption == PageOption.cyclistRegistration) {
            return const RegisterChallengCyclistView();
          }

          if (viewModel.uiState.pageOption ==
              PageOption.cyclistRegistrationData) {
            return const RegisterChallengCyclistDataView();
          }

          if (viewModel.uiState.pageOption == PageOption.emailVerification) {
            return const RegisterChallengEmailVerifyView();
          }

          if (viewModel.uiState.pageOption == PageOption.thanks) {
            return const RegisterChallengThanksView();
          }

          if (viewModel.uiState.pageOption == PageOption.survey) {
            return const SurveyView();
          }

          if (viewModel.uiState.pageOption == PageOption.championRegistration) {
            return const RegisterChallengChampionView();
          }

          if (viewModel.uiState.pageOption ==
              PageOption.championRegistrationData) {
            return const RegisterChallengCompanyDataView();
          }

          return const Scaffold();
        },
      ),
    );
  }
}
