import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/ui/tracking_details/repository.dart';
import 'package:cycletowork/src/ui/tracking_details/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  ViewModel(UserActivity userActivity) : this.instance(userActivity);

  ViewModel.instance(
    UserActivity userActivity,
  ) {
    _uiState.userActivity = userActivity;
    getter();
  }

  getter() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var userActivityId = _uiState.userActivity!.userActivityId;
      _uiState.listLocationData = await _repository.getListLocationData(
        userActivityId,
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
}
