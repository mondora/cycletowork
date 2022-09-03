import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/survey.dart';
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
  List<Company> listCompany = [];
  String? lastCompanyName;
  int listCompanyPageSize = 15;

  List<Survey> listSurvey = [];
  String? lastSurveyName;
  int listSurveyPageSize = 15;

  List<Challenge> listChallenge = [];
  String? lastChallengeName;
  int listChallengePageSize = 15;
}
