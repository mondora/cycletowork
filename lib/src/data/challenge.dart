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

  Challenge.fromMapLocalDatabase(Map<dynamic, dynamic> map)
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
        listQuestion = [],
        survey = Survey.fromEmpty(),
        language = map['language'],
        published = true;

  Map<String, dynamic> toJsonForLocalDatabase() => {
        'id': id,
        'name': name,
        'startTime': startTime,
        'stopTime': stopTime,
        'fiabEdition': fiabEdition ? 1 : 0,
        'requiredSurvey': requiredSurvey ? 1 : 0,
        'requiredCompany': requiredCompany ? 1 : 0,
        'requiredNameLastName': requiredNameLastName ? 1 : 0,
        'requiredBusinessEmail': requiredBusinessEmail ? 1 : 0,
        'requiredBusinessEmailVerification':
            requiredBusinessEmailVerification ? 1 : 0,
        'requiredWorkAddress': requiredWorkAddress ? 1 : 0,
        'language': language,
      };

  static String get tableName => 'Challenge';

  static String get tableString => '''
    CREATE TABLE IF NOT EXISTS $tableName( 
      id TEXT PRIMARY KEY  NOT NULL,
      name TEXT NOT NULL,
      startTime INTEGER NOT NULL,
      stopTime INTEGER NOT NULL,
      fiabEdition INTEGER NOT NULL,
      requiredBusinessEmail INTEGER NOT NULL,
      requiredBusinessEmailVerification INTEGER NOT NULL,
      requiredCompany INTEGER NOT NULL,
      requiredNameLastName INTEGER NOT NULL,
      requiredSurvey INTEGER NOT NULL,
      requiredWorkAddress INTEGER NOT NULL,
      language TEXT
    );
  ''';
}

class ChallengeRegistry {
  String id;
  String uid;
  String challengeId;
  String challengeName;
  bool isCyclist;
  bool isChampion;
  bool isFiabMember;
  String fiabCardNumber;
  String companyId;
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
  int startTimeChallenge;
  int stopTimeChallenge;
  String email;
  String userType;
  int companyEmployeesNumber;
  String? photoURL;
  String? displayName;
  bool selected = false;

  ChallengeRegistry({
    required this.id,
    required this.uid,
    required this.challengeId,
    required this.challengeName,
    required this.isCyclist,
    required this.isChampion,
    required this.isFiabMember,
    required this.fiabCardNumber,
    required this.companyId,
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
    required this.startTimeChallenge,
    required this.stopTimeChallenge,
    required this.email,
    required this.userType,
    required this.companyEmployeesNumber,
    this.surveyResponse,
    this.companyToAdd,
    this.companySelected,
    this.displayName,
    this.photoURL,
  });

  ChallengeRegistry.fromEmpty()
      : id = '',
        uid = '',
        challengeId = '',
        challengeName = '',
        isCyclist = false,
        isChampion = false,
        isFiabMember = false,
        fiabCardNumber = '',
        companyId = '',
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
        email = '',
        userType = '',
        companyEmployeesNumber = 0,
        displayName = '',
        photoURL = '',
        startTimeChallenge = 0,
        stopTimeChallenge = 0,
        companySelected = null;

  ChallengeRegistry.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        uid = map['uid'],
        challengeId = map['challengeId'],
        challengeName = map['challengeName'],
        isCyclist = map['isCyclist'],
        isChampion = map['isChampion'],
        isFiabMember = map['isFiabMember'],
        fiabCardNumber = map['fiabCardNumber'],
        companyId = map['companyId'],
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
        email = map['email'],
        userType = map['userType'],
        companyEmployeesNumber = map['companyEmployeesNumber'],
        displayName = map['displayName'],
        photoURL = map['photoURL'],
        surveyResponse = map['surveyResponse'] != null
            ? SurveyResponse.fromMap(
                Map<String, dynamic>.from(map['surveyResponse']))
            : null,
        companyToAdd = map['companyToAdd'] != null
            ? Company.fromMap(Map<String, dynamic>.from(map['companyToAdd']))
            : null,
        companySelected = map['companySelected'] != null
            ? Company.fromMap(Map<String, dynamic>.from(map['companySelected']))
            : null,
        startTimeChallenge = map['startTimeChallenge'],
        stopTimeChallenge = map['stopTimeChallenge'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'challengeId': challengeId,
        'challengeName': challengeName,
        'isCyclist': isCyclist,
        'isChampion': isChampion,
        'isFiabMember': isFiabMember,
        'fiabCardNumber': fiabCardNumber,
        'companyId': companyId,
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
        'email': email,
        'userType': userType,
        'companyEmployeesNumber': companyEmployeesNumber,
        'displayName': displayName,
        'photoURL': photoURL,
        'surveyResponse': surveyResponse?.toJson(),
        'companyToAdd': companyToAdd?.toJson(),
        'companySelected': companySelected?.toJson(),
        'startTimeChallenge': startTimeChallenge,
        'stopTimeChallenge': stopTimeChallenge,
      };

