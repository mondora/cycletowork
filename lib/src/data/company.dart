import 'package:flutter/material.dart';

class Company {
  final String id;
  final String name;
  final String category;
  final int employeesNumber;
  final String country;
  final String city;
  final String address;
  final int cap;
  final bool hasMoreDepartment;
  final List<Department>? listDepartment;

  Company({
    required this.id,
    required this.name,
    required this.category,
    required this.employeesNumber,
    required this.country,
    required this.city,
    required this.address,
    required this.cap,
    required this.hasMoreDepartment,
    this.listDepartment,
  });

  Company.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        category = map['category'],
        employeesNumber = map['employeesNumber'],
        country = map['country'],
        city = map['city'],
        address = map['address'],
        cap = map['cap'],
        hasMoreDepartment = map['hasMoreDepartment'],
        listDepartment = map['listDepartment'] != null
            ? map['listDepartment']
                .map<Department>((json) => Department.fromMap(json))
                .toList()
            : [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'employeesNumber': employeesNumber,
        'country': country,
        'city': city,
        'address': address,
        'cap': cap,
        'hasMoreDepartment': hasMoreDepartment,
        'listDepartment': listDepartment,
      };

  @override
  int get hashCode => hashValues(
        id,
        name,
        category,
        employeesNumber,
        country,
        city,
        address,
        cap,
        hasMoreDepartment,
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
      other.cap == cap &&
      other.hasMoreDepartment == hasMoreDepartment &&
      other.listDepartment == listDepartment;
}

class Department {
  final String id;
  final String name;

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
  int get hashCode => hashValues(id, name);

  @override
  bool operator ==(Object other) =>
      other is Department && other.id == id && other.name == name;
}
