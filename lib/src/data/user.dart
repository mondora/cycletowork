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
  String? photoURL;
  bool? emailVerified;
  String? displayName;
  List<String>? deviceTokens;
  String? language;
  List<String>? listChallengeIdRegister;
  bool selected = false;

  User({
    required this.uid,
    required this.userType,
    required this.email,
    required this.admin,
    required this.verified,
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
        deviceTokens = map['deviceTokens'] != null
            ? (map['deviceTokens'] as List<dynamic>).cast<String>()
            : null,
        listChallengeIdRegister = map['listChallengeIdRegister'] != null
            ? (map['listChallengeIdRegister'] as List<dynamic>).cast<String>()
            : null,
        language = map['language'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userType': userType,
        'email': email,
        'emailVerified': emailVerified,
        'photoURL': photoURL,
        'displayName': displayName,
        'deviceTokens': deviceTokens,
        'listChallengeIdRegister': listChallengeIdRegister,
        'admin': admin,
        'verified': verified,
        'language': language,
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
        deviceTokens = [],
        language = map['language'],
        listChallengeIdRegister = map['listChallengeIdRegister'] != null
            ? (map['listChallengeIdRegister'] as String).split(_splitPattern)
            : null;

  Map<String, dynamic> toJsonForLocalDatabase() => {
        'uid': uid,
        'email': email,
        'userType': userType.name,
        'photoURL': photoURL,
        'displayName': displayName,
        'language': language,
        'listChallengeIdRegister': listChallengeIdRegister != null
            ? listChallengeIdRegister!.join(_splitPattern)
            : '',
      };

  static String get deviceTokensKey => 'User_deviceTokens';

  static String get tableName => 'User';

  static String get tableString => '''
    CREATE TABLE IF NOT EXISTS $tableName( 
      uid TEXT PRIMARY KEY  NOT NULL,
      email TEXT NOT NULL,
      userType TEXT NOT NULL,
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
