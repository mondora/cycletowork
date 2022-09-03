import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/survey.dart';

enum PageOption {
  selectType,
  cyclistRegistration,
  championRegistration,
  cyclistRegistrationData,
  championRegistrationData,
  emailVerification,
  thanks,
  survey,
}

class UiState {
  bool loading = true;
  bool error = false;
  String errorMessage = '';
  Challenge? challenge;
  PageOption pageOption = PageOption.selectType;
  ChallengeRegistry challengeRegistry = ChallengeRegistry.fromEmpty();
  List<Company> listCompany = [];
  SurveyResponse? surveyResponse;
}
