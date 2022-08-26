import 'package:cycletowork/src/data/user.dart';

enum PageOption {
  user,
  challenge,
  survey,
  company,
}

class UiState {
  bool loading = true;
  bool error = false;
  String errorMessage = '';
  PageOption pageOption = PageOption.user;
  ListUser? listUser;
  User? userInfo;
  int listUserPageSize = 15;
  String? listUserNextPageToken;
  String? listUserEmailFilte;
}
