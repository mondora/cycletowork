import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/profile_challenge_edit/view_model.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfileChallengeEditView extends StatefulWidget {
  final ChallengeRegistry challengeRegistry;

  const ProfileChallengeEditView({
    Key? key,
    required this.challengeRegistry,
  }) : super(key: key);

  @override
  State<ProfileChallengeEditView> createState() =>
      _ProfileChallengeEditViewState();
}

class _ProfileChallengeEditViewState extends State<ProfileChallengeEditView> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var lastNameController = TextEditingController();
  var zipCodeController = TextEditingController();
  var cityController = TextEditingController();
  var addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scale = context.read<AppData>().scale;
    final colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    final color = colorScheme.brightness == Brightness.light
        ? colorScheme.secondary
        : colorScheme.primary;

    return ChangeNotifierProvider<ViewModel>(
      create: (_) => ViewModel.instance(),
      child: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
          var textTheme = Theme.of(context).textTheme;
          var colorScheme = Theme.of(context).colorScheme;
          nameController.text = widget.challengeRegistry.name;
          lastNameController.text = widget.challengeRegistry.lastName;
          zipCodeController.text = widget.challengeRegistry.zipCode;
          cityController.text = widget.challengeRegistry.city;
          addressController.text = widget.challengeRegistry.address;

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
                              foregroundColor: color,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Annulla',
                              style: textTheme.caption!.copyWith(
                                color: color,
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
                              foregroundColor: color,
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                var name = widget.challengeRegistry.name;
                                var lastName =
                                    widget.challengeRegistry.lastName;
                                var newName = nameController.text;
                                var newLastName = lastNameController.text;
                                var zipCode = widget.challengeRegistry.zipCode;
                                var city = widget.challengeRegistry.city;
                                var address = widget.challengeRegistry.address;
                                var newZipCode = zipCodeController.text;
                                var newCity = cityController.text;
                                var newAddress = addressController.text;
                                if (newZipCode != zipCode ||
                                    newCity != city ||
                                    newAddress != address ||
                                    newName != name ||
                                    newLastName != lastName) {
                                  widget.challengeRegistry.name = newName;
                                  widget.challengeRegistry.lastName =
                                      newLastName;
                                  widget.challengeRegistry.zipCode = newZipCode;
                                  widget.challengeRegistry.city = newCity;
                                  widget.challengeRegistry.address = newAddress;
                                  var result =
                                      await viewModel.updateUserInfoInChallenge(
                                    widget.challengeRegistry,
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
                                                'I TUOI DATI SONO STATI CAMBIATI!'
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
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40 * scale,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.challengeRegistry.challengeName,
                          style: textTheme.headline6,
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.0 * scale),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30.0 * scale,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            readOnly: true,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Indirizzo email aziendale*',
                              filled: true,
                            ),
                            initialValue:
                                widget.challengeRegistry.businessEmail,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserire email';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20 * scale,
                          ),
                          TextFormField(
                            // maxLength: 40,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            readOnly: true,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Azienda',
                              filled: true,
                            ),
                            initialValue: widget.challengeRegistry.companyName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserire nome azienda';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20 * scale,
                          ),
                          if (widget
                              .challengeRegistry.departmentName.isNotEmpty)
                            TextFormField(
                              maxLength: 40,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              readOnly: true,
                              enabled: false,
                              decoration: const InputDecoration(
                                labelText: 'Dipartimento',
                                filled: true,
                              ),
                              initialValue:
                                  widget.challengeRegistry.departmentName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserire dipartimento';
                                }

                                return null;
                              },
                            ),
                          SizedBox(
                            height: 20 * scale,
                          ),
                          TextFormField(
                            maxLength: 40,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Nome*',
                            ),
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserire nome';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10 * scale,
                          ),
                          TextFormField(
                            maxLength: 40,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Cognome*',
                            ),
                            controller: lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserire cognome';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10 * scale,
                          ),
                          TextFormField(
                            maxLength: 5,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'CAP *',
                            ),
                            controller: zipCodeController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 5) {
                                return 'Inserire CAP';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            maxLength: 40,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Indirizzo *',
                            ),
                            controller: addressController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserire indirizzo';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            maxLength: 30,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Città *',
                            ),
                            controller: cityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Inserire città';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
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
