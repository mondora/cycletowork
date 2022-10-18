import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';

class EditSurveyDialog {
  final BuildContext context;
  final BorderRadius borderRadius;
  final String title;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final String confirmButton;
  final TextStyle? confirmButtonStyle;
  final String cancelButton;
  final TextStyle? cancelButtonStyle;
  final Survey? survey;

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var listQuestionTagController = <TextEditingController>[];
  var listQuestionTitleController = <TextEditingController>[];
  List<List<TextEditingController>> listQuestionAnswerController = [[]];
  var isRequired = false;

  Survey? newSurvey;

  EditSurveyDialog({
    required this.context,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(8.0),
    ),
    this.contentStyle,
    this.title = 'Inserire nuovo sondaggio',
    this.titleStyle,
    this.confirmButton = 'AGGIUNGI',
    this.confirmButtonStyle,
    this.cancelButton = 'ANNULLA',
    this.cancelButtonStyle,
    this.survey,
  }) {
    if (survey != null) {
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
    }
  }

  Future<Survey?> show() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
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
                                decoration: const InputDecoration(
                                  labelText: 'NOME',
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire nome sondaggio';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: SwitchListTile(
                                title: const Text('È OBBLIGATORIO'),
                                onChanged: (value) {
                                  setState(() {
                                    isRequired = value;
                                  });
                                },
                                value: isRequired,
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
                                                onPressed: () {
                                                  setState(() {
                                                    listQuestionTagController
                                                        .removeAt(index);
                                                    listQuestionTitleController
                                                        .removeAt(index);
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
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
                                            decoration: const InputDecoration(
                                              labelText: 'TAG',
                                              errorStyle: TextStyle(
                                                color: Colors.redAccent,
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
                                            decoration: const InputDecoration(
                                              labelText: 'TITOLO',
                                              errorStyle: TextStyle(
                                                color: Colors.redAccent,
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
                                          ListView.builder(
                                            physics: const ScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                QuestionType.values.length,
                                            itemBuilder: (context, index) {
                                              var questionType = QuestionType
                                                  .values
                                                  .elementAt(index);
                                              return RadioListTile<
                                                  QuestionType>(
                                                title: Text(
                                                    _getQuestionTypeName(
                                                        questionType)),
                                                value: questionType,
                                                groupValue: QuestionType.text,
                                                onChanged:
                                                    (QuestionType? value) {
                                                  // setState(() {
                                                  //   _character = value;
                                                  // });
                                                },
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            height: 30,
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
                                        bottom: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          var isSame = true;
                                          // String id;
                                          if (survey == null) {
                                            isSame = false;
                                            // id = const Uuid().v4();
                                          } else {
                                            // id = survey!.id;
                                          }
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

                                          Navigator.of(context)
                                              .pop(isSame ? null : newSurvey);
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
