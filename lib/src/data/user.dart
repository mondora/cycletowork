enum UserType {
  other,
  mondora,
  fiab,
}

class User {
  final UserType userType;
  final String email;
  String? imageUrl;
  String? displayName;

  User({
    required this.userType,
    required this.email,
    this.imageUrl,
    this.displayName,
  });
}
