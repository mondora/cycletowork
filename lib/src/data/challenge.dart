import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/survey.dart';

class Challenge {
  String id;
  String name;
  int startTime;
  int stopTime;
  bool fiabEdition;
  bool requiredSurvey;
  bool requiredCompany;
  bool requiredNameLastName;
  bool requiredBusinessEmail;
  bool requiredBusinessEmailVerification;
  bool requiredWorkAddress;
  List<Question> listQuestion;
  Survey survey;
  String language;
  bool published;
  bool selected = false;

  Challenge({
    required this.id,
    required this.name,
    required this.startTime,
    required this.stopTime,
    required this.fiabEdition,
    required this.requiredSurvey,
    required this.requiredCompany,
    required this.requiredNameLastName,
    required this.requiredBusinessEmail,
    required this.requiredBusinessEmailVerification,
    required this.requiredWorkAddress,
    required this.listQuestion,
    required this.survey,
    required this.language,
    required this.published,
  });

  factory Challenge.fromChallenge(Challenge challenge) =>
      Challenge.fromMap(challenge.toJson());

  Challenge.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        name = map['name'],
        startTime = map['startTime'],
        stopTime = map['stopTime'],
        fiabEdition = map['fiabEdition'],
        requiredSurvey = map['requiredSurvey'],
        requiredCompany = map['requiredCompany'],
        requiredNameLastName = map['requiredNameLastName'],
        requiredBusinessEmail = map['requiredBusinessEmail'],
        requiredBusinessEmailVerification =
            map['requiredBusinessEmailVerification'],
        requiredWorkAddress = map['requiredWorkAddress'],
        listQuestion = map['listQuestion']
            .map<Question>(
                (json) => Question.fromMap(Map<String, dynamic>.from(json)))
            .toList(),
        survey = Survey.fromMap(Map<String, dynamic>.from(map['survey'])),
        language = map['language'],
        published = map['published'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startTime': startTime,
        'stopTime': stopTime,
        'fiabEdition': fiabEdition,
        'requiredSurvey': requiredSurvey,
        'requiredCompany': requiredCompany,
        'requiredNameLastName': requiredNameLastName,
        'requiredBusinessEmail': requiredBusinessEmail,
        'requiredBusinessEmailVerification': requiredBusinessEmailVerification,
        'requiredWorkAddress': requiredWorkAddress,
        'listQuestion': listQuestion.map((e) => e.toJson()).toList(),
        'survey': survey.toJson(),
        'language': language,
        'published': published,
      };
}

class ChallengeRegistry {
  String id;
  String uid;
  String challengeId;
  bool isCyclist;
  bool isChampion;
  bool isFiabMember;
  String fiabCardNumber;
  String companyName;
  String departmentName;
  String name;
  String lastName;
  String city;
  String zipCode;
  String address;
  String businessEmail;
  bool businessEmailVerification;
  String businessCity;
  String businessZipCode;
  String businessAddress;
  String role;
  bool acceptPrivacy;
  int registerDate;
  Company? companySelected;
  SurveyResponse? surveyResponse;
  Company? companyToAdd;
  bool selected = false;

  ChallengeRegistry({
    required this.id,
    required this.uid,
    required this.challengeId,
    required this.isCyclist,
    required this.isChampion,
    required this.isFiabMember,
    required this.fiabCardNumber,
    required this.companyName,
    required this.departmentName,
    required this.name,
    required this.lastName,
    required this.city,
    required this.address,
    required this.zipCode,
    required this.businessEmail,
    required this.businessEmailVerification,
    required this.businessCity,
    required this.businessZipCode,
    required this.businessAddress,
    required this.role,
    required this.acceptPrivacy,
    required this.registerDate,
    this.surveyResponse,
    this.companyToAdd,
    this.companySelected,
  });

  ChallengeRegistry.fromEmpty()
      : id = '',
        uid = '',
        challengeId = '',
        isCyclist = false,
        isChampion = false,
        isFiabMember = false,
        fiabCardNumber = '',
        companyName = '',
        departmentName = '',
        name = '',
        lastName = '',
        city = '',
        address = '',
        zipCode = '',
        businessEmail = '',
        businessEmailVerification = false,
        businessCity = '',
        businessZipCode = '',
        businessAddress = '',
        role = '',
        acceptPrivacy = false,
        registerDate = 0,
        surveyResponse = null,
        companyToAdd = null,
        companySelected = null;

  ChallengeRegistry.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        uid = map['uid'],
        challengeId = map['challengeId'],
        isCyclist = map['isCyclist'],
        isChampion = map['isChampion'],
        isFiabMember = map['isFiabMember'],
        fiabCardNumber = map['fiabCardNumber'],
        companyName = map['companyName'],
        departmentName = map['departmentName'],
        name = map['name'],
        lastName = map['lastName'],
        city = map['city'],
        address = map['address'],
        zipCode = map['zipCode'],
        businessEmail = map['businessEmail'],
        businessEmailVerification = map['businessEmailVerification'],
        businessCity = map['businessCity'],
        businessZipCode = map['businessZipCode'],
        businessAddress = map['businessAddress'],
        role = map['role'],
        acceptPrivacy = map['acceptPrivacy'],
        registerDate = map['registerDate'],
        surveyResponse = map['surveyResponse'] != null
            ? SurveyResponse.fromMap(
                Map<String, dynamic>.from(map['surveyResponse']))
            : null,
        companyToAdd = map['companyToAdd'] != null
            ? Company.fromMap(Map<String, dynamic>.from(map['companyToAdd']))
            : null,
        companySelected = map['companySelected'] != null
            ? Company.fromMap(Map<String, dynamic>.from(map['companySelected']))
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'challengeId': challengeId,
        'isCyclist': isCyclist,
        'isChampion': isChampion,
        'isFiabMember': isFiabMember,
        'fiabCardNumber': fiabCardNumber,
        'companyName': companyName,
        'departmentName': departmentName,
        'name': name,
        'lastName': lastName,
        'city': city,
        'address': address,
        'zipCode': zipCode,
        'businessEmail': businessEmail,
        'businessEmailVerification': businessEmailVerification,
        'businessCity': businessCity,
        'businessZipCode': businessZipCode,
        'businessAddress': businessAddress,
        'role': role,
        'acceptPrivacy': acceptPrivacy,
        'registerDate': registerDate,
        'surveyResponse': surveyResponse?.toJson(),
        'companyToAdd': companyToAdd?.toJson(),
        'companySelected': companySelected?.toJson(),
      };
}
