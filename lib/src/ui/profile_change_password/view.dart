import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/profile_change_password/view_model.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileChangePasswordView extends StatefulWidget {
  const ProfileChangePasswordView({super.key});

  @override
  State<ProfileChangePasswordView> createState() =>
      _ProfileChangePasswordViewState();
}

class _ProfileChangePasswordViewState extends State<ProfileChangePasswordView> {
  var formKey = GlobalKey<FormState>();
  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var reNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
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
                      margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(16.0 * scale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0 * scale),
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
                              padding: EdgeInsets.all(16.0 * scale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0 * scale),
                                ),
                              ),
                              foregroundColor: colorScheme.secondary,
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                var currentPassword =
                                    currentPasswordController.text;
                                var newPassword = newPasswordController.text;
                                var result =
                                    await viewModel.changePasswordForEmail(
                                  currentPassword,
                                  newPassword,
                                );

                                if (result == true) {
                                  final snackBar = SnackBar(
                                    backgroundColor:
                                        colorSchemeExtension.success,
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'LA TUA NUOVA PASSWORD È STATA CAMBIATA!'
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

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: Text(
                              'Salva',
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
                          radius: 50 * scale,
                          backgroundColor: Colors.grey[400],
                          backgroundImage: userImageUrl != null
                              ? NetworkImage(userImageUrl)
                              : null,
                          child: userImageUrl == null
                              ? Icon(
                                  Icons.person,
                                  color: actionColor,
                                  size: 50 * scale,
                                )
                              : Container(),
                        ),
                        SizedBox(
                          height: 15.0 * scale,
                        ),
                        Text(
                          displayName ?? '',
                          style: textTheme.bodyText1,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20 * scale,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
                      child: TextFormField(
                        controller: currentPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Password attuale*',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserire  password attuale';
                          }
                          if (value.length < 8) {
                            return 'La password attuale deve contenere almeno 8 caratteri';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20 * scale,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
                      child: TextFormField(
                        controller: newPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Nuova password*',
                          helperText:
                              'La password deve contenere almeno 8 caratteri',
                          hintMaxLines: 2,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserire nuova password';
                          }
                          if (value.length < 8) {
                            return 'La nuova password deve contenere almeno 8 caratteri';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20 * scale,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
                      child: TextFormField(
                        controller: reNewPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Ripeti la nuova password*',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserire nuova password';
                          }
                          if (value != newPasswordController.text) {
                            return 'Inserire nuova password uguale';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0 * scale,
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
