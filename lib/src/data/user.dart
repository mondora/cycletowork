enum UserType {
  other,
  mondora,
  fiab,
}

class User {
  final UserType userType;
  String? imageUrl;
  User({required this.userType});
}
