enum UserType {
  other,
  mondora,
  fiab,
}

class User {
  final String uid;
  final String email;
  UserType userType;
  bool admin;
  bool verified;
  String? photoURL;
  bool? emailVerified;
  String? displayName;
  List<String>? deviceTokens;
  List<String>? listChallengeId;
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
    this.listChallengeId,
    this.emailVerified,
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
        listChallengeId = map['listChallengeId'] != null
            ? (map['listChallengeId'] as List<dynamic>).cast<String>()
            : null;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userType': userType,
        'email': email,
        'emailVerified': emailVerified,
        'photoURL': photoURL,
        'displayName': displayName,
        'deviceTokens': deviceTokens,
        'listChallengeId': listChallengeId,
        'admin': admin,
        'verified': verified,
      };

  static String get deviceTokensKey => 'User_deviceTokens';
}

class ListUser {
  List<User> users;
  ListUserPagination pagination;

  ListUser({
    required this.users,
    required this.pagination,
  });

  ListUser.fromMap(Map<String, dynamic> map)
      : users = map['users'] != null
            ? map['users'].map<User>((json) => User.fromMap(json)).toList()
            : [],
        pagination = ListUserPagination.fromMap(map['pagination']);
}

class ListUserPagination {
  final bool hasNextPage;
  final String? nextPageToken;

  ListUserPagination({
    required this.hasNextPage,
    this.nextPageToken,
  });

  ListUserPagination.fromMap(Map<String, dynamic> map)
      : hasNextPage = map['hasNextPage'],
        nextPageToken = map['nextPageToken'];
}
