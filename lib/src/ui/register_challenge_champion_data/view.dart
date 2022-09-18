import 'package:auto_size_text/auto_size_text.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/privacy_policy/view.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterChallengCompanyDataView extends StatefulWidget {
  const RegisterChallengCompanyDataView({Key? key}) : super(key: key);

  @override
  State<RegisterChallengCompanyDataView> createState() =>
      _RegisterChallengCompanyDataViewState();
}

class _RegisterChallengCompanyDataViewState
    extends State<RegisterChallengCompanyDataView> {
  final formKey = GlobalKey<FormState>();
  final otherRoleController = TextEditingController();
  final _mapKey = GlobalKey();
  // final privacyUrl = 'https://www.sataspes.net/android/sp-budget';
  var isOtherRole = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    final company = viewModel.uiState.challengeRegistry.companyToAdd!;
    final hasMoreDepartment = company.hasMoreDepartment;
    final listDepartment = company.listDepartment ?? [];
    final departmentName = viewModel.uiState.challengeRegistry.departmentName;
    var acceptPrivacy = viewModel.uiState.challengeRegistry.acceptPrivacy;
    var listQuestion = viewModel.uiState.challenge!.listQuestion;
    var surveyResponse = viewModel.uiState.challengeRegistry.surveyResponse;
    var name = viewModel.uiState.challengeRegistry.name;
    var lastName = viewModel.uiState.challengeRegistry.lastName;
    var businessEmail = viewModel.uiState.challengeRegistry.businessEmail;
    var zipCode = viewModel.uiState.challengeRegistry.zipCode;
    var address = viewModel.uiState.challengeRegistry.address;
    var city = viewModel.uiState.challengeRegistry.city;
    var responsedQuestions = _isAnswerSurveyResponseAnswers(surveyResponse!);

    var role = viewModel.uiState.challengeRegistry.role;

    var otherString = 'Altro';
    var iAmMobilityManager = 'Sono il Mobility Manager';
    var iAmHumanResources = 'Faccio parte delle Human Resources';

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
          onPressed: () => viewModel.backToChampionRegistration(),
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
                    'Dati anagrafici',
                    style: textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (hasMoreDepartment && listDepartment.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(
                      right: 24.0,
                      left: 24.0,
                      top: 20.0,
                    ),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      hint: Text(
                        'A quale sede o dipartimento appartieni? *',
                        style: textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: colorSchemeExtension.textDisabled,
                        ),
                      ),
                      items:
                          listDepartment.map((e) => e.name).map((String value) {
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
                          return 'Seleziona in quale settore opera';
                        }
                        return null;
                      },
                    ),
                  ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                  ),
                  child: TextFormField(
                    maxLength: 40,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    initialValue: name,
                    onChanged: (value) => viewModel.setName(value),
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
                  height: 30.0,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                  ),
                  child: TextFormField(
                    maxLength: 40,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    initialValue: lastName,
                    onChanged: (value) => viewModel.setLastName(value),
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
                  margin: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                  ),
                  child: TextFormField(
                    maxLength: 40,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    initialValue: businessEmail,
                    onChanged: (value) => viewModel.setBusinessEmail(value),
                    decoration: InputDecoration(
                      labelText: 'Inserisci la tua email aziendale *',
                      labelStyle: textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: colorSchemeExtension.textDisabled,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserire email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Inserire un email valido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 38.0,
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
                        'Il tuo ruolo in azienda:',
                        style: textTheme.subtitle1,
                      ),
                      InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        onTap: () {
                          if (role != iAmMobilityManager) {
                            setState(() {
                              isOtherRole = false;
                            });
                            viewModel.setRole(iAmMobilityManager);
                          } else {
                            viewModel.setRole('');
                            otherRoleController.text = '';
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value:
                                    role == iAmMobilityManager && !isOtherRole,
                                onChanged: (value) {
                                  if (value!) {
                                    setState(() {
                                      isOtherRole = false;
                                    });
                                    viewModel.setRole(iAmMobilityManager);
                                  } else {
                                    viewModel.setRole('');
                                    otherRoleController.text = '';
                                  }
                                },
                              ),
                              Expanded(
                                child: Text(
                                  iAmMobilityManager,
                                  style: textTheme.bodyText1,
                                  overflow: TextOverflow.ellipsis,
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
                        onTap: () {
                          if (role != iAmHumanResources) {
                            setState(() {
                              isOtherRole = false;
                            });
                            viewModel.setRole(iAmHumanResources);
                          } else {
                            viewModel.setRole('');
                            otherRoleController.text = '';
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value:
                                    role == iAmHumanResources && !isOtherRole,
                                onChanged: (value) {
                                  if (value!) {
                                    setState(() {
                                      isOtherRole = false;
                                    });
                                    viewModel.setRole(iAmHumanResources);
                                  } else {
                                    viewModel.setRole('');
                                    otherRoleController.text = '';
                                  }
                                },
                              ),
                              Expanded(
                                child: Text(
                                  iAmHumanResources,
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
                        onTap: () {
                          setState(() {
                            isOtherRole = !isOtherRole;
                          });
                          if (isOtherRole) {
                            viewModel.setRole('');
                            otherRoleController.text = '';
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: isOtherRole,
                                onChanged: (value) {
                                  setState(() {
                                    isOtherRole = value!;
                                  });
                                  if (value!) {
                                    viewModel.setRole('');
                                    otherRoleController.text = '';
                                  }
                                },
                              ),
                              Expanded(
                                child: Text(
                                  otherString,
                                  style: textTheme.bodyText1,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      if (isOtherRole)
                        Container(
                          margin: const EdgeInsets.only(
                            right: 10.0,
                            left: 10.0,
                            top: 10.0,
                          ),
                          child: TextFormField(
                            key: _mapKey,
                            readOnly: !isOtherRole,
                            maxLength: 40,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            controller: otherRoleController,
                            decoration: InputDecoration(
                              labelText: 'Specifica il tuo ruolo',
                              labelStyle: textTheme.bodyText1!.copyWith(
                                fontWeight: FontWeight.w400,
                                color: colorSchemeExtension.textDisabled,
                              ),
                            ),
                            validator: (value) {
                              if ((value == null || value.isEmpty) &&
                                  isOtherRole) {
                                return 'Inserire il tuo ruolo';
                              }

                              return null;
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                    initialValue: zipCode,
                    onChanged: (value) => viewModel.setZipCode(value),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 5) {
                        return 'Inserire CAP';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 30.0,
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
                    initialValue: address,
                    onChanged: (value) => viewModel.setAddress(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserire indirizzo';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 30.0,
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
                    initialValue: city,
                    onChanged: (value) => viewModel.setCity(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserire città';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                if (listQuestion.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(
                      right: 24.0,
                      left: 24.0,
                      top: 30.0,
                    ),
                    child: ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listQuestion.length,
                      itemBuilder: (context, index) {
                        var question = listQuestion[index];
                        var answers = question.answers!;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: question.title,
                                      style: textTheme.subtitle1,
                                    ),
                                    TextSpan(
                                      text: question.maxAnswer > 1
                                          ? ' Selezionane fino a ${question.maxAnswer}.'
                                          : question.maxAnswer == 0
                                              ? ' Seleziona tutte le voci che desideri.'
                                              : '',
                                      style: textTheme.subtitle1,
                                    ),
                                    TextSpan(
                                      text: question.required ? '*' : '',
                                      style: textTheme.subtitle1,
                                    ),
                                  ],
                                ),
                              ),
                              if (question.type == QuestionType.radio ||
                                  question.type == QuestionType.radioOther ||
                                  question.type == QuestionType.multi ||
                                  question.type == QuestionType.multiOther)
                                for (var answer in answers)
                                  InkWell(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    onTap: () =>
                                        viewModel.setAnswer(index, answer),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4.5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: _getCheckBoxValue(
                                              surveyResponse
                                                  .listAnswer[index].answers,
                                              answer,
                                            ),
                                            onChanged: (value) => viewModel
                                                .setAnswer(index, answer),
                                          ),
                                          Expanded(
                                            child: Text(
                                              answer,
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
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 24.0, left: 24.0),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    onTap: () => viewModel.setAcceptPrivacy(!acceptPrivacy),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: acceptPrivacy,
                            onChanged: (value) =>
                                viewModel.setAcceptPrivacy(value),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    style: textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                    text:
                                        'Autorizzo al trattamento dei dati e confermo di aver letto ',
                                  ),
                                  TextSpan(
                                    style: textTheme.bodyText1!.copyWith(
                                      decoration: TextDecoration.underline,
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    text: 'l’informativa sulla privacy. *',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PrivacyPolicyView(),
                                          ),
                                        );
                                        // final url = Uri.parse(privacyUrl);
                                        // if (await canLaunchUrl(url)) {
                                        //   await launchUrl(
                                        //     url,
                                        //   );
                                        // }
                                      },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
                    width: 165.0,
                    height: 36.0,
                    child: ElevatedButton(
                      onPressed: acceptPrivacy && responsedQuestions
                          ? () {
                              if (formKey.currentState!.validate()) {
                                if (isOtherRole) {
                                  viewModel.uiState.challengeRegistry.role =
                                      otherRoleController.text;
                                }
                                viewModel.gotoEmailVerifiy();
                              }
                            }
                          : null,
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          acceptPrivacy && responsedQuestions
                              ? colorScheme.secondary
                              : colorSchemeExtension.textDisabled
                                  .withOpacity(0.12),
                        ),
                      ),
                      child: AutoSizeText(
                        'Prosegui'.toUpperCase(),
                        style: textTheme.button!.copyWith(
                          color: acceptPrivacy && responsedQuestions
                              ? colorScheme.onSecondary
                              : colorSchemeExtension.textDisabled,
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
                      onPressed: viewModel.backToChampionRegistration,
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

  _getCheckBoxValue(List<String> surveyResponseAnswers, String value) {
    return surveyResponseAnswers.isNotEmpty &&
        surveyResponseAnswers.any((element) => element == value);
  }

  _isAnswerSurveyResponseAnswers(SurveyResponse surveyResponse) {
    return surveyResponse.listAnswer
        .every((element) => element.answers.isNotEmpty);
  }
}
