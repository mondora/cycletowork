import 'package:cycletowork/src/ui/profile_change_password/repository.dart';
import 'package:cycletowork/src/ui/profile_change_password/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  ViewModel() : this.instance();

  ViewModel.instance();

  changePasswordForEmail(
    String currentPassword,
    String newPassword,
  ) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var result = await _repository.changePasswordForEmail(
        currentPassword,
        newPassword,
      );
      _uiState.loading = false;
      notifyListeners();
      return result;
    } catch (e) {
      if (e == 'wrong-password') {
        _uiState.errorMessage = "Password attuale non è valida, riprova.";
      } else {
        _uiState.errorMessage = e.toString();
        Logger.error(e);
      }

      _uiState.error = true;
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
