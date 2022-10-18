import 'package:cycletowork/src/ui/personal_data_management/view_model.dart';
import 'package:cycletowork/src/widget/alart_dialog.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalDataManagementView extends StatelessWidget {
  const PersonalDataManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewModel>(
      create: (_) => ViewModel.instance(),
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

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Cancellazione Account',
                style: textTheme.bodyText1,
              ),
              leading: IconButton(
                splashRadius: 25.0,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: colorScheme.onBackground,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Cancellazione account e dati',
                    style: textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Stai per cancellare il tuo account. Proseguendo cancellerai anche tutte le informazioni relative al tuo profilo è alle tue attività.',
                    style: textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'L’eliminazione è un’azione permanente e irreversibile.',
                    style: textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 20,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: SizedBox(
                      width: 175.0,
                      height: 36.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          var isConfirmed = await AppAlartDialog(
                            context: context,
                            title: 'Attenzione!',
                            subtitle:
                                '''Stai per cancellare definitivamente il tuo account e tutti i dati relativi. Non potrai più accedere e utilizzare Cycle2Work con questo account.''',
                            body: 'Sei sicuro di voler continuare?',
                            confirmLabel: 'SI, ELIMINA',
                            iscConfirmDestructiveAction: true,
                            cancelLabel: 'NO, ANNULLA',
                            barrierDismissible: true,
                          ).show();
                          if (isConfirmed == true) {
                            var isDeleted = await viewModel.deleteAccount();
                            if (isDeleted == true) {
                              Navigator.of(context).popUntil(
                                (route) => route.isFirst,
                              );
                            }
                          }
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            colorScheme.secondary,
                          ),
                        ),
                        child: Text(
                          'Elimina account'.toUpperCase(),
                          style: textTheme.button!.copyWith(
                            color: colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
