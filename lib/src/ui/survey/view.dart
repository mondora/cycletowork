import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/ui/register_challenge/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurveyView extends StatefulWidget {
  const SurveyView({Key? key}) : super(key: key);

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ViewModel>(context);
    final surveyResponse = viewModel.uiState.surveyResponse!;
    var survey = viewModel.uiState.challenge!.survey;

    final List<TextEditingController> listOtherController = [];
    for (var i = 0; i < survey.listQuestion.length; i++) {
      var controller = TextEditingController();
      listOtherController.add(controller);
    }

    var saveButtonIsEnabled = _isSaveEnabled(survey, surveyResponse);
    var otherString = 'Altro';
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 25.0,
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onBackground,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 26.0, right: 24.0),
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'Sondaggio',
            style: textTheme.headline6,
          ),
          ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: survey.listQuestion.length,
            itemBuilder: (context, index) {
              Question question = survey.listQuestion[index];
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
                      for (var answer in question.answers!)
                        InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          onTap: () {
                            setState(() {
                              _onChangedCheckBoxValue(
                                question,
                                surveyResponse.listAnswer[index],
                                answer,
                              );
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _getCheckBoxValue(
                                    surveyResponse.listAnswer[index].answers,
                                    answer,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _onChangedCheckBoxValue(
                                        question,
                                        surveyResponse.listAnswer[index],
                                        answer,
                                      );
                                    });
                                  },
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
                    if (question.type == QuestionType.radioOther ||
                        question.type == QuestionType.multiOther)
                      Column(
                        children: [
                          InkWell(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            onTap: () {
                              setState(() {
                                _onChangedCheckBoxValue(
                                  question,
                                  surveyResponse.listAnswer[index],
                                  otherString,
                                );
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _getCheckBoxValue(
                                      surveyResponse.listAnswer[index].answers,
                                      otherString,
                                    ),
                                    onChanged: (value) {
                                      _onChangedCheckBoxValue(
                                        question,
                                        surveyResponse.listAnswer[index],
                                        otherString,
                                      );
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
                          Container(
                            margin: const EdgeInsets.only(top: 9),
                            child: TextField(
                              maxLength: 90,
                              enabled: surveyResponse.listAnswer[index].answers
                                  .any((element) => element == otherString),
                              onChanged: (value) {
                                surveyResponse.listAnswer[index].moreAnswer =
                                    value;
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              controller: listOtherController[index],
                              decoration: const InputDecoration(
                                labelText: 'Specifica gli altri motivi:',
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (question.type == QuestionType.selection)
                      DropdownButton<String>(
                        isExpanded: true,
                        value: surveyResponse
                                    .listAnswer[index].answers.isNotEmpty &&
                                surveyResponse
                                        .listAnswer[index].answers.first !=
                                    ''
                            ? surveyResponse.listAnswer[index].answers.first
                            : null,
                        items: answers.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              surveyResponse.listAnswer[index].answers = [
                                value
                              ];
                            } else {
                              surveyResponse.listAnswer[index].answers = [];
                            }
                          });
                        },
                      )
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 40,
          ),
          Column(
            children: [
              SizedBox(
                width: 75,
                height: 36.0,
                child: ElevatedButton(
                  onPressed: saveButtonIsEnabled
                      ? () async {
                          _checkOtherAnswer(
                            survey,
                            surveyResponse,
                            otherString,
                          );
                          viewModel.saveSurveyResponse(surveyResponse);
                          // Navigator.pop(context);
                        }
                      : null,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    backgroundColor: saveButtonIsEnabled
                        ? MaterialStateProperty.all<Color>(
                            colorScheme.secondary,
                          )
                        : null,
                  ),
                  child: Text(
                    'SALVA',
                    style: textTheme.button!.copyWith(
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  _checkOtherAnswer(
    Survey survey,
    SurveyResponse surveyResponse,
    String otherString,
  ) {
    for (var index = 0; index < survey.listQuestion.length; index++) {
      var question = survey.listQuestion[index];
      var answer = surveyResponse.listAnswer[index];
      if (answer.moreAnswer.isNotEmpty &&
          (question.type == QuestionType.multiOther ||
              question.type == QuestionType.radioOther)) {
        if (!answer.answers.any((element) => element == otherString)) {
          answer.moreAnswer = '';
        }
      }
    }
  }

  _onChangedCheckBoxValue(
    Question question,
    Answer answer,
    String answerValue,
  ) {
    var indexWhere =
        answer.answers.indexWhere((element) => element == answerValue);
    if (indexWhere >= 0) {
      answer.answers.removeAt(indexWhere);
      return;
    }

    var maxAnswer = question.maxAnswer;

    if (maxAnswer > answer.answers.length) {
      answer.answers.add(answerValue);
    } else {
      if (indexWhere >= 0) {
        answer.answers.removeAt(indexWhere);
      } else {
        if (maxAnswer == 0) {
          answer.answers.add(answerValue);
        } else {
          answer.answers.removeLast();
          answer.answers.add(answerValue);
        }
      }
    }
  }

  _getCheckBoxValue(List<String> surveyResponseAnswers, String value) {
    return surveyResponseAnswers.isNotEmpty &&
        surveyResponseAnswers.any((element) => element == value);
  }

  _isSaveEnabled(Survey survey, SurveyResponse surveyResponse) {
    for (var index = 0; index < survey.listQuestion.length; index++) {
      var question = survey.listQuestion[index];
      var answer = surveyResponse.listAnswer[index];
      if (question.required && answer.answers.isEmpty) {
        return false;
      }
    }

    return true;
  }
}
