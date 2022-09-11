import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileView extends StatelessWidget {
  final ChallengeRegistry? challengeRegistry;
  const EditProfileView({
    Key? key,
    this.challengeRegistry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final actionColor = colorSchemeExtension.action;
    final userImageUrl = AppData.user != null ? AppData.user!.photoURL : null;
    // final displayName = AppData.user != null ? AppData.user!.displayName : null;
    // final email = AppData.user != null ? AppData.user!.email : null;

    return Scaffold(
      body: SafeArea(
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
                    onPressed: () {},
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
                  radius: 50,
                  backgroundColor: Colors.grey[400],
                  backgroundImage:
                      userImageUrl != null ? NetworkImage(userImageUrl) : null,
                  child: userImageUrl == null
                      ? Icon(
                          Icons.person,
                          color: actionColor,
                          size: 50,
                        )
                      : Container(),
                ),
                const SizedBox(
                  height: 5.0,
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
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit,
                        color: colorScheme.secondary,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Modifica immagine',
                        style: textTheme.bodyText1!.copyWith(
                          color: colorScheme.secondary,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                maxLength: 40,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                initialValue: "name",
                onChanged: (value) {
                  // viewModel.setName(value);
                },
                decoration: InputDecoration(
                  labelText: 'Nome *',
                  labelStyle: textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: colorSchemeExtension.textDisabled,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire nome';
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                maxLength: 40,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                initialValue: 'lastName',
                // onChanged: (value) => viewModel.setLastName(value),
                decoration: InputDecoration(
                  labelText: 'Cognome *',
                  labelStyle: textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: colorSchemeExtension.textDisabled,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire cognome';
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Container(
              color: const Color.fromRGBO(239, 239, 239, 1),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              height: 82,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'FIAB MILANO 2022',
                    style: textTheme.headline6,
                  ),
                  Text(
                    'I tuoi informazione che hai scritto nel challenge',
                    style: textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    maxLength: 40,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Indirizzo email aziendale*',
                    ),
                    initialValue: 'test@test.com',
                    // onChanged: (value) => viewModel.setAddress(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserire indirizzo';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLength: 40,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Nome azienda',
                    ),
                    initialValue: 'Test srl',
                    // onChanged: (value) => viewModel.setAddress(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserire nome azienda';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLength: 40,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Dipartimento',
                    ),
                    initialValue: 'A',
                    // onChanged: (value) => viewModel.setAddress(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserire dipartimento';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
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
                    initialValue: '12345',
                    // onChanged: (value) => viewModel.setZipCode(value),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 5) {
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
                    initialValue: 'address',
                    // onChanged: (value) => viewModel.setAddress(value),
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
                    initialValue: 'city',
                    // onChanged: (value) => viewModel.setCity(value),
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
            )
          ],
        ),
      ),
    );
  }
}
