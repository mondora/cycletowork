import 'package:cycletowork/src/data/user_activity.dart';
import 'package:cycletowork/src/ui/details_tracking/repository.dart';
import 'package:cycletowork/src/ui/details_tracking/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  final _repository = Repository();
  BuildContext _context;

  final _uiState = UiState();
  UiState get uiState => _uiState;

  ViewModel(BuildContext context, UserActivity userActivity)
      : this.instance(context, userActivity);

  ViewModel.instance(
    this._context,
    UserActivity userActivity,
  ) {
    _uiState.userActivity = userActivity;
    getter();
  }

  getter() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var userActivityId = _uiState.userActivity!.userActivityId!;
      _uiState.listLocationData = await _repository.getListLocationData(
        userActivityId,
      );
      if (_uiState.listLocationData.isNotEmpty) {
        var firstLocation = _uiState.listLocationData.first;
        var localeIdentifier = Localizations.localeOf(_context).languageCode;
        _uiState.city = await _repository.getCityNameFromLocation(
          firstLocation,
          localeIdentifier: localeIdentifier,
        );
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
}
