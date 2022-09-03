import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ConfirmChallengeDialog {
  final BuildContext context;
  final BorderRadius borderRadius;
  final String title;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final String confirmButton;
  final TextStyle? confirmButtonStyle;
  final String cancelButton;
  final TextStyle? cancelButtonStyle;

  ConfirmChallengeDialog({
    required this.context,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(10),
    ),
    this.contentStyle,
    this.titleStyle,
    this.confirmButtonStyle,
    this.cancelButtonStyle,
    required this.title,
    required this.confirmButton,
    required this.cancelButton,
  });

  Future<bool?> show() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        var colorScheme = Theme.of(context).colorScheme;
        var textTheme = Theme.of(context).textTheme;
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              insetPadding: const EdgeInsets.all(25),
              backgroundColor: colorScheme.primary,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 320.0,
                    maxWidth: 350.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/confirm_challenge.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Text(
                        'Iscriviti alla',
                        style: textTheme.bodyText1!.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      Text(
                        title,
                        style: textTheme.headline6!.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'di FIAB',
                        style: textTheme.subtitle1!.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 210.0,
                        height: 36.0,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              colorScheme.secondary,
                            ),
                          ),
                          child: Text(
                            confirmButton,
                            style: textTheme.button!.copyWith(
                              color: colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      SizedBox(
                        width: 210.0,
                        height: 36.0,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            cancelButton,
                            style: textTheme.button!.copyWith(
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
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

  List<Department> _getDepartment(
      Company? company, List<TextEditingController> listDepartmentController) {
    if (company == null) {
      return listDepartmentController
          .map(
            (element) => Department(id: const Uuid().v4(), name: element.text),
          )
          .toList();
    } else {
      List<Department> list = [];
      for (var index = 0; index < listDepartmentController.length; index++) {
        Department department = Department(
          id: '',
          name: listDepartmentController[index].text,
        );
        try {
          var element = company.listDepartment!.elementAt(index);
          department.id = element.id;
        } catch (e) {
          department.id = const Uuid().v4();
        }
        list.add(department);
      }
      return list;
    }
  }
}
