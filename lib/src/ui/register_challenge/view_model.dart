import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/ui/register_challenge/repository.dart';
import 'package:cycletowork/src/ui/register_challenge/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ViewModel extends ChangeNotifier {
  late BuildContext _context;
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  ViewModel(Challenge challenge, BuildContext context)
      : this.instance(challenge, context);

  ViewModel.instance(Challenge challenge, BuildContext context) {
    _uiState.challenge = challenge;
    _context = context;
    _uiState.challengeRegistry.surveyResponse = SurveyResponse(
      id: const Uuid().v4(),
      name: challenge.name,
      listAnswer: challenge.listQuestion
          .map(
            (e) => Answer(
              tag: e.tag,
              title: e.title,
              answers: [],
              moreAnswer: '',
            ),
          )
          .toList(),
    );

    _uiState.surveyResponse = SurveyResponse(
      id: const Uuid().v4(),
      name: challenge.survey.name,
      listAnswer: challenge.survey.listQuestion
          .map(
            (e) => Answer(
              tag: e.tag,
              title: e.title,
              answers: [],
              moreAnswer: '',
            ),
          )
          .toList(),
    );

    _uiState.challengeRegistry.startTimeChallenge = challenge.startTime;
    _uiState.challengeRegistry.stopTimeChallenge = challenge.stopTime;
    _uiState.challengeRegistry.isFiabMember =
        AppData.user!.fiabCardNumber.isNotEmpty;
    _uiState.challengeRegistry.fiabCardNumber = AppData.user!.fiabCardNumber;
    getter();
  }

  getter() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await getCompanyList();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  Future<void> saveSurveyResponse(
    SurveyResponse surveyResponse,
  ) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _repository.saveSurveyResponse(
        _uiState.challenge!,
        surveyResponse,
      );
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
      Navigator.pop(_context);
    }
  }

  // Future<void> searchCompanyName(String name) async {
  //   // _uiState.loading = true;
  //   // notifyListeners();
  //   try {
  //     await _getCompanyListNameSearch(name);
  //     // _uiState.challengeRegistry.compan syName = name;
  //   } catch (e) {
  //     _uiState.errorMessage = e.toString();
  //     _uiState.error = true;
  //     Logger.error(e);
  //   } finally {
  //     // _uiState.loading = false;
  //     notifyListeners();
  //   }
  // }

  void sendEmailVerificationCode() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var email = _uiState.challengeRegistry.businessEmail;
      var displayName =
          '${_uiState.challengeRegistry.name} ${_uiState.challengeRegistry.lastName}';
      await _repository.sendEmailVerificationCode(
        email,
        displayName,
      );
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void registerChallenge() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _uiState.challengeRegistry.id = AppData.user!.uid;
      _uiState.challengeRegistry.uid = AppData.user!.uid;
      _uiState.challengeRegistry.challengeId = _uiState.challenge!.id;
      _uiState.challengeRegistry.challengeName = _uiState.challenge!.name;
      _uiState.challengeRegistry.registerDate =
          DateTime.now().millisecondsSinceEpoch;
      if (_uiState.challengeRegistry.isCyclist) {
        _uiState.challengeRegistry.companyToAdd = null;
      } else {
        _uiState.challengeRegistry.companySelected =
            _uiState.challengeRegistry.companyToAdd;
        _uiState.challengeRegistry.companySelected!.id =
            _uiState.challengeRegistry.companyToAdd!.id;
        _uiState.challengeRegistry.companyId =
            _uiState.challengeRegistry.companyToAdd!.id;
      }
      if (_uiState.challengeRegistry.businessEmail.contains('@mondora.com')) {
        AppData.user!.userType = UserType.mondora;
      }

      if (_uiState.challengeRegistry.isFiabMember) {
        AppData.user!.userType = UserType.fiab;
        AppData.user!.fiabCardNumber =
            _uiState.challengeRegistry.fiabCardNumber;
      }
      _uiState.challengeRegistry.email = AppData.user!.email;
      _uiState.challengeRegistry.userType = AppData.user!.userType.name;
      _uiState.challengeRegistry.displayName = AppData.user!.displayName;
      _uiState.challengeRegistry.photoURL = AppData.user!.photoURL;
      _uiState.challengeRegistry.companyEmployeesNumber =
          _uiState.challengeRegistry.companySelected!.employeesNumber;
      _uiState.challengeRegistry.companySizeCategory = _uiState
          .challengeRegistry.companySelected!
          .employeesNumberCategory()
          .name;
      await _repository.registerChallenge(_uiState.challengeRegistry);
      _uiState.pageOption = PageOption.thanks;
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void gotoCyclistRegistration() {
    _uiState.pageOption = PageOption.cyclistRegistration;
    _uiState.challengeRegistry.isCyclist = true;
    _uiState.challengeRegistry.isChampion = false;
    _uiState.challengeRegistry.companyToAdd = null;
    notifyListeners();
  }

  void gotoChampionRegistration() {
    _uiState.challengeRegistry.isCyclist = false;
    _uiState.challengeRegistry.isChampion = true;
    _uiState.challengeRegistry.companyToAdd = Company.fromEmpty();
    _uiState.challengeRegistry.companyToAdd!.id = const Uuid().v4();
    _uiState.challengeRegistry.companyToAdd!.country = 'ITALIA';
    _uiState.challengeRegistry.companyToAdd!.registerUserEmail =
        AppData.user!.email;
    _uiState.challengeRegistry.companyToAdd!.registerUserUid =
        AppData.user!.uid;
    _uiState.pageOption = PageOption.championRegistration;
    notifyListeners();
  }

  void backToChampionRegistration() {
    _uiState.pageOption = PageOption.championRegistration;
    notifyListeners();
  }

  void gotoSelectType() {
    _uiState.pageOption = PageOption.selectType;
    notifyListeners();
  }

  void gotoCyclistRegistrationData() {
    _uiState.pageOption = PageOption.cyclistRegistrationData;
    notifyListeners();
  }

  void gotoChampionRegistrationData() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var challengeId = _uiState.challenge!.id;
      var companyName = _uiState.challengeRegistry.companyName;
      var isCompanyExist = await _repository.isCompanyExist(
        challengeId,
        companyName,
      );
      if (isCompanyExist) {
        _uiState.errorMessage =
            'La azienda "${_uiState.challengeRegistry.companyName}" già esiste';
        _uiState.error = true;
      } else {
        _uiState.pageOption = PageOption.championRegistrationData;
      }
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void gotoSurvey() {
    _uiState.pageOption = PageOption.survey;
    notifyListeners();
  }

  void gotoEmailVerifiy() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var businessEmail = _uiState.challengeRegistry.businessEmail;
      var challengeId = _uiState.challenge!.id;
      var isEmailExist =
          await _repository.isEmailExist(challengeId, businessEmail);
      if (isEmailExist) {
        _uiState.errorMessage = 'Email "$businessEmail" già registrato';
        _uiState.error = true;
      } else {
        var displayName =
            '${_uiState.challengeRegistry.name} ${_uiState.challengeRegistry.lastName}';
        await _repository.sendEmailVerificationCode(
          businessEmail,
          displayName,
        );
        _uiState.pageOption = PageOption.emailVerification;
      }
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void verifiyEmailCode(String code) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var email = _uiState.challengeRegistry.businessEmail;
      await _repository.verifiyEmailCode(
        email,
        code,
      );
      _uiState.challengeRegistry.businessEmailVerification = true;
    } catch (e) {
      _uiState.errorMessage =
          'Il codice non è valido o scaduto. Riprova a mandare il codice';
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void setFiabMember(bool isFiabMember) {
    _uiState.challengeRegistry.isFiabMember = isFiabMember;
    if (!isFiabMember) {
      _uiState.challengeRegistry.fiabCardNumber = '';
    }
    notifyListeners();
  }

  void setAcceptPrivacy(value) {
    _uiState.challengeRegistry.acceptPrivacy = value;
    notifyListeners();
  }

  void setName(value) {
    _uiState.challengeRegistry.name = value;
    notifyListeners();
  }

  void setLastName(value) {
    _uiState.challengeRegistry.lastName = value;
    notifyListeners();
  }

  void setBusinessEmail(value) {
    _uiState.challengeRegistry.businessEmail = value;
    notifyListeners();
  }

  void setZipCode(value) {
    _uiState.challengeRegistry.zipCode = value;
    notifyListeners();
  }

  void setAddress(value) {
    _uiState.challengeRegistry.address = value;
    notifyListeners();
  }

  void setCity(value) {
    _uiState.challengeRegistry.city = value;
    notifyListeners();
  }

  void setBusinessZipCode(value) {
    _uiState.challengeRegistry.businessZipCode = value;
    notifyListeners();
  }

  void setBusinessAddress(value) {
    _uiState.challengeRegistry.businessAddress = value;
    notifyListeners();
  }

  void setBusinessCity(value) {
    _uiState.challengeRegistry.businessCity = value;
    notifyListeners();
  }

  void changeFiabCardNumber(String value) {
    var isInt = int.tryParse(value);
    if (isInt != null) {
      _uiState.challengeRegistry.fiabCardNumber = value;
      notifyListeners();
    }
  }

  void setDepartmentName(String departmentName) {
    _uiState.challengeRegistry.departmentName = departmentName;
    notifyListeners();
  }

  void setCompanyName(String companyName) {
    _uiState.challengeRegistry.companyName = companyName;
    _uiState.challengeRegistry.companySelected = _uiState.listCompany
        .firstWhere((element) => element.name == companyName);
    _uiState.challengeRegistry.companyId =
        _uiState.challengeRegistry.companySelected!.id;
    notifyListeners();
  }

  void setAnswer(int index, String answerValue) {
    var listQuestion = _uiState.challenge!.listQuestion;
    var question = listQuestion[index];
    var answer = _uiState.challengeRegistry.surveyResponse!.listAnswer[index];

    var indexWhere =
        answer.answers.indexWhere((element) => element == answerValue);
    if (indexWhere >= 0) {
      answer.answers.removeAt(indexWhere);
      notifyListeners();
      return;
    }
    var maxAnswer = question.maxAnswer;

    if (maxAnswer > answer.answers.length) {
      answer.answers.add(answerValue);
    } else {
      if (indexWhere >= 0) {
        answer.answers.removeAt(indexWhere);
      } else {
        if (maxAnswer == 0) {
          answer.answers.add(answerValue);
        } else {
          answer.answers.removeLast();
          answer.answers.add(answerValue);
        }
      }
    }
    notifyListeners();
  }

  void setCompanyToAddCategory(value) {
    _uiState.challengeRegistry.companyToAdd!.category = value;
    notifyListeners();
  }

  void setCompanyToAddEmployeesNumber(String value) {
    var isInt = int.tryParse(value);
    if (isInt != null) {
      _uiState.challengeRegistry.companyToAdd!.employeesNumber =
          int.parse(value);
      notifyListeners();
    }
  }

  void setCompanyToAddName(String value) {
    _uiState.challengeRegistry.companyToAdd!.name = value;
    _uiState.challengeRegistry.companyName = value;
    notifyListeners();
  }

  void setCompanyToAddZipCode(String value) {
    var isInt = int.tryParse(value);
    if (isInt != null) {
      _uiState.challengeRegistry.companyToAdd!.zipCode = int.parse(value);
      notifyListeners();
    }
  }

  void setCompanyToAddAddress(String value) {
    _uiState.challengeRegistry.companyToAdd!.address = value;
    notifyListeners();
  }

  void setCompanyToAddCity(String value) {
    _uiState.challengeRegistry.companyToAdd!.city = value;
    notifyListeners();
  }

  void setCompanyToAddNoDepartment() {
    _uiState.challengeRegistry.companyToAdd!.hasMoreDepartment = false;
    _uiState.challengeRegistry.companyToAdd!.listDepartment = [];
    notifyListeners();
  }

  void setCompanyToAddHasDepartment() {
    _uiState.challengeRegistry.companyToAdd!.hasMoreDepartment = true;
    _uiState.challengeRegistry.companyToAdd!.listDepartment = [
      Department(id: const Uuid().v4(), name: ''),
      Department(id: const Uuid().v4(), name: ''),
    ];
    notifyListeners();
  }

  void setCompanyToAddDepartment(int index, String value) {
    _uiState.challengeRegistry.companyToAdd!.listDepartment![index].name =
        value;
    notifyListeners();
  }

  void setCompanyToAddAddDepartment() {
    _uiState.challengeRegistry.companyToAdd!.listDepartment!.add(
      Department(id: const Uuid().v4(), name: ''),
    );
    notifyListeners();
  }

  void setCompanyToAddRemoveDepartment(int index) {
    _uiState.challengeRegistry.companyToAdd!.listDepartment!.removeAt(
      index,
    );
    notifyListeners();
  }

  void setRole(String value) {
    _uiState.challengeRegistry.role = value;
    notifyListeners();
  }

  void clearError() {
    _uiState.error = false;
    _uiState.errorMessage = '';
    notifyListeners();
  }

  Future<void> getCompanyList() async {
    var result = await _repository.getCompanyListForChallenge(
      _uiState.challenge!.id,
      1000,
    );
    _uiState.listCompany = result;
    notifyListeners();
  }

  // Future<void> _getCompanyListNameSearch(String name) async {
  //   var result = await _repository.getCompanyListNameSearchForChalleng(
  //     _uiState.challenge!.id,
  //     name,
  //     10,
  //   );
  //   _uiState.listCompany = result;
  // }

  // void _initCompanyToAdd() {
  //   _uiState.challengeRegistry.companyToAdd = Company.fromEmpty();
  //   _uiState.challengeRegistry.companyToAdd!.id = const Uuid().v4();
  //   _uiState.challengeRegistry.companyToAdd!.country = 'ITALIA';
  //   _uiState.challengeRegistry.companyToAdd!.registerUserEmail =
  //       AppData.user!.email;
  //   _uiState.challengeRegistry.companyToAdd!.registerUserUid =
  //       AppData.user!.uid;
  // }
}
