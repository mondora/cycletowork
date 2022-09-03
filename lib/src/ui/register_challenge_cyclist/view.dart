import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterChallengCyclistView extends StatefulWidget {
  const RegisterChallengCyclistView({Key? key}) : super(key: key);

  @override
  State<RegisterChallengCyclistView> createState() =>
      _RegisterChallengCyclistViewState();
}

class _RegisterChallengCyclistViewState
    extends State<RegisterChallengCyclistView> {
  final formKey = GlobalKey<FormState>();
  final aboutFiabUrl = 'https://www.sataspes.net/android/sp-budget';
  final emailFiab = 'info@fiab.it';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    var isFiabMember = viewModel.uiState.challengeRegistry.isFiabMember;
    var fiabCardNumber = viewModel.uiState.challengeRegistry.fiabCardNumber;
    var departmentName = viewModel.uiState.challengeRegistry.departmentName;
    var listCompany = viewModel.uiState.listCompany;
    var companySelected = viewModel.uiState.challengeRegistry.companySelected;
    var companyName = viewModel.uiState.challengeRegistry.companyName;

    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(
          top: 20.0,
          bottom: 30.0,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                  ),
                  child: Text(
                    'Iscrizione ciclista',
                    style: textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 185,
                  color: const Color.fromRGBO(249, 249, 249, 1),
                  padding: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                    top: 15.0,
                    bottom: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sei socio FIAB?',
                        style: textTheme.caption!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              onTap: () {
                                viewModel.setFiabMember(!isFiabMember);
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4.5),
                                width: 80.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: isFiabMember,
                                      onChanged: (value) {
                                        viewModel.setFiabMember(value!);
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Si',
                                        style: textTheme.bodyText1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              onTap: () {
                                viewModel.setFiabMember(!isFiabMember);
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4.5),
                                width: 80.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: !isFiabMember,
                                      onChanged: (value) {
                                        viewModel.setFiabMember(!value!);
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        'No',
                                        style: textTheme.bodyText1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!isFiabMember)
                        SizedBox(
                          width: 245.0,
                          height: 36.0,
                          child: TextButton(
                            onPressed: () async {
                              final url = Uri.parse(aboutFiabUrl);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                );
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              overlayColor: MaterialStateProperty.all<Color>(
                                colorScheme.secondary.withOpacity(0.40),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Scopri come diventarlo'.toUpperCase(),
                                  style: textTheme.button!.copyWith(
                                    color: colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Icon(
                                  Icons.call_made_outlined,
                                  color: colorScheme.secondary,
                                  size: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (isFiabMember)
                        TextFormField(
                          initialValue: fiabCardNumber,
                          onChanged: (value) =>
                              viewModel.changeFiabCardNumber(value),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Numero tessera',
                            labelStyle: textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: colorSchemeExtension.textDisabled,
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty && isFiabMember) {
                              return 'Inserire numero tessera';
                            }

                            return null;
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        right: 24.0,
                        left: 24.0,
                      ),
                      child: Text(
                        'Seleziona la tua azienda',
                        style: textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 24.0,
                        left: 24.0,
                      ),
                      child: Text(
                        'Se la tua azienda non è nell’elenco, ma sai che dovrebbe esserci, contatta il tuo referente.',
                        style: textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorSchemeExtension.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: SearchField(
                        suggestionState: Suggestion.expand,
                        suggestionAction: SuggestionAction.next,
                        maxSuggestionsInViewPort: 10,
                        itemHeight: 50,
                        textInputAction: TextInputAction.next,
                        suggestions: listCompany
                            .map((e) => SearchFieldListItem(e.name))
                            .toList(),
                        initialValue: companyName != ''
                            ? SearchFieldListItem(companyName)
                            : null,
                        searchInputDecoration: InputDecoration(
                          labelText: 'Seleziona la tua azienda',
                          suffixIcon: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: colorSchemeExtension.textSecondary,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleziona la tua azienda';
                          }
                          // if (CategoriaStabulazione.getCategoriaStabulazioneCode(
                          //         value) ==
                          //     null) {
                          //   return 'Inserire categoria stabulazione valida';
                          // }
                          return null;
                        },
                        onSuggestionTap: (value) {
                          viewModel.setCompanyName(value.searchKey);
                        },
                        onSubmit: (value) {
                          viewModel.searchCompanyName(value);
                        },
                      ),
                    ),
                    if (companySelected != null &&
                        companySelected.listDepartment != null &&
                        companySelected.listDepartment!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(
                          right: 24.0,
                          left: 24.0,
                          top: 20.0,
                          bottom: 20.0,
                        ),
                        child: SearchField(
                          suggestionState: Suggestion.expand,
                          suggestionAction: SuggestionAction.next,
                          maxSuggestionsInViewPort: 10,
                          itemHeight: 50,
                          textInputAction: TextInputAction.next,
                          suggestions: companySelected.listDepartment!
                              .map((e) => SearchFieldListItem(e.name))
                              .toList(),
                          searchInputDecoration: InputDecoration(
                            labelText: 'Seleziona la sede e/o il dipartimento',
                            suffixIcon: Icon(
                              Icons.arrow_drop_down_outlined,
                              color: colorSchemeExtension.textSecondary,
                            ),
                          ),
                          initialValue: departmentName != ''
                              ? SearchFieldListItem(departmentName)
                              : null,
                          onSuggestionTap: (value) {
                            viewModel.setDepartmentName(value.searchKey);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Seleziona la sede e/o il dipartimento';
                            }

                            // if (!listDepartment.contains(value)) {
                            //   return 'Inserire la sede e/o il dipartimento valida';
                            // }
                            return null;
                          },
                        ),
                      ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 24.0,
                        left: 24.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimaryContainer,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              'La tua azienda non partecipa?'.toUpperCase(),
                              style: textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              top: 15.0,
                              bottom: 15.0,
                              right: 20.0,
                              left: 20.0,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Chiedi al tuo ',
                                        style: textTheme.subtitle1!.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Mobility Manager',
                                        style: textTheme.subtitle1!.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ', oppure alle ',
                                        style: textTheme.subtitle1!.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Risorse Umane',
                                        style: textTheme.subtitle1!.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ', di contattarci all’indirizzo email:',
                                        style: textTheme.subtitle1!.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                SelectableText(
                                  emailFiab,
                                  style: textTheme.subtitle1!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    color: colorScheme.secondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: 155.0,
                    height: 36.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          viewModel.gotoCyclistRegistrationData();
                        }
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            colorScheme.secondary),
                      ),
                      child: Text(
                        'Prosegui'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: SizedBox(
                    width: 155.0,
                    height: 36.0,
                    child: OutlinedButton(
                      onPressed: viewModel.gotoSelectType,
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          colorScheme.onSecondary,
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          colorScheme.secondary.withOpacity(0.40),
                        ),
                      ),
                      child: Text(
                        'Torna indietro'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
