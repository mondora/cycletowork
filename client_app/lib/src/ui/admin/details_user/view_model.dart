import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/ui/admin/details_user/repository.dart';
import 'package:cycletowork/src/ui/admin/details_user/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  final User _user;
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  ViewModel(User user) : this.instance(user);

  ViewModel.instance(this._user) {
    _uiState.userInfo = _user;
    getter();
  }

  getter() async {
    _uiState.loading = true;
    notifyListeners();
    try {} catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void verifyUser() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _repository.verifyUser(_user.uid);
      _uiState.userInfo!.verified = true;
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void setAdminUser() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _repository.setAdminUser(_user.uid);
      _uiState.userInfo!.admin = true;
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void saveUserActivityAdmin(UserActivity userActivity) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      await _repository.saveUserActivityAdmin(userActivity);
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _uiState.error = false;
    _uiState.errorMessage = '';
    notifyListeners();
  }
}
