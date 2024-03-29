import 'package:auto_size_text/auto_size_text.dart';
import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/privacy_policy/view.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterChallengCyclistDataView extends StatefulWidget {
  const RegisterChallengCyclistDataView({Key? key}) : super(key: key);

  @override
  State<RegisterChallengCyclistDataView> createState() =>
      _RegisterChallengCyclistDataViewState();
}

class _RegisterChallengCyclistDataViewState
    extends State<RegisterChallengCyclistDataView> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;
    final viewModel = Provider.of<ViewModel>(context);
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

    var colorScheme = Theme.of(context).colorScheme;
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var textTheme = Theme.of(context).textTheme;
    final color = colorScheme.brightness == Brightness.light
        ? colorScheme.secondary
        : colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 25.0,
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onBackground,
            size: 20,
          ),
          onPressed: () => viewModel.gotoCyclistRegistration(),
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
                    'Dati anagrafici',
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
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: TextFormField(
                    maxLength: 40,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    initialValue: name,
                    onChanged: (value) {
                      viewModel.setName(value);
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
                SizedBox(
                  height: 30.0 * scale,
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
                SizedBox(
                  height: 30.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
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
                      if (!value.contains('@') ||
                          !value.contains('.') ||
                          value.contains(' ')) {
                        return 'Inserire un email valido';
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
                SizedBox(
                  height: 30.0 * scale,
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
                SizedBox(
                  height: 30.0 * scale,
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
                SizedBox(
                  height: 30.0 * scale,
                ),
                if (listQuestion.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(
                      right: 24.0 * scale,
                      left: 24.0 * scale,
                      top: 30.0 * scale,
                    ),
                    child: ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listQuestion.length,
                      itemBuilder: (context, index) {
                        var question = listQuestion[index];
                        var answers = question.answers!;
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 25.0 * scale),
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
                                            activeColor: color,
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
                SizedBox(
                  height: 30.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 24.0 * scale,
                    right: 24.0 * scale,
                  ),
                  child: const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                ),
                SizedBox(
                  height: 40.0 * scale,
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 24.0 * scale,
                    left: 24.0 * scale,
                  ),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    onTap: () {
                      viewModel.setAcceptPrivacy(!acceptPrivacy);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            activeColor: color,
                            value: acceptPrivacy,
                            onChanged: (value) {
                              viewModel.setAcceptPrivacy(value);
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    style: textTheme.bodyText1!
                                        .copyWith(fontWeight: FontWeight.w400),
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
                SizedBox(
                  height: 20.0 * scale,
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
                      onPressed: acceptPrivacy && responsedQuestions
                          ? () {
                              if (formKey.currentState!.validate()) {
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
                SizedBox(
                  height: 20.0 * scale,
                ),
                Center(
                  child: SizedBox(
                    width: 165.0 * scale,
                    height: 36.0 * scale,
                    child: OutlinedButton(
                      onPressed: viewModel.gotoCyclistRegistration,
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

  _getCheckBoxValue(List<String> surveyResponseAnswers, String value) {
    return surveyResponseAnswers.isNotEmpty &&
        surveyResponseAnswers.any((element) => element == value);
  }

  _isAnswerSurveyResponseAnswers(SurveyResponse surveyResponse) {
    return surveyResponse.listAnswer
        .every((element) => element.answers.isNotEmpty);
  }
}
