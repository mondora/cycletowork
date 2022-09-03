import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class EditCompanyDialog {
  final BuildContext context;
  final BorderRadius borderRadius;
  final String title;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final String confirmButton;
  final TextStyle? confirmButtonStyle;
  final String cancelButton;
  final TextStyle? cancelButtonStyle;
  final Company? company;

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var categoryController = TextEditingController();
  var employeesNumberController = TextEditingController();
  var countryController = TextEditingController();
  var cityController = TextEditingController();
  var addressController = TextEditingController();
  var zipCodeController = TextEditingController();
  var listDepartmentController = <TextEditingController>[];

  Company? newCompany;

  EditCompanyDialog({
    required this.context,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(8.0),
    ),
    this.contentStyle,
    this.title = 'Inserire nuova azienda',
    this.titleStyle,
    this.confirmButton = 'AGGIUNGI',
    this.confirmButtonStyle,
    this.cancelButton = 'ANNULLA',
    this.cancelButtonStyle,
    this.company,
  }) {
    if (company != null) {
      newCompany = Company.fromCompany(company!);

      nameController.text = company!.name;
      categoryController.text = company!.category;
      employeesNumberController.text = company!.employeesNumber.toString();
      countryController.text = company!.country;
      cityController.text = company!.city;
      addressController.text = company!.address;
      zipCodeController.text = company!.zipCode.toString();
      listDepartmentController = <TextEditingController>[];
      if (company!.listDepartment != null &&
          company!.listDepartment!.isNotEmpty) {
        for (var element in company!.listDepartment!) {
          var textEditingController = TextEditingController();
          textEditingController.text = element.name;
          listDepartmentController.add(textEditingController);
        }
      }
    } else {
      countryController.text = 'ITALIA';
    }
  }

  Future<Company?> show() async {
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
                              "Dati generali di Azienda",
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
                                    return 'Inserire nome azienda';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                maxLength: 40,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: categoryController,
                                decoration: const InputDecoration(
                                  labelText: 'CATEGORIA',
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire categoria azienda';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textInputAction: TextInputAction.next,
                                controller: employeesNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'N° DIPENDENTI',
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire numero dipendenti di azienda';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "l'indirizzo di Azienda",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                maxLength: 40,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                readOnly: true,
                                controller: countryController,
                                decoration: const InputDecoration(
                                  labelText: 'NAZIONE',
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire nazione azienda';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                maxLength: 40,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: cityController,
                                decoration: const InputDecoration(
                                  labelText: 'CITTÀ',
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Inserire città azienda';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                maxLength: 40,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: addressController,
                                decoration: const InputDecoration(
                                  labelText: 'INDIRIZZO',
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Inserire l'indirizzo azienda";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: TextFormField(
                                maxLength: 5,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textInputAction: TextInputAction.next,
                                controller: zipCodeController,
                                decoration: const InputDecoration(
                                  labelText: 'CAP',
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 5) {
                                    return 'Inserire CAP di azienda';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "Dipartimenti di Azienda",
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
                                    primary: colorScheme.secondary,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      listDepartmentController.add(
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
                            if (listDepartmentController.isEmpty)
                              Container(
                                height: 115.0,
                                padding: const EdgeInsets.only(
                                  left: 34.0,
                                  right: 27.0,
                                ),
                                color: Colors.grey[200],
                                child: Center(
                                  child: Text(
                                    "Non hai ancora aggiungiato nessun' dipartimento",
                                    style: textTheme.headline5!.copyWith(
                                      color: colorSchemeExtension.textDisabled,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            if (listDepartmentController.isNotEmpty)
                              ListView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listDepartmentController.length,
                                itemBuilder: (context, index) {
                                  var departmentController =
                                      listDepartmentController[index];

                                  return Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: TextFormField(
                                      maxLength: 40,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      controller: departmentController,
                                      decoration: InputDecoration(
                                        labelText: 'DIPARTIMENTO',
                                        errorStyle: const TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                        suffixIcon: IconButton(
                                          iconSize: 30.0,
                                          splashRadius: 25.0,
                                          onPressed: () {
                                            setState(() {
                                              listDepartmentController
                                                  .removeAt(index);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Inserire dipartimento";
                                        }
                                        return null;
                                      },
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(
                              height: 30,
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
                                          String id;
                                          bool isVerified;
                                          String registerUserEmail;
                                          String registerUserUid;
                                          if (company == null) {
                                            isSame = false;
                                            id = const Uuid().v4();
                                            isVerified = true;
                                            registerUserEmail =
                                                AppData.user!.email;
                                            registerUserUid = AppData.user!.uid;
                                          } else {
                                            id = company!.id;
                                            isVerified = company!.isVerified;
                                            registerUserEmail =
                                                company!.registerUserEmail;
                                            registerUserUid =
                                                company!.registerUserUid;
                                          }
                                          var name = nameController.text;
                                          var category =
                                              categoryController.text;
                                          var employeesNumber =
                                              employeesNumberController.text;
                                          var country = countryController.text;
                                          var city = cityController.text;
                                          var address = addressController.text;
                                          var zipCode = zipCodeController.text;

                                          newCompany = Company(
                                            id: id,
                                            isVerified: isVerified,
                                            name: name,
                                            category: category,
                                            employeesNumber:
                                                int.parse(employeesNumber),
                                            country: country,
                                            city: city,
                                            address: address,
                                            zipCode: int.parse(zipCode),
                                            hasMoreDepartment:
                                                listDepartmentController
                                                    .isNotEmpty,
                                            listDepartment:
                                                listDepartmentController
                                                        .isNotEmpty
                                                    ? _getDepartment(company,
                                                        listDepartmentController)
                                                    : [],
                                            registerUserEmail:
                                                registerUserEmail,
                                            registerUserUid: registerUserUid,
                                          );
                                          if (company != null &&
                                              newCompany != null) {
                                            var newCompanyJson =
                                                newCompany!.toJson().toString();

                                            var companyJson =
                                                company!.toJson().toString();
                                            if (newCompanyJson != companyJson) {
                                              isSame = false;
                                            }
                                          }

                                          Navigator.of(context)
                                              .pop(isSame ? null : newCompany);
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
