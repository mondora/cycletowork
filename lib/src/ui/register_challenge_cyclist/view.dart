import 'package:auto_size_text/auto_size_text.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
  final aboutFiabUrl = 'https://www.fiabitalia.it/diventa-socio';
  final emailFiab = 'info@fiab.it';

  var companyNameSearchedController = TextEditingController();
  List<Company> listSelectedCompany = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    var isFiabMember = viewModel.uiState.challengeRegistry.isFiabMember;
    var fiabCardNumber = viewModel.uiState.challengeRegistry.fiabCardNumber;
    var departmentName = viewModel.uiState.challengeRegistry.departmentName;
    var listCompany = viewModel.uiState.listCompany;
    var companySelected = viewModel.uiState.challengeRegistry.companySelected;
    companyNameSearchedController.text =
        viewModel.uiState.challengeRegistry.companyName;

    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 25.0,
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onBackground,
            size: 20,
          ),
          onPressed: () => viewModel.gotoSelectType(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 30.0,
          ),
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
                                AutoSizeText(
                                  'Scopri come diventarlo'.toUpperCase(),
                                  style: textTheme.button!.copyWith(
                                    color: colorScheme.secondary,
                                  ),
                                  maxLines: 1,
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
                      child: TextFormField(
                        readOnly: true,
                        controller: companyNameSearchedController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Seleziona la tua azienda',
                          hintStyle: textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: colorSchemeExtension.textDisabled,
                          ),
                        ),
                        onTap: () async {
                          await FilterListDialog.display<Company>(
                            context,
                            hideSelectedTextCount: true,
                            barrierDismissible: true,
                            hideCloseIcon: true,
                            themeData: FilterListThemeData(context).copyWith(
                              borderRadius: 15.0,
                              headerTheme: const HeaderThemeData(
                                searchFieldBorderRadius: 15.0,
                                searchFieldHintText:
                                    'Cerca la tua azienda qua ...',
                              ),
                              choiceChipTheme: ChoiceChipThemeData(
                                selectedBackgroundColor: colorScheme.secondary,
                                labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                              ),
                              controlBarButtonTheme:
                                  ControlButtonBarThemeData(context).copyWith(
                                margin: const EdgeInsets.all(15.0),
                                // controlContainerDecoration: const BoxDecoration(
                                //   borderRadius: BorderRadius.all(
                                //     Radius.circular(10),
                                //   ),
                                // ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                // backgroundColor: Colors.amber,
                                controlButtonTheme: ControlButtonThemeData(
                                  primaryButtonBackgroundColor:
                                      colorScheme.secondary,
                                  // borderRadius: 10.0,
                                  textStyle: textTheme.button,
                                ),
                              ),
                            ),
                            applyButtonText: 'SELEZIONA',
                            resetButtonText: 'CANCELLA',
                            enableOnlySingleSelection: true,
                            height: 500,
                            listData: listCompany,
                            selectedListData: listSelectedCompany,
                            choiceChipLabel: (item) => item!.name,
                            validateSelectedItem: (list, val) =>
                                list!.contains(val),
                            onItemSearch: (company, query) {
                              return company.name
                                  .toLowerCase()
                                  .contains(query.toLowerCase());
                            },
                            onApplyButtonClick: (list) {
                              setState(() {
                                listSelectedCompany = List.from(list!);
                              });
                              Navigator.pop(context);
                            },
                          );

                          if (listSelectedCompany.isNotEmpty) {
                            companyNameSearchedController.text =
                                listSelectedCompany.first.name;
                            viewModel
                                .setCompanyName(listSelectedCompany.first.name);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleziona la tua azienda';
                          }
                          var index =
                              listCompany.indexWhere((x) => x.name == value);
                          if (index == -1) {
                            return 'Inserire la azienda valida';
                          }

                          return null;
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
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          hint: Text(
                            'Seleziona la sede e/o il dipartimento',
                            style: textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: colorSchemeExtension.textDisabled,
                            ),
                          ),
                          items: companySelected.listDepartment!
                              .map((e) => e.name)
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: textTheme.caption,
                              ),
                            );
                          }).toList(),
                          value: departmentName != '' ? departmentName : null,
                          onChanged: (value) {
                            if (value != null) {
                              viewModel.setDepartmentName(value);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Seleziona la sede e/o il dipartimento';
                            }
                            var index = companySelected.listDepartment!
                                .indexWhere((x) => x.name == value);
                            if (index == -1) {
                              return 'Inserire la sede e/o il dipartimento valida';
                            }
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
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 10.0,
                                left: 10.0,
                              ),
                              child: AutoSizeText(
                                'La tua azienda non partecipa?'.toUpperCase(),
                                style: textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
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
                    width: 165.0,
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
                      child: AutoSizeText(
                        'Prosegui'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: colorScheme.onSecondary,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: SizedBox(
                    width: 165.0,
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
                      child: AutoSizeText(
                        'Torna indietro'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: colorScheme.secondary,
                        ),
                        maxLines: 1,
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
