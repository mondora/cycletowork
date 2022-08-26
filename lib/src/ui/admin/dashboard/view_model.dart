import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/ui/admin/dashboard/repository.dart';
import 'package:cycletowork/src/ui/admin/dashboard/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  int _listUserPage = 0;
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
      if (_uiState.pageOption == PageOption.user) {
        _uiState.listUserNextPageToken = null;
        _uiState.listUser = await _getListUser();
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

  void changePage(int index) {
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

  void searchUserEmailListUser(String email) {
    _uiState.listUserEmailFilte = email;
    _listUserPage = 0;
    getter();
  }

  void clearSearchUserEmailListUser() {
    _uiState.listUserEmailFilte = null;
    _listUserPage = 0;
    getter();
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
}