  ChallengeRegistry.fromMapLocalDatabase(Map<dynamic, dynamic> map)
      : id = map['id'],
        uid = map['uid'],
        challengeId = map['challengeId'],
        challengeName = map['challengeName'],
        isCyclist = map['isCyclist'] == 1,
        isChampion = map['isChampion'] == 1,
        isFiabMember = map['isFiabMember'] == 1,
        fiabCardNumber = map['fiabCardNumber'],
        companyId = map['companyId'],
        companyName = map['companyName'],
        departmentName = map['departmentName'],
        name = map['name'],
        lastName = map['lastName'],
        city = map['city'],
        address = map['address'],
        zipCode = map['zipCode'],
        businessEmail = map['businessEmail'],
        businessEmailVerification = map['businessEmailVerification'] == 1,
        businessCity = map['businessCity'],
        businessZipCode = map['businessZipCode'],
        businessAddress = map['businessAddress'],
        role = map['role'],
        acceptPrivacy = map['acceptPrivacy'] == 1,
        registerDate = map['registerDate'],
        startTimeChallenge = map['startTimeChallenge'],
        stopTimeChallenge = map['stopTimeChallenge'],
        email = map['email'],
        userType = map['userType'],
        companyEmployeesNumber = map['companyEmployeesNumber'],
        displayName = map['displayName'],
        photoURL = map['photoURL'],
        surveyResponse = null,
        companyToAdd = null,
        companySelected = null;

  Map<String, dynamic> toJsonForLocalDatabase() => {
        'id': id,
        'uid': uid,
        'challengeId': challengeId,
        'challengeName': challengeName,
        'isCyclist': isCyclist ? 1 : 0,
        'isChampion': isChampion ? 1 : 0,
        'isFiabMember': isFiabMember ? 1 : 0,
        'fiabCardNumber': fiabCardNumber,
        'companyId': companyId,
        'companyName': companyName,
        'departmentName': departmentName,
        'name': name,
        'lastName': lastName,
        'city': city,
        'address': address,
        'zipCode': zipCode,
        'businessEmail': businessEmail,
        'businessEmailVerification': businessEmailVerification ? 1 : 0,
        'businessCity': businessCity,
        'businessZipCode': businessZipCode,
        'businessAddress': businessAddress,
        'role': role,
        'email': email,
        'userType': userType,
        'displayName': displayName,
        'photoURL': photoURL,
        'companyEmployeesNumber': companyEmployeesNumber,
        'acceptPrivacy': acceptPrivacy ? 1 : 0,
        'registerDate': registerDate,
        'startTimeChallenge': startTimeChallenge,
        'stopTimeChallenge': stopTimeChallenge,
      };

  static String get tableName => 'ChallengeRegistry';

  static String get tableString => '''
    CREATE TABLE IF NOT EXISTS $tableName( 
      id TEXT PRIMARY KEY  NOT NULL,
      uid TEXT NOT NULL,
      challengeId TEXT NOT NULL,
      challengeName TEXT NOT NULL,
      fiabCardNumber TEXT NOT NULL,
      companyId TEXT NOT NULL,
      companyName TEXT NOT NULL,
      departmentName TEXT NOT NULL,
      name TEXT NOT NULL,
      lastName TEXT NOT NULL,
      city TEXT NOT NULL,
      zipCode TEXT NOT NULL,
      address TEXT NOT NULL,
      businessEmail TEXT NOT NULL,
      businessCity TEXT NOT NULL,
      businessZipCode TEXT NOT NULL,
      businessAddress TEXT NOT NULL,
      role TEXT NOT NULL,
      registerDate INTEGER NOT NULL,
      isCyclist INTEGER NOT NULL,
      isChampion INTEGER NOT NULL,
      isFiabMember INTEGER NOT NULL,
      businessEmailVerification INTEGER NOT NULL,
      acceptPrivacy INTEGER NOT NULL,
      startTimeChallenge INTEGER NOT NULL,
      stopTimeChallenge INTEGER NOT NULL,
      email TEXT NOT NULL,
      userType TEXT NOT NULL,
      companyEmployeesNumber INTEGER NOT NULL,
      displayName TEXT,
      photoURL TEXT
    );
  ''';
}
