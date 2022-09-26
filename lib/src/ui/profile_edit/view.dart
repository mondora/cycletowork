import 'package:app_settings/app_settings.dart';
import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/camera/view.dart';
import 'package:cycletowork/src/ui/profile_edit/view_model.dart';
import 'package:cycletowork/src/widget/alart_dialog.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:cycletowork/src/widget/selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class ProfileEditView extends StatefulWidget {
  final ChallengeRegistry? challengeRegistry;
  const ProfileEditView({
    Key? key,
    this.challengeRegistry,
  }) : super(key: key);

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  var formKey = GlobalKey<FormState>();
  var displayNameController = TextEditingController();

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
          displayNameController.text = displayName ?? '';

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
                                var newDisplayName = displayNameController.text;
                                if (newDisplayName != displayName) {
                                  var result =
                                      await viewModel.changeDisplayName(
                                    newDisplayName,
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
                                                'IL TUO NICK NAME È STATA CAMBIATA!'
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
                                    Navigator.pop(context, true);
                                  }
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
                          height: 5.0 * scale,
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
                            var select = await AppSelectionDialog(
                              context: context,
                              listLabel: [
                                'Scatta una foto',
                                'Scegli dalla libreria',
                                'Annulla',
                              ],
                              barrierDismissible: true,
                            ).show();
                            if (select == null || select == 'Annulla') {
                              return;
                            }
                            if (select == 'Scatta una foto') {
                              var isAndroid = defaultTargetPlatform ==
                                  TargetPlatform.android;
                              PermissionStatus? status;
                              if (!isAndroid) {
                                status = await Permission.camera.request();
                              }
                              if (isAndroid ||
                                  (status != null && status.isGranted)) {
                                String? imagePath =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const CameraView(),
                                  ),
                                );
                                if (imagePath != null) {
                                  var result =
                                      await viewModel.changePhotoURL(imagePath);
                                  Navigator.pop(context, result);
                                }
                              } else {
                                await AppAlartDialog(
                                  context: context,
                                  title: 'Attenzione!',
                                  subtitle:
                                      "Per poter cambiare l'immagine del tuo profilo devi consentire a Cycle2Work di accedere alla fotocamera del tuo dispositivo",
                                  body: '',
                                  confirmLabel: 'Ho capito',
                                ).show();
                                await AppSettings.openAppSettings();
                              }
                            } else {
                              final ImagePicker _picker = ImagePicker();
                              final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (image != null) {
                                var result =
                                    await viewModel.changePhotoURL(image.path);
                                Navigator.pop(context, result);
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit,
                                color: colorScheme.secondary,
                                size: 20 * scale,
                              ),
                              SizedBox(
                                width: 5 * scale,
                              ),
                              Text(
                                'Modifica immagine',
                                style: textTheme.bodyText1!.copyWith(
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20 * scale,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
                      child: TextFormField(
                        controller: displayNameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLength: 40,
                        obscureText: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Nick name',
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20 * scale,
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
