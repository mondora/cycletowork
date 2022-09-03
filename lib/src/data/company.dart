import 'dart:convert';

import 'package:flutter/material.dart';

enum EmployeesNumberCategory {
  micro,
  small,
  medium,
  large,
}

class Company {
  String id;
  String name;
  String category;
  int employeesNumber;
  String country;
  String city;
  String address;
  int zipCode;
  bool hasMoreDepartment;
  List<Department>? listDepartment;
  bool isVerified;
  String registerUserUid;
  String registerUserEmail;
  bool selected = false;

  Company({
    required this.id,
    required this.name,
    required this.category,
    required this.employeesNumber,
    required this.country,
    required this.city,
    required this.address,
    required this.zipCode,
    required this.hasMoreDepartment,
    required this.isVerified,
    required this.registerUserUid,
    required this.registerUserEmail,
    this.listDepartment,
  });

  factory Company.fromCompany(Company company) =>
      Company.fromMap(company.toJson());

  Company.fromEmpty()
      : id = '',
        name = '',
        category = '',
        employeesNumber = 1,
        country = '',
        city = '',
        address = '',
        zipCode = 0,
        hasMoreDepartment = false,
        listDepartment = [],
        isVerified = false,
        registerUserUid = '',
        registerUserEmail = '';

  Company.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        category = map['category'],
        employeesNumber = map['employeesNumber'],
        country = map['country'],
        city = map['city'],
        address = map['address'],
        zipCode = map['zipCode'],
        hasMoreDepartment = map['hasMoreDepartment'],
        listDepartment = map['listDepartment'] != null
            ? map['listDepartment']
                .map<Department>((json) =>
                    Department.fromMap(Map<String, dynamic>.from(json)))
                .toList()
            : [],
        isVerified = map['isVerified'] ?? false,
        registerUserUid = map['registerUserUid'] ?? '',
        registerUserEmail = map['registerUserEmail'] ?? '';

  EmployeesNumberCategory employeesNumberCategory() {
    if (employeesNumber <= 10) {
      return EmployeesNumberCategory.micro;
    }

    if (employeesNumber <= 50) {
      return EmployeesNumberCategory.small;
    }

    if (employeesNumber <= 250) {
      return EmployeesNumberCategory.medium;
    }

    return EmployeesNumberCategory.large;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'employeesNumber': employeesNumber,
        'country': country,
        'city': city,
        'address': address,
        'zipCode': zipCode,
        'listDepartment': listDepartment != null
            ? jsonDecode(jsonEncode(listDepartment!))
            : null,
        'hasMoreDepartment': hasMoreDepartment,
        'isVerified': isVerified,
        'registerUserEmail': registerUserEmail,
        'registerUserUid': registerUserUid,
      };

  static List<String> get categories => [
        "Aziende italiane di abbigliamento",
        "Società di gestione aeroportuale d'Italia",
        "Aziende agricole italiane",
        "Aziende alimentari italiane",
        "Aziende italiane di armi leggere",
        "Aziende italiane di arredamento",
        "Aziende italiane di cancelleria",
        "Carrozzerie automobilistiche italiane",
        "Aziende cartarie italiane",
        "Aziende chimiche italiane",
        "Aziende cinematografiche italiane",
        "Aziende commerciali italiane",
        "Aziende italiane di componentistica",
        "Aziende italiane di strumenti per la cucina",
        "Aziende italiane di cucine componibili",
        "Aziende italiane del settore difesa",
        "Aziende italiane di edilizia",
        "Editoria in Italia",
        "Aziende italiane di elettrodomestici",
        "Aziende italiane di elettronica",
        "Industria dell'energia in Italia",
        "Enti e istituzioni dell'Italia",
        "Aziende farmaceutiche italiane",
        "Fiere dell'Italia",
        "Aziende italiane di servizi finanziari",
        "Aziende fotografiche italiane",
        "Aziende italiane di giocattoli",
        "Aziende italiane di giochi",
        "Aziende italiane di illuminazione",
        "Aziende informatiche italiane",
        "Aziende italiane di marketing",
        "Aziende metalmeccaniche italiane",
        "Società minerarie italiane",
        "Moda italiana",
        "Aziende italiane di modellismo",
        "Aziende musicali italiane",
        "Aziende italiane di orologeria",
        "Aziende italiane di servizi postali",
        "Aziende siderurgiche italiane",
        "Aziende italiane di attrezzature sportive",
        "Società sportive italiane",
        "Studi di doppiaggio italiani",
        "Aziende italiane del settore del tabacco",
        "Aziende italiane di telecomunicazioni",
        "Aziende tessili italiane",
        "Aziende italiane del settore dei trasporti",
        "Aziende turistiche italiane",
        "Vetrerie italiane",
      ];

  @override
  int get hashCode => Object.hash(
        id,
        name,
        category,
        employeesNumber,
        country,
        city,
        address,
        zipCode,
        hasMoreDepartment,
        isVerified,
        hashList(listDepartment),
      );

  @override
  bool operator ==(Object other) =>
      other is Company &&
      other.id == id &&
      other.name == name &&
      other.category == category &&
      other.employeesNumber == employeesNumber &&
      other.country == country &&
      other.city == city &&
      other.address == address &&
      other.zipCode == zipCode &&
      other.hasMoreDepartment == hasMoreDepartment &&
      other.isVerified == isVerified &&
      other.listDepartment == listDepartment;
}

class Department {
  String id;
  String name;

  Department({
    required this.id,
    required this.name,
  });

  Department.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  int get hashCode => Object.hash(id, name);

  @override
  bool operator ==(Object other) =>
      other is Department && other.id == id && other.name == name;
}
