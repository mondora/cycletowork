import 'package:cycletowork/src/data/pagination.dart';

enum UserType {
  other,
  mondora,
  fiab,
}

class User {
  static String get _splitPattern => '######';
  String uid;
  String email;
  UserType userType;
  bool admin;
  bool verified;
  double co2;
  double distance;
  double averageSpeed;
  double maxSpeed;
  int calorie;
  int steps;
  String? photoURL;
  bool? emailVerified;
  String? displayName;
  List<String>? deviceTokens;
  String? language;
  List<String>? listChallengeIdRegister;
  String fiabCardNumber;
  bool selected = false;

  User({
    required this.uid,
    required this.userType,
    required this.email,
    required this.admin,
    required this.verified,
    required this.co2,
    required this.distance,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.calorie,
    required this.steps,
    required this.fiabCardNumber,
    this.photoURL,
    this.displayName,
    this.deviceTokens,
    this.listChallengeIdRegister,
    this.emailVerified,
    this.language,
  });

  User.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        userType = map['userType'] != null
            ? UserType.values.firstWhere(
                (element) =>
                    element.name.toLowerCase() == map['userType'].toLowerCase(),
              )
            : UserType.other,
        admin = map['admin'] ??
            (map['customClaims'] != null
                ? map['customClaims']['admin'] ?? false
                : false),
        verified = map['verified'] ??
            (map['customClaims'] != null
                ? map['customClaims']['verified'] ?? false
                : false),
        email = map['email'],
        emailVerified = map['emailVerified'],
        photoURL = map['photoURL'],
        displayName = map['displayName'],
        co2 = map['co2'] != null ? double.parse(map['co2'].toString()) : 0,
        distance = map['distance'] != null
            ? double.parse(map['distance'].toString())
            : 0,
        averageSpeed = map['averageSpeed'] != null
            ? double.parse(map['averageSpeed'].toString())
            : 0,
        maxSpeed = map['maxSpeed'] != null
            ? double.parse(map['maxSpeed'].toString())
            : 0,
        calorie = map['calorie'] ?? 0,
        steps = map['steps'] ?? 0,
        deviceTokens = map['deviceTokens'] != null
            ? (map['deviceTokens'] as List<dynamic>).cast<String>()
            : null,
        listChallengeIdRegister = map['listChallengeIdRegister'] != null
            ? (map['listChallengeIdRegister'] as List<dynamic>).cast<String>()
            : null,
        language = map['language'],
        fiabCardNumber = map['fiabCardNumber'] ?? '';

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userType': userType.name,
        'email': email,
        'emailVerified': emailVerified,
        'photoURL': photoURL,
        'displayName': displayName,
        'co2': co2,
        'distance': distance,
        'averageSpeed': averageSpeed,
        'maxSpeed': maxSpeed,
        'calorie': calorie,
        'steps': steps,
        'listChallengeIdRegister': listChallengeIdRegister,
        'admin': admin,
        'verified': verified,
        'language': language,
        'fiabCardNumber': fiabCardNumber,
      };

  User.fromMapLocalDatabase(Map<String, dynamic> map)
      : uid = map['uid'],
        userType = map['userType'] != null
            ? UserType.values.firstWhere(
                (element) =>
                    element.name.toLowerCase() == map['userType'].toLowerCase(),
              )
            : UserType.other,
        admin = false,
        verified = false,
        email = map['email'],
        emailVerified = null,
        photoURL = map['photoURL'],
        displayName = map['displayName'],
        co2 = map['co2'] != null ? double.parse(map['co2'].toString()) : 0,
        distance = map['distance'] != null
            ? double.parse(map['distance'].toString())
            : 0,
        averageSpeed = map['averageSpeed'] != null
            ? double.parse(map['averageSpeed'].toString())
            : 0,
        maxSpeed = map['maxSpeed'] != null
            ? double.parse(map['maxSpeed'].toString())
            : 0,
        calorie = map['calorie'] ?? 0,
        steps = map['steps'] ?? 0,
        deviceTokens = [],
        language = map['language'],
        fiabCardNumber = map['fiabCardNumber'],
        listChallengeIdRegister = map['listChallengeIdRegister'] != null
            ? (map['listChallengeIdRegister'] as String).split(_splitPattern)
            : null;

  Map<String, dynamic> toJsonForLocalDatabase() => {
        'uid': uid,
        'email': email,
        'userType': userType.name,
        'photoURL': photoURL,
        'displayName': displayName,
        'co2': co2,
        'distance': distance,
        'averageSpeed': averageSpeed,
        'maxSpeed': maxSpeed,
        'calorie': calorie,
        'steps': steps,
        'language': language,
        'fiabCardNumber': fiabCardNumber,
        'listChallengeIdRegister': listChallengeIdRegister != null
            ? listChallengeIdRegister!.join(_splitPattern)
            : '',
      };

  static String get deviceTokensKey => 'User_deviceTokens';
  static String get deviceTokensExpireDateKey =>
      'User_deviceTokens_expire_date';
  static String get userUIDKey => 'User_uid';

  static String get tableName => 'User';

  static String get tableString => '''
    CREATE TABLE IF NOT EXISTS $tableName( 
      uid TEXT PRIMARY KEY  NOT NULL,
      email TEXT NOT NULL,
      userType TEXT NOT NULL,
      co2 REAL NOT NULL,
      distance REAL NOT NULL,
      averageSpeed REAL NOT NULL,
      maxSpeed REAL NOT NULL, 
      calorie INTEGER NOT NULL,
      steps INTEGER NOT NULL,
      fiabCardNumber TEXT NOT NULL,
      photoURL TEXT,
      displayName TEXT,
      language TEXT,
      listChallengeIdRegister TEXT
    );
  ''';
}

class ListUser {
  List<User> users;
  Pagination pagination;

  ListUser({
    required this.users,
    required this.pagination,
  });

  ListUser.fromMap(Map<String, dynamic> map)
      : users = map['users'] != null
            ? map['users'].map<User>((json) => User.fromMap(json)).toList()
            : [],
        pagination = Pagination.fromMap(map['pagination']);
}
