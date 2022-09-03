import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    var companyName = viewModel.uiState.challengeRegistry.companyName;
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
                    'Registrazione azienda',
                    style: textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
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
                                    size: 15,
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
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
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
                Container(
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                  ),
                  child: SearchField(
                    suggestionState: Suggestion.expand,
                    suggestionAction: SuggestionAction.next,
                    maxSuggestionsInViewPort: 10,
                    itemHeight: 50,
                    textInputAction: TextInputAction.next,
                    suggestions: Company.categories
                        .map((e) => SearchFieldListItem(e))
                        .toList(),
                    initialValue: companyCategory != ''
                        ? SearchFieldListItem(companyCategory)
                        : null,
                    onSuggestionTap: (value) {
                      viewModel.setCompanyToAddCategory(value.searchKey);
                    },
                    searchInputDecoration: InputDecoration(
                      labelText: 'In quale settore opera? *',
                      suffixIcon: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: colorSchemeExtension.textSecondary,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleziona in quale settore opera';
                      }

                      if (!Company.categories.contains(value)) {
                        return 'Inserire settore valida';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
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
                // Container(
                //   margin: const EdgeInsets.only(
                //     right: 24.0,
                //     left: 24.0,
                //   ),
                //   height: 60,
                //   child: Row(
                //     mainAxisSize: MainAxisSize.max,
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       Flexible(
                //         child: TextFormField(
                //           // maxLength: 90,
                //           keyboardType: TextInputType.number,
                //           inputFormatters: [
                //             FilteringTextInputFormatter.digitsOnly
                //           ],
                //           textInputAction: TextInputAction.next,
                //           // controller: listOtherController[index],
                //           decoration: InputDecoration(
                //             labelText: 'Numero di dipendenti *',
                //             labelStyle: textTheme.bodyText1!.copyWith(
                //               fontWeight: FontWeight.w400,
                //               color: colorSchemeExtension.textDisabled,
                //             ),
                //           ),
                //           validator: (value) {
                //             if (value == null || value.isEmpty) {
                //               return 'Inserire numero di dipendenti';
                //             }

                //             return null;
                //           },
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 24,
                //       ),
                //       SizedBox(
                //         width: 100.0,
                //         height: 36.0,
                //         child: ElevatedButton(
                //           onPressed: () {},
                //           style: ButtonStyle(
                //             shape: MaterialStateProperty.all<
                //                 RoundedRectangleBorder>(
                //               RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(4.0),
                //               ),
                //             ),
                //             backgroundColor: MaterialStateProperty.all<Color>(
                //               colorScheme.secondary,
                //             ),
                //           ),
                //           child: Text(
                //             'Verifica'.toUpperCase(),
                //             style: textTheme.button!.copyWith(
                //               color: colorScheme.onSecondary,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  color: colorGrey,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  height: 82,
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
                                        size: 15,
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
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
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
                const SizedBox(
                  height: 30,
                ),
                if (companyHasMoreDepartment &&
                    companyListDepartment.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 39.0,
                      left: 24.0,
                      right: 24.0,
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
                              margin: const EdgeInsets.only(top: 15.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Sede e/o dipartimento ',
                                  suffixIcon: Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                      splashRadius: 20,
                                      onPressed: () {
                                        if (index + 1 <
                                            companyListDepartment.length) {
                                          viewModel
                                              .setCompanyToAddRemoveDepartment(
                                                  index);
                                        } else {
                                          viewModel
                                              .setCompanyToAddAddDepartment();
                                        }
                                      },
                                      icon: index + 1 <
                                              companyListDepartment.length
                                          ? Icon(
                                              Icons.delete_outline,
                                              color: colorScheme.error,
                                            )
                                          : Icon(
                                              Icons.add_circle_outline,
                                              color: colorScheme.secondary,
                                            ),
                                    ),
                                  ),
                                ),
                                // controller: controller,
                                initialValue: companyListDepartment[index].name,
                                onChanged: (value) => viewModel
                                    .setCompanyToAddDepartment(index, value),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire sede e/o dipartimento ';
                                  }

                                  return null;
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 24.0, left: 24.0),
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
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 24.0, left: 24.0),
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
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 24.0, left: 24.0),
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
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                  ),
                  child: Text(
                    '(*) Campi obbligatori',
                    style: textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: SizedBox(
                    width: 155.0,
                    height: 36.0,
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
