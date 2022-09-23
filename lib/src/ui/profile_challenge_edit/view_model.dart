import 'package:cycletowork/src/data/challenge.dart';
import 'package:cycletowork/src/ui/profile_challenge_edit/repository.dart';
import 'package:cycletowork/src/ui/profile_challenge_edit/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  ViewModel() : this.instance();

  ViewModel.instance();

  Future<bool?> updateUserInfoInChallenge(
    ChallengeRegistry challengeRegistry,
  ) async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var result =
          await _repository.updateUserInfoInChallenge(challengeRegistry);
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
