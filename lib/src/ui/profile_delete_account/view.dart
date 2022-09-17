import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/profile_delete_account/view_model.dart';
import 'package:cycletowork/src/widget/alart_dialog.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDeleteAccountView extends StatefulWidget {
  const ProfileDeleteAccountView({
    super.key,
  });

  @override
  State<ProfileDeleteAccountView> createState() =>
      _ProfileDeleteAccountViewState();
}

class _ProfileDeleteAccountViewState extends State<ProfileDeleteAccountView> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final actionColor = colorSchemeExtension.action;
    final userImageUrl = AppData.user != null ? AppData.user!.photoURL : null;
    final displayName = AppData.user != null ? AppData.user!.displayName : null;

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
            body: Form(
              key: formKey,
              child: SafeArea(
                child: ListView(
                  physics: const ScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              foregroundColor: colorScheme.secondary,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Annulla',
                              style: textTheme.caption!.copyWith(
                                color: colorScheme.secondary,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              foregroundColor: colorScheme.secondary,
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                var isConfirmed = await AppAlartDialog(
                                  context: context,
                                  title: 'Attenzione!',
                                  subtitle:
                                      "Desideri davvero cancellare il tuo account?",
                                  body: '',
                                  confirmLabel: 'Sì, desidero cancellare',
                                  barrierDismissible: true,
                                ).show();
                                if (isConfirmed == true) {
                                  var isDeleted =
                                      await viewModel.deleteAccount();
                                  if (isDeleted == true) {
                                    Navigator.of(context).popUntil(
                                      (route) => route.isFirst,
                                    );
                                  }
                                }
                              }
                            },
                            child: Text(
                              'Cancella Account',
                              style: textTheme.caption!.copyWith(
                                color: colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[400],
                          backgroundImage: userImageUrl != null
                              ? NetworkImage(userImageUrl)
                              : null,
                          child: userImageUrl == null
                              ? Icon(
                                  Icons.person,
                                  color: actionColor,
                                  size: 50,
                                )
                              : Container(),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          displayName ?? '',
                          style: textTheme.bodyText1,
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Cancellare i dati',
                        style: textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        // maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Attenzione!',
                        style: textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'La cancellazione dei dati sarà definitiva e i dati non potranno più essere recuperati.',
                        style: textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Inserire La tua email per confermare cancellazione dei dati.',
                        style: textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Email*',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserire  email';
                          }
                          if (value != AppData.user!.email) {
                            return 'Inserire email valido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
