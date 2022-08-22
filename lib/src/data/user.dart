enum UserType {
  other,
  mondora,
  fiab,
}

// admin: false,
//         userType: Constant.UserType.Other,
//         email: user.email,
//         displayName: user.displayName,
//         uid: uid,
//         emailVerified: user.emailVerified,
//         photoURL: user.photoURL,
//         createUserDate: Date.now(),
//         deviceTokens: [],
class User {
  final String uid;
  final UserType userType;
  final String email;
  String? photoURL;
  bool? emailVerified;
  String? displayName;
  List<String>? deviceTokens;

  User({
    required this.uid,
    required this.userType,
    required this.email,
    this.photoURL,
    this.displayName,
    this.deviceTokens,
  });

  User.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        userType = UserType.values.firstWhere(
          (element) =>
              element.name.toLowerCase() == map['userType'].toLowerCase(),
        ),
        email = map['email'],
        photoURL = map['photoURL'],
        displayName = map['displayName'],
        deviceTokens = map['deviceTokens'] != null
            ? (map['deviceTokens'] as List<dynamic>).cast<String>()
            : null;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userType': userType,
        'email': email,
        'photoURL': photoURL,
        'displayName': displayName,
        'deviceTokens': deviceTokens,
      };

  static String get deviceTokensKey => 'User_deviceTokens';
}
