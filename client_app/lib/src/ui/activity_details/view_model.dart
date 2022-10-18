import 'dart:typed_data';

import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/ui/activity_details/repository.dart';
import 'package:cycletowork/src/ui/activity_details/ui_state.dart';
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
      _uiState.listLocationDataUnFiltred =
          await _repository.getListLocationDataUnfiltred(
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

  Future<bool> saveUserActivity() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      final result = await _repository.saveUserActivity(
        _uiState.userActivity!,
      );
      _uiState.loading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      _uiState.loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveUserActivityLocationData() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      debugPrint('userActivityId: ${_uiState.userActivity!.userActivityId}');
      final result = await _repository.saveUserActivityLocationData(
        _uiState.userActivity!,
        _uiState.listLocationData,
        _uiState.listLocationDataUnFiltred,
      );
      _uiState.loading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      _uiState.loading = false;
      notifyListeners();
      return false;
    }
  }

  setUserActivityImageData(Uint8List? value) {
    if (value != null) {
      _repository.setUserActivityImageData(
        _uiState.userActivity!,
        value,
      );
    }
  }
}
