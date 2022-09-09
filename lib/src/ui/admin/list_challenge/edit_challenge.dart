import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class EditChallengeDialog {
  final BuildContext context;
  final BorderRadius borderRadius;
  final String title;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final String confirmButton;
  final TextStyle? confirmButtonStyle;
  final String cancelButton;
  final TextStyle? cancelButtonStyle;
  final Challenge? challenge;

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var dataStartController = TextEditingController();
  var dateController = TextEditingController();
  var listQuestionTagController = <TextEditingController>[];
  var listQuestionTitleController = <TextEditingController>[];
  var listQuestionType = <QuestionType>[];
  List<List<TextEditingController>> listQuestionAnswerController = [[]];
  var fiabEdition = false;
  var requiredSurvey = false;
  var requiredCompany = false;
  var requiredNameLastName = false;
  var requiredWorkemail = false;
  var requiredWorkemailVerification = false;
  var requiredWorkAddress = false;

  var isRequired = false;

  Challenge? newChallenge;

  EditChallengeDialog({
    required this.context,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(8.0),
    ),
    this.contentStyle,
    this.title = 'Inserire nuovo challenge',
    this.titleStyle,
    this.confirmButton = 'AGGIUNGI',
    this.confirmButtonStyle,
    this.cancelButton = 'ANNULLA',
    this.cancelButtonStyle,
    this.challenge,
  }) {
    if (challenge != null) {
      // newCompany = Company.fromCompany(company!);

      // nameController.text = company!.name;
      // categoryController.text = company!.category;
      // employeesNumberController.text = company!.employeesNumber.toString();
      // countryController.text = company!.country;
      // cityController.text = company!.city;
      // addressController.text = company!.address;
      // zipCodeController.text = company!.zipCode.toString();
      // listDepartmentController = <TextEditingController>[];
      // if (company!.listDepartment != null &&
      //     company!.listDepartment!.isNotEmpty) {
      //   for (var element in company!.listDepartment!) {
      //     var textEditingController = TextEditingController();
      //     textEditingController.text = element.name;
      //     listDepartmentController.add(textEditingController);
      //   }
      // }
    } else {
      listQuestionTagController.add(
        TextEditingController(),
      );

      listQuestionTitleController.add(
        TextEditingController(),
      );

      listQuestionType.add(QuestionType.text);

      listQuestionAnswerController[0].addAll([]);
    }
  }

  Future<Challenge?> show() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        final Locale appLocale = Localizations.localeOf(context);
        final formatterDate = DateFormat(
          'dd MMMM yyyy, HH:mm',
          appLocale.languageCode,
        );
        final colorSchemeExtension =
            Theme.of(context).extension<ColorSchemeExtension>()!;
        var colorScheme = Theme.of(context).colorScheme;
        var textTheme = Theme.of(context).textTheme;
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900.0,
                  ),
                  child: Form(
                    key: formKey,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Dati generali",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                maxLength: 45,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: 'NOME',
                                  errorStyle: TextStyle(
                                    color: colorScheme.error,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire nome di challenge';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                readOnly: true,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: dateController,
                                decoration: InputDecoration(
                                  labelText: 'DATE INIZIA E FINE',
                                  errorStyle: TextStyle(
                                    color: colorScheme.error,
                                  ),
                                  prefixIcon: const Icon(Icons.calendar_today),
                                ),
                                onTap: () async {
                                  var dateNow = DateTime.now();
                                  var date = await showDateRangePicker(
                                    context: context,
                                    useRootNavigator: false,
                                    firstDate: dateNow.add(
                                      const Duration(days: 1),
                                    ),
                                    lastDate: dateNow.add(
                                      const Duration(days: 365),
                                    ),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: colorScheme.copyWith(
                                            onPrimary: colorScheme.onBackground,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (date != null) {
                                    dateController.text =
                                        '${formatterDate.format(date.start)} - ${formatterDate.format(date.end)}';
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: SwitchListTile(
                                title: const Text('È EDIZIONE FIAB?'),
                                onChanged: (value) {
                                  setState(() {
                                    fiabEdition = value;
                                  });
                                },
                                value: fiabEdition,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: SwitchListTile(
                                title: const Text('È OBBLIGATORIO SONDAGGIO?'),
                                onChanged: (value) {
                                  setState(() {
                                    requiredSurvey = value;
                                  });
                                },
                                value: requiredSurvey,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: SwitchListTile(
                                title: const Text(
                                    'È OBBLIGATORIO INSERIRE NOME E COGNOME?'),
                                onChanged: (value) {
                                  setState(() {
                                    requiredNameLastName = value;
                                  });
                                },
                                value: requiredNameLastName,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: SwitchListTile(
                                title: const Text(
                                    'È OBBLIGATORIO SELEZIONARE AZIENDA?'),
                                onChanged: (value) {
                                  setState(() {
                                    requiredCompany = value;
                                    if (!value) {
                                      requiredWorkemail = false;
                                      requiredWorkemailVerification = false;
                                      requiredWorkAddress = false;
                                    }
                                  });
                                },
                                value: requiredCompany,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: SwitchListTile(
                                title: const Text(
                                    'È OBBLIGATORIO INSERIRE EMAIL AZIENDALE?'),
                                onChanged: requiredCompany
                                    ? (value) {
                                        setState(() {
                                          requiredWorkemail = value;
                                          if (!value) {
                                            requiredWorkemailVerification =
                                                false;
                                          }
                                        });
                                      }
                                    : null,
                                value: requiredWorkemail,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: SwitchListTile(
                                title: const Text(
                                    'È OBBLIGATORIO VERIFICA EMAIL AZIENDALE?'),
                                onChanged: requiredCompany && requiredWorkemail
                                    ? (value) {
                                        setState(() {
                                          requiredWorkemailVerification = value;
                                        });
                                      }
                                    : null,
                                value: requiredWorkemailVerification,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: SwitchListTile(
                                title: const Text(
                                    'È OBBLIGATORIO INSERIRE INDIRIZZO AZIENDALE?'),
                                onChanged: requiredCompany
                                    ? (value) {
                                        setState(() {
                                          requiredWorkAddress = value;
                                        });
                                      }
                                    : null,
                                value: requiredWorkAddress,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "Domande",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(16.0),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      listQuestionTagController.add(
                                        TextEditingController(),
                                      );

                                      listQuestionTitleController.add(
                                        TextEditingController(),
                                      );

                                      listQuestionType.add(QuestionType.text);

                                      listQuestionAnswerController.add([]);
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.add,
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        'Aggiungi',
                                        style: textTheme.caption!.copyWith(
                                          color: colorScheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (listQuestionTagController.isEmpty)
                              Container(
                                height: 115.0,
                                padding: const EdgeInsets.only(
                                  left: 34.0,
                                  right: 27.0,
                                ),
                                color: Colors.grey[200],
                                child: Center(
                                  child: Text(
                                    "Non hai ancora aggiungiato nessun domanda",
                                    style: textTheme.headline5!.copyWith(
                                      color: colorSchemeExtension.textDisabled,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            if (listQuestionTagController.isNotEmpty)
                              ListView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listQuestionTagController.length,
                                itemBuilder: (context, index) {
                                  var questionTagController =
                                      listQuestionTagController[index];
                                  questionTagController.text =
                                      'TAG#${index + 1}';
                                  var questionTitleController =
                                      listQuestionTitleController[index];

                                  var questionType = listQuestionType[index];
                                  return Card(
                                    color: Colors.grey[50],
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                iconSize: 30.0,
                                                splashRadius: 25.0,
                                                color: colorScheme.error,
                                                onPressed: index > 0
                                                    ? () {
                                                        setState(() {
                                                          listQuestionTagController
                                                              .removeAt(index);
                                                          listQuestionTitleController
                                                              .removeAt(index);

                                                          listQuestionType
                                                              .removeAt(index);

                                                          listQuestionAnswerController
                                                              .removeAt(index);
                                                        });
                                                      }
                                                    : null,
                                                icon: const Icon(
                                                  Icons.delete,
                                                ),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: questionTagController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              labelText: 'TAG',
                                              errorStyle: TextStyle(
                                                color: colorScheme.error,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Inserire tag";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormField(
                                            maxLength: 120,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: questionTitleController,
                                            decoration: InputDecoration(
                                              labelText: 'TITOLO',
                                              errorStyle: TextStyle(
                                                color: colorScheme.error,
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Inserire titolo";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          SwitchListTile(
                                            title: const Text('È OBBLIGATORIO'),
                                            onChanged: (value) {
                                              setState(() {
                                                isRequired = value;
                                              });
                                            },
                                            value: isRequired,
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          const Text(
                                            'Tipo domanda',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          ListView.builder(
                                            physics: const ScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                QuestionType.values.length,
                                            itemBuilder:
                                                (context, indexQuestionType) {
                                              var questionTypeThis =
                                                  QuestionType.values.elementAt(
                                                      indexQuestionType);
                                              return RadioListTile<
                                                  QuestionType>(
                                                title: Text(
                                                    _getQuestionTypeName(
                                                        questionTypeThis)),
                                                value: questionTypeThis,
                                                groupValue: questionType,
                                                onChanged:
                                                    (QuestionType? value) {
                                                  setState(() {
                                                    listQuestionType[index] =
                                                        value!;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            width: 450,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              textInputAction:
                                                  TextInputAction.next,
                                              textAlign: TextAlign.center,
                                              // readOnly: true,
                                              // controller: maxAnswerController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    'MASSIME RISPOSTE (0 significa senza limite)',
                                                errorStyle: TextStyle(
                                                  color: colorScheme.error,
                                                ),
                                                prefixIcon: IconButton(
                                                  onPressed: () {},
                                                  splashRadius: 20.0,
                                                  icon: const Icon(
                                                    Icons.remove_circle_outline,
                                                  ),
                                                ),
                                                suffixIcon: IconButton(
                                                  onPressed: () {},
                                                  splashRadius: 20.0,
                                                  icon: const Icon(
                                                    Icons.add_circle_outline,
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Inserire massime risposte';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // setState(() {
                                                  //   listQuestionTagController.add(
                                                  //     TextEditingController(),
                                                  //   );

                                                  //   listQuestionTitleController.add(
                                                  //     TextEditingController(),
                                                  //   );

                                                  //   listQuestionType.add(QuestionType.text);
                                                  // });
                                                  setState(() {
                                                    listQuestionAnswerController[
                                                            index]
                                                        .addAll([
                                                      TextEditingController()
                                                    ]);
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.add,
                                                    ),
                                                    const SizedBox(
                                                      width: 8.0,
                                                    ),
                                                    Text(
                                                      'Aggiungi risposte',
                                                      style: textTheme.caption!
                                                          .copyWith(
                                                        color: colorScheme
                                                            .secondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 52,
                                    margin: const EdgeInsets.only(
                                        top: 20,
                                        left: 20,
                                        right: 20,
                                        bottom: 20),
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('ANNULLA'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 52,
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      left: 20,
                                      right: 20,
                                      bottom: 20,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          // var isSame = true;
                                          // String id;
                                          if (challenge == null) {
                                            // isSame = false;
                                            // id = const Uuid().v4();
                                          } else {
                                            // id = challenge!.id;
                                          }
                                          // Survey newSurvey = Survey(
                                          //   id: '7c945c12-01ee-4fd9-8c1a-972a3a3c2598',
                                          //   name:
                                          //       'MILANO BIKE CHALLENGE 2022 di FIAB',
                                          //   title:
                                          //       'Se lo desideri puoi compilare un breve sondaggio che ci aiuterà a capire qualcosa in più su di te e sul tuo stile ciclistico',
                                          //   listQuestion: <Question>[
                                          //     Question(
                                          //       id: 'eea87c65-fe15-4f87-be85-001bf1e793bb',
                                          //       tag: 'Q1',
                                          //       title: 'Genere',
                                          //       type: QuestionType.radio,
                                          //       answers: [
                                          //         'Maschile',
                                          //         'Femminile',
                                          //         'Non binario',
                                          //         'Preferisco non indicare'
                                          //       ],
                                          //       required: false,
                                          //       maxAnswer: 1,
                                          //     ),
                                          //     Question(
                                          //       id: '7bbb0e69-1b21-4880-9bfd-6edc2e9aaa06',
                                          //       tag: 'Q2',
                                          //       title: 'Età:',
                                          //       type: QuestionType.selection,
                                          //       answers: [
                                          //         '18-22',
                                          //         '22-44',
                                          //         '45-55',
                                          //         '56-100',
                                          //       ],
                                          //       required: true,
                                          //       maxAnswer: 1,
                                          //     ),
                                          //     Question(
                                          //       id: '1ae1fb11-79c6-47d2-87cd-8fcc672024fa',
                                          //       tag: 'Q3',
                                          //       title:
                                          //           'Come vai al lavoro abitualmente (abitudine prevalente)?',
                                          //       type: QuestionType.radio,
                                          //       answers: [
                                          //         'A piedi',
                                          //         'Con i mezzi pubblici',
                                          //         'Con l’auto',
                                          //         'In bici',
                                          //         'In bici + treno',
                                          //       ],
                                          //       required: false,
                                          //       maxAnswer: 1,
                                          //     ),
                                          //     Question(
                                          //       id: '6c356e80-866e-452f-bc51-261f9ad9e95e',
                                          //       tag: 'Q4',
                                          //       title:
                                          //           "Cosa ti trattiene dall'usare più spesso la bici per andare al lavoro?",
                                          //       type: QuestionType.multiOther,
                                          //       answers: [
                                          //         'Non possiedo una bicicletta',
                                          //         'Non mi sento ancora a mio agio ad andare in bici per le strade della città',
                                          //         'Non ho tempo per pedalare/ ho bisogno di fare in fretta per arrivare al lavoro',
                                          //         'La mia bici deve essere riparata, ha bisogno di manutenzione',
                                          //         'Non conosco ancora un percorso sicuro e tranquillo',
                                          //         'Non riesco a cambiarmi i vestiti / avere i servizi adeguati in sede al lavoro',
                                          //       ],
                                          //       required: false,
                                          //       maxAnswer: 0,
                                          //     ),
                                          //     Question(
                                          //       id: '69180748-5faf-43be-9ac5-3a29b1429bac',
                                          //       tag: 'Q5',
                                          //       title:
                                          //           "Quali sono i principali benefici che ti aspetti dall'andare in bici?",
                                          //       type: QuestionType.multi,
                                          //       answers: [
                                          //         'Essere più in forma',
                                          //         'Risparmiare denaro',
                                          //         'Essere più veloce / guadagnare tempo',
                                          //         "Godermi il paesaggio e stare all'aperto",
                                          //         'Stare con la famiglia o gli amici',
                                          //         'Stile di vita sostenibile',
                                          //         'Altro'
                                          //       ],
                                          //       required: false,
                                          //       maxAnswer: 3,
                                          //     ),
                                          //   ],
                                          //   required: false,
                                          // );

                                          // var newChallenge = Challenge(
                                          //   id: const Uuid().v4(),
                                          //   name: 'MILANO BIKE CHALLENGE 2022',
                                          //   startTime: DateTime(2022, 8, 29)
                                          //       .millisecondsSinceEpoch,
                                          //   stopTime: DateTime(2022, 8, 30)
                                          //       .millisecondsSinceEpoch,
                                          //   fiabEdition: true,
                                          //   requiredSurvey: false,
                                          //   requiredCompany: true,
                                          //   requiredNameLastName: true,
                                          //   requiredWorkemail: true,
                                          //   requiredWorkemailVerification: true,
                                          //   requiredWorkAddress: true,
                                          //   listQuestion: [
                                          //     Question(
                                          //       id: const Uuid().v4(),
                                          //       tag: 'CQ1',
                                          //       title:
                                          //           'Quante volte hai pedalato negli ultimi 12 mesi?',
                                          //       type: QuestionType.radio,
                                          //       required: true,
                                          //       maxAnswer: 1,
                                          //       answers: [
                                          //         'Mai',
                                          //         '1-3 volte al mese',
                                          //         '1 volta a settimana',
                                          //         '2-3 volte a settimana',
                                          //         '4 o più giorni a setitmana',
                                          //       ],
                                          //     ),
                                          //   ],
                                          //   survey: newSurvey,
                                          //   language: 'it',
                                          //   published: false,
                                          // );

                                          // isSame = false;
                                          // var name = nameController.text;
                                          // var category =
                                          //     categoryController.text;
                                          // var employeesNumber =
                                          //     employeesNumberController.text;
                                          // var country = countryController.text;
                                          // var city = cityController.text;
                                          // var address = addressController.text;
                                          // var zipCode = zipCodeController.text;

                                          // newCompany = Company(
                                          //   id: id,
                                          //   name: name,
                                          //   category: category,
                                          //   employeesNumber:
                                          //       int.parse(employeesNumber),
                                          //   country: country,
                                          //   city: city,
                                          //   address: address,
                                          //   zipCode: int.parse(zipCode),
                                          //   hasMoreDepartment:
                                          //       listDepartmentController
                                          //           .isNotEmpty,
                                          //   listDepartment:
                                          //       listDepartmentController
                                          //               .isNotEmpty
                                          //           ? _getDepartment(company,
                                          //               listDepartmentController)
                                          //           : [],
                                          // );
                                          // if (company != null &&
                                          //     newCompany != null) {
                                          //   var newCompanyJson =
                                          //       newCompany!.toJson().toString();

                                          //   var companyJson =
                                          //       company!.toJson().toString();
                                          //   if (newCompanyJson != companyJson) {
                                          //     isSame = false;
                                          //   }
                                          // }

                                          Navigator.of(context).pop(null);
                                        }
                                      },
                                      child: const Text("SALVA"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getQuestionTypeName(QuestionType questionType) {
    switch (questionType) {
      case QuestionType.text:
        return 'Testo';
      case QuestionType.number:
        return 'Numero';
      case QuestionType.email:
        return 'Email';
      case QuestionType.multi:
        return 'Multiplica risposta';
      case QuestionType.multiOther:
        return 'Multiplica risposta con altro';
      case QuestionType.radio:
        return 'Singola risposta';
      case QuestionType.radioOther:
        return 'Singola risposta con altro';
      case QuestionType.selection:
        return 'Singola risposta da selezionare';
    }
  }

  // List<Department> _getDepartment(
  //     Company? company, List<TextEditingController> listDepartmentController) {
  //   if (company == null) {
  //     return listDepartmentController
  //         .map(
  //           (element) => Department(id: const Uuid().v4(), name: element.text),
  //         )
  //         .toList();
  //   } else {
  //     List<Department> list = [];
  //     for (var index = 0; index < listDepartmentController.length; index++) {
  //       Department department = Department(
  //         id: '',
  //         name: listDepartmentController[index].text,
  //       );
  //       try {
  //         var element = company.listDepartment!.elementAt(index);
  //         department.id = element.id;
  //       } catch (e) {
  //         department.id = const Uuid().v4();
  //       }
  //       list.add(department);
  //     }
  //     return list;
  //   }
  // }
}
