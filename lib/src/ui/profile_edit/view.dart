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
                              var status = await Permission.camera.request();
                              if (status.isGranted) {
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
                                      "È necessario acconsentire all'utilizzo della fotocamera",
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
//   @override
//   Widget build(BuildContext context) {
//     final colorSchemeExtension =
//         Theme.of(context).extension<ColorSchemeExtension>()!;
//     var colorScheme = Theme.of(context).colorScheme;
//     var textTheme = Theme.of(context).textTheme;
//     final actionColor = colorSchemeExtension.action;
//     final userImageUrl = AppData.user != null ? AppData.user!.photoURL : null;
//     // final displayName = AppData.user != null ? AppData.user!.displayName : null;
//     // final email = AppData.user != null ? AppData.user!.email : null;

//     return Scaffold(
//       body: SafeArea(
//         child: ListView(
//           physics: const ScrollPhysics(),
//           padding: EdgeInsets.zero,
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.all(16.0),
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(15.0),
//                         ),
//                       ),
//                       foregroundColor: colorScheme.secondary,
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                     child: Text(
//                       'Annulla',
//                       style: textTheme.caption!.copyWith(
//                         color: colorScheme.secondary,
//                       ),
//                     ),
//                   ),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.all(16.0),
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(15.0),
//                         ),
//                       ),
//                       foregroundColor: colorScheme.secondary,
//                     ),
//                     onPressed: () {},
//                     child: Text(
//                       'Salva',
//                       style: textTheme.caption!.copyWith(
//                         color: colorScheme.secondary,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.grey[400],
//                   backgroundImage:
//                       userImageUrl != null ? NetworkImage(userImageUrl) : null,
//                   child: userImageUrl == null
//                       ? Icon(
//                           Icons.person,
//                           color: actionColor,
//                           size: 50,
//                         )
//                       : Container(),
//                 ),
//                 const SizedBox(
//                   height: 5.0,
//                 ),
//                 TextButton(
//                   style: TextButton.styleFrom(
//                     padding: const EdgeInsets.all(16.0),
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(15.0),
//                       ),
//                     ),
//                     foregroundColor: colorScheme.secondary,
//                   ),
//                   onPressed: () {},
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.edit,
//                         color: colorScheme.secondary,
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         'Modifica immagine',
//                         style: textTheme.bodyText1!.copyWith(
//                           color: colorScheme.secondary,
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: TextFormField(
//                 maxLength: 40,
//                 keyboardType: TextInputType.text,
//                 textInputAction: TextInputAction.next,
//                 initialValue: "name",
//                 onChanged: (value) {
//                   // viewModel.setName(value);
//                 },
//                 decoration: InputDecoration(
//                   labelText: 'Nome *',
//                   labelStyle: textTheme.bodyText1!.copyWith(
//                     fontWeight: FontWeight.w400,
//                     color: colorSchemeExtension.textDisabled,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Inserire nome';
//                   }

//                   return null;
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 10.0,
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: TextFormField(
//                 maxLength: 40,
//                 keyboardType: TextInputType.text,
//                 textInputAction: TextInputAction.next,
//                 initialValue: 'lastName',
//                 // onChanged: (value) => viewModel.setLastName(value),
//                 decoration: InputDecoration(
//                   labelText: 'Cognome *',
//                   labelStyle: textTheme.bodyText1!.copyWith(
//                     fontWeight: FontWeight.w400,
//                     color: colorSchemeExtension.textDisabled,
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Inserire cognome';
//                   }

//                   return null;
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 30.0,
//             ),
//             Container(
//               color: const Color.fromRGBO(239, 239, 239, 1),
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               height: 82,
//               width: double.infinity,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'FIAB MILANO 2022',
//                     style: textTheme.headline6,
//                   ),
//                   Text(
//                     'I tuoi informazione che hai scritto nel challenge',
//                     style: textTheme.bodyText2,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 20.0,
//                   ),
//                   TextFormField(
//                     maxLength: 40,
//                     keyboardType: TextInputType.text,
//                     textInputAction: TextInputAction.next,
//                     readOnly: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Indirizzo email aziendale*',
//                     ),
//                     initialValue: 'test@test.com',
//                     // onChanged: (value) => viewModel.setAddress(value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Inserire indirizzo';
//                       }

//                       return null;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     maxLength: 40,
//                     keyboardType: TextInputType.text,
//                     textInputAction: TextInputAction.next,
//                     readOnly: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Nome azienda',
//                     ),
//                     initialValue: 'Test srl',
//                     // onChanged: (value) => viewModel.setAddress(value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Inserire nome azienda';
//                       }

//                       return null;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     maxLength: 40,
//                     keyboardType: TextInputType.text,
//                     textInputAction: TextInputAction.next,
//                     readOnly: true,
//                     decoration: const InputDecoration(
//                       labelText: 'Dipartimento',
//                     ),
//                     initialValue: 'A',
//                     // onChanged: (value) => viewModel.setAddress(value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Inserire dipartimento';
//                       }

//                       return null;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     maxLength: 5,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                     ],
//                     textInputAction: TextInputAction.next,
//                     decoration: const InputDecoration(
//                       labelText: 'CAP *',
//                     ),
//                     initialValue: '12345',
//                     // onChanged: (value) => viewModel.setZipCode(value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty || value.length < 5) {
//                         return 'Inserire CAP';
//                       }

//                       return null;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10.0,
//                   ),
//                   TextFormField(
//                     maxLength: 40,
//                     keyboardType: TextInputType.text,
//                     textInputAction: TextInputAction.next,
//                     decoration: const InputDecoration(
//                       labelText: 'Indirizzo *',
//                     ),
//                     initialValue: 'address',
//                     // onChanged: (value) => viewModel.setAddress(value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Inserire indirizzo';
//                       }

//                       return null;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10.0,
//                   ),
//                   TextFormField(
//                     maxLength: 30,
//                     keyboardType: TextInputType.text,
//                     textInputAction: TextInputAction.next,
//                     decoration: const InputDecoration(
//                       labelText: 'Città *',
//                     ),
//                     initialValue: 'city',
//                     // onChanged: (value) => viewModel.setCity(value),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Inserire città';
//                       }

//                       return null;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10.0,
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ListChallengeItem extends StatelessWidget {
//   final String title;
//   final GestureTapCancelCallback? onPressed;
//   const _ListChallengeItem({
//     Key? key,
//     required this.title,
//     required this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var scale = context.read<AppData>().scale;
//     var colorScheme = Theme.of(context).colorScheme;
//     var textTheme = Theme.of(context).textTheme;
//     return Column(
//       children: [
//         SizedBox(
//           height: 63.0 * scale,
//           child: ListTile(
//             leading: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title,
//                   style: textTheme.bodyText1,
//                 ),
//               ],
//             ),
//             trailing: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   color: colorScheme.onBackground,
//                   size: 25 * scale,
//                 ),
//               ],
//             ),
//             onTap: onPressed,
//           ),
//         ),
//         Container(
//           height: 1.5,
//           color: const Color.fromRGBO(0, 0, 0, 0.12),
//         ),
//       ],
//     );
//   }
// }
