import 'package:cycletowork/src/ui/personal_data_management/repository.dart';
import 'package:cycletowork/src/ui/personal_data_management/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  ViewModel() : this.instance();

  ViewModel.instance();

  Future<bool?> deleteAccount() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var result = await _repository.deleteAccount();
      _uiState.loading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _uiState.errorMessage = e.toString();
      Logger.error(e);
      _uiState.error = true;
      _uiState.loading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _uiState.error = false;
    _uiState.errorMessage = '';
    notifyListeners();
  }
}
