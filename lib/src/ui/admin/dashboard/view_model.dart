import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/data/company.dart';
import 'package:cycletowork/src/data/survey.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/ui/admin/dashboard/repository.dart';
import 'package:cycletowork/src/ui/admin/dashboard/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  int _listUserPage = 0;
  int _listCompanyPage = 0;
  int _listSurveyPage = 0;
  int _listChallengePage = 0;
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  int get pageOptionIndex => PageOption.values.indexOf(_uiState.pageOption);

  ViewModel() : this.instance();

  ViewModel.instance() {
    getter();
  }

  getter() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _uiState.listUser = await _getListUser();
      await _getCompanyList();
      await _getSurveyList();
      await _getChallengeList();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  getterListUser() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _uiState.listUserNextPageToken = null;
      _uiState.listUser = await _getListUser();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  getterListCompany() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _uiState.lastCompanyName = null;
      await _getCompanyList();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  getterListSurvey() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _uiState.lastSurveyName = null;
      await _getSurveyList();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  getterListChallenge() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _uiState.lastChallengeName = null;
      await _getChallengeList();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  Future<void> getUserInfo(String uid) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _uiState.userInfo = await _repository.getUserInfo(uid);
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void addCompany(Company company) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _repository.saveCompany(company);
      _uiState.listCompany.insert(0, company);
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void verifyCompany(Company company) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _repository.verifyCompany(company);
      var index = _uiState.listCompany.indexWhere(
        (element) => element.id == company.id,
      );
      _uiState.listCompany[index].isVerified = true;
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void addSurvey(Survey survey) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _repository.saveSurvey(survey);
      _uiState.listSurvey.insert(0, survey);
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void addChallenge(Challenge challenge) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _repository.saveChallenge(challenge);
      _uiState.listChallenge.insert(0, challenge);
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void publishChallenge(Challenge challenge) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _repository.publishChallenge(challenge);
      var index = _uiState.listChallenge.indexWhere(
        (element) => element.id == challenge.id,
      );
      _uiState.listChallenge[index].published = true;
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void updateCompany(Company company) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _repository.updateCompany(company);
      var index = _uiState.listCompany
          .indexWhere((element) => element.id == company.id);
      _uiState.listCompany[index] = Company.fromCompany(company);
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void changePageListUser(int index) {
    _uiState.pageOption = PageOption.values.elementAt(index);
    notifyListeners();
  }

  void nextPageListUser(int page) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      if (_listUserPage < page &&
          _uiState.listUser!.pagination.hasNextPage &&
          _uiState.listUser!.pagination.nextPageToken != null) {
        _uiState.listUserNextPageToken =
            _uiState.listUser!.pagination.nextPageToken!;
        var listUser = await _getListUser();
        _uiState.listUser!.pagination = listUser.pagination;
        _uiState.listUser!.users.addAll(listUser.users);
        _listUserPage = _listUserPage + _uiState.listUserPageSize;
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

  void nextPageListCompany(int page) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      if (_listCompanyPage < page && _uiState.lastCompanyName != null) {
        var result = await _repository.getCompanyList(
          _uiState.listCompanyPageSize + 1,
          _uiState.lastCompanyName,
        );

        if (result.isNotEmpty) {
          _uiState.lastCompanyName = result.last.name;
          _uiState.listCompany.addAll(result);
        }

        _listCompanyPage = _listCompanyPage + _uiState.listCompanyPageSize;
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

  void nextPageListSurvey(int page) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      if (_listSurveyPage < page && _uiState.lastSurveyName != null) {
        var result = await _repository.getSurveyList(
          _uiState.listSurveyPageSize + 1,
          _uiState.lastSurveyName,
        );

        if (result.isNotEmpty) {
          _uiState.lastSurveyName = result.last.name;
          _uiState.listSurvey.addAll(result);
        }

        _listSurveyPage += _uiState.listSurveyPageSize;
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

  void nextPageListChallenge(int page) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      if (_listChallengePage < page && _uiState.lastChallengeName != null) {
        var result = await _repository.getChallengeList(
          _uiState.listChallengePageSize + 1,
          _uiState.lastChallengeName,
        );

        if (result.isNotEmpty) {
          _uiState.lastChallengeName = result.last.name;
          _uiState.listChallenge.addAll(result);
        }

        _listChallengePage += _uiState.listChallengePageSize;
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

  void searchUserEmailListUser(String email) {
    _uiState.listUserEmailFilte = email;
    _listUserPage = 0;
    getterListUser();
  }

  void clearSearchCompanyName() {
    getterListCompany();
  }

  void searchCompanyName(String name) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      _uiState.lastCompanyName = null;
      await _getCompanyListNameSearch(name);
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void clearSearchUserEmailListUser() {
    _uiState.listUserEmailFilte = null;
    _listUserPage = 0;
    getterListUser();
  }

  void clearError() {
    _uiState.error = false;
    _uiState.errorMessage = '';
    notifyListeners();
  }

  Future<ListUser> _getListUser() async {
    return await _repository.getListUser(
      _uiState.listUserPageSize,
      _uiState.listUserNextPageToken,
      _uiState.listUserEmailFilte,
    );
  }

  Future<void> _getCompanyList() async {
    var result = await _repository.getCompanyList(
      _uiState.listCompanyPageSize + 1,
      _uiState.lastCompanyName,
    );
    _uiState.listCompany = result;
    if (result.isNotEmpty) {
      _uiState.lastCompanyName = result.last.name;
    }
  }

  Future<void> _getCompanyListNameSearch(String name) async {
    // var result = await _repository.getCompanyListNameSearch(name);
    // _uiState.listCompany = result;
    // if (result.isNotEmpty) {
    //   _uiState.lastCompany = result.last;
    // }
  }

  Future<void> _getSurveyList() async {
    var result = await _repository.getSurveyList(
      _uiState.listSurveyPageSize + 1,
      _uiState.lastSurveyName,
    );
    _uiState.listSurvey = result;
    if (result.isNotEmpty) {
      _uiState.lastSurveyName = result.last.name;
    }
  }

  Future<void> _getChallengeList() async {
    var result = await _repository.getChallengeList(
      _uiState.listChallengePageSize + 1,
      _uiState.lastChallengeName,
    );
    _uiState.listChallenge = result;
    if (result.isNotEmpty) {
      _uiState.lastChallengeName = result.last.name;
    }
  }
}
