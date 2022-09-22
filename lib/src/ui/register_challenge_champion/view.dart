import 'package:auto_size_text/auto_size_text.dart';
import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterChallengChampionView extends StatefulWidget {
  const RegisterChallengChampionView({Key? key}) : super(key: key);

  @override
  State<RegisterChallengChampionView> createState() =>
      _RegisterChallengChampionViewState();
}

class _RegisterChallengChampionViewState
    extends State<RegisterChallengChampionView> {
  final formKey = GlobalKey<FormState>();
  final colorGrey = const Color.fromRGBO(239, 239, 239, 1);
  final aboutFiabUrl = 'https://www.fiabitalia.it/diventa-socio';

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final viewModel = Provider.of<ViewModel>(context);
    final companyName = viewModel.uiState.challengeRegistry.companyName;
    final isFiabMember = viewModel.uiState.challengeRegistry.isFiabMember;
    final fiabCardNumber = viewModel.uiState.challengeRegistry.fiabCardNumber;
    final company = viewModel.uiState.challengeRegistry.companyToAdd!;
    final companyCategory = company.category;
    final companyEmployeesNumber = company.employeesNumber;
    final companyEmployessNumberCategory = _getEmployeesNumberCategory(company);
    final companyHasMoreDepartment = company.hasMoreDepartment;
    final companyZipCode = company.zipCode;
    final companyAddress = company.address;
    final companyCity = company.city;
    final companyListDepartment = company.listDepartment ?? [];

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
          padding: EdgeInsets.only(
            top: 20.0 * scale,
            bottom: 30.0 * scale,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: Text(
                    'Registrazione azienda',
                    style: textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20 * scale,
                ),
                Container(
                  height: 185 * scale,
                  color: const Color.fromRGBO(249, 249, 249, 1),
                  padding: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                    top: 15.0 * scale,
                    bottom: 15.0 * scale,
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
                                width: 80.0 * scale,
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
                                width: 80.0 * scale,
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
                          width: 245.0 * scale,
                          height: 36.0 * scale,
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
                                SizedBox(
                                  width: 8.0 * scale,
                                ),
                                Icon(
                                  Icons.call_made_outlined,
                                  color: colorScheme.secondary,
                                  size: 20.0 * scale,
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
                SizedBox(
                  height: 30.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Vuoi iscrivere la tua azienda e diventare Champion?',
                          style: textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        WidgetSpan(
                          child: Container(
                            margin: const EdgeInsets.only(left: 4.0),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Icon(
                                    Icons.info,
                                    size: 15 * scale,
                                    color: colorSchemeExtension.info,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: TextFormField(
                    maxLength: 90,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    initialValue: companyName,
                    onChanged: (value) => viewModel.setCompanyToAddName(value),
                    decoration: InputDecoration(
                      labelText: 'Come si chiama la tua azienda? *',
                      labelStyle: textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: colorSchemeExtension.textDisabled,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserire nome della tua azienda';
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    hint: Text(
                      'In quale settore opera? *',
                      style: textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: colorSchemeExtension.textDisabled,
                      ),
                    ),
                    items: Company.categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: textTheme.caption,
                        ),
                      );
                    }).toList(),
                    value: companyCategory != '' ? companyCategory : null,
                    onChanged: (value) {
                      if (value != null) {
                        viewModel.setDepartmentName(value);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleziona in quale settore opera';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    initialValue: companyEmployeesNumber.toString(),
                    onChanged: (value) =>
                        viewModel.setCompanyToAddEmployeesNumber(value),
                    decoration: InputDecoration(
                      labelText: 'Numero di dipendenti *',
                      labelStyle: textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: colorSchemeExtension.textDisabled,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserire numero di dipendenti';
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0 * scale,
                ),
                Container(
                  color: colorGrey,
                  padding: EdgeInsets.symmetric(horizontal: 24.0 * scale),
                  height: 82 * scale,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'La tua azienda parteciperà al torneo delle',
                              style: textTheme.bodyText1!.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            WidgetSpan(
                              child: Container(
                                margin: const EdgeInsets.only(left: 4.0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Icon(
                                        Icons.info,
                                        size: 15 * scale,
                                        color: colorSchemeExtension.info,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        companyEmployessNumberCategory,
                        style: textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'La tua azienda ha: *',
                        style: textTheme.subtitle1,
                      ),
                      InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        onTap: viewModel.setCompanyToAddNoDepartment,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: !companyHasMoreDepartment,
                                onChanged: (value) =>
                                    viewModel.setCompanyToAddNoDepartment(),
                              ),
                              Expanded(
                                child: Text(
                                  'Una sola sede',
                                  style: textTheme.bodyText1,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        onTap: viewModel.setCompanyToAddHasDepartment,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: companyHasMoreDepartment,
                                onChanged: (value) =>
                                    viewModel.setCompanyToAddHasDepartment(),
                              ),
                              Expanded(
                                child: Text(
                                  'Più sedi o dipartimenti',
                                  style: textTheme.bodyText1,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30 * scale,
                ),
                if (companyHasMoreDepartment &&
                    companyListDepartment.isNotEmpty)
                  Container(
                    padding: EdgeInsets.only(
                      top: 20 * scale,
                      bottom: 39.0 * scale,
                      left: 24.0 * scale,
                      right: 24.0 * scale,
                    ),
                    color: colorGrey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Segnala sedi e/o dipartimenti',
                          style: textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Segnala le diverse sedi e/o dipartimenti solo se desideri consultare le classifiche della tua azienda divise per sede o dipartimento.',
                          style: textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorSchemeExtension.textSecondary,
                          ),
                          maxLines: 5,
                        ),
                        ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: companyListDepartment.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: 15.0 * scale),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText:
                                      'Sede e/o dipartimento ${index + 1}',
                                  suffixIcon: Material(
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (index > 1 &&
                                            index + 1 ==
                                                companyListDepartment.length)
                                          IconButton(
                                            splashRadius: 20 * scale,
                                            onPressed: () => viewModel
                                                .setCompanyToAddRemoveDepartment(
                                              index,
                                            ),
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: colorScheme.error,
                                              size: 20 * scale,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                // controller: controller,
                                initialValue: companyListDepartment[index].name,
                                onChanged: (value) => viewModel
                                    .setCompanyToAddDepartment(index, value),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire sede e/o dipartimento ${index + 1}';
                                  }

                                  return null;
                                },
                              ),
                            );
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30 * scale),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Aggiungi un’altra sede o dipartimento',
                                style: textTheme.bodyText2,
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    viewModel.setCompanyToAddAddDepartment(),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.transparent,
                                ),
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: colorScheme.secondary,
                                  size: 20 * scale,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 30.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: TextFormField(
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'CAP *',
                    ),
                    initialValue:
                        companyZipCode != 0 ? companyZipCode.toString() : null,
                    onChanged: (value) =>
                        viewModel.setCompanyToAddZipCode(value),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 5) {
                        return 'Inserire CAP di azienda';
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: TextFormField(
                    maxLength: 40,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Indirizzo *',
                    ),
                    initialValue: companyAddress,
                    onChanged: (value) =>
                        viewModel.setCompanyToAddAddress(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserire indirizzo di azienda';
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0 * scale,
                ),
                Container(
                  margin:
                      EdgeInsets.only(right: 24.0 * scale, left: 24.0 * scale),
                  child: TextFormField(
                    maxLength: 30,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Città *',
                    ),
                    initialValue: companyCity,
                    onChanged: (value) => viewModel.setCompanyToAddCity(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserire città di azienda';
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: Text(
                    '(*) Campi obbligatori',
                    style: textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0 * scale,
                ),
                Center(
                  child: SizedBox(
                    width: 165.0 * scale,
                    height: 36.0 * scale,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          viewModel.gotoChampionRegistrationData();
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
                          colorScheme.secondary,
                        ),
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
                SizedBox(
                  height: 20.0 * scale,
                ),
                Center(
                  child: SizedBox(
                    width: 165.0 * scale,
                    height: 36.0 * scale,
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
                SizedBox(
                  height: 30.0 * scale,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getEmployeesNumberCategory(Company company) {
    var category = company.employeesNumberCategory();
    switch (category) {
      case EmployeesNumberCategory.micro:
        return 'Micro Imprese';
      case EmployeesNumberCategory.small:
        return 'Piccole Imprese';
      case EmployeesNumberCategory.medium:
        return 'Medie Imprese';
      case EmployeesNumberCategory.large:
        return 'Grandi Imprese';
    }
  }
}
