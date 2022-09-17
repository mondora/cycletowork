import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/landing/repository.dart';
import 'package:cycletowork/src/ui/landing/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  final bool isAdmin;
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  String? displayName;

  ViewModel() : this.instance();

  ViewModel.instance({this.isAdmin = false}) {
    getter();
  }

  getter() async {
    _uiState.pageOption = PageOption.loading;
    notifyListeners();
    try {
      var isAuthenticated = _repository.isAuthenticated();
      if (isAuthenticated) {
        await _getInitialInfo();
        _uiState.pageOption = PageOption.home;
        notifyListeners();
      } else {
        _uiState.pageOption = PageOption.logout;
        notifyListeners();
      }
      _repository.isAuthenticatedStateChanges().listen((isAuthenticated) async {
        if (!isAuthenticated) {
          _uiState.pageOption = PageOption.logout;
          notifyListeners();
          return;
        }
      });
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      _uiState.pageOption = PageOption.logout;
      notifyListeners();
    }
  }

  void loginApple() async {
    debugPrint('loginApple');
    _uiState.pageOption = PageOption.loading;
    clearError();
    try {
      await _repository.loginApple();
      var isAuthenticated = _repository.isAuthenticated();
      if (isAuthenticated) {
        Timer(const Duration(seconds: 4), () async {
          try {
            await _getInitialInfo();
            _uiState.pageOption = PageOption.home;
            notifyListeners();
          } catch (e) {
            Logger.error(e);
            _uiState.pageOption = PageOption.logout;
            notifyListeners();
          }
        });
      } else {
        _uiState.pageOption = PageOption.logout;
        notifyListeners();
      }
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      _uiState.pageOption = PageOption.logout;
      notifyListeners();
    }
  }

  void loginGoogleSignIn() async {
    debugPrint('loginGoogleSignIn');
    _uiState.pageOption = PageOption.loading;
    clearError();
    try {
      await _repository.loginGoogleSignIn();
      var isAuthenticated = _repository.isAuthenticated();
      if (isAuthenticated) {
        Timer(const Duration(seconds: 4), () async {
          try {
            await _getInitialInfo();
            _uiState.pageOption = PageOption.home;
            notifyListeners();
          } catch (e) {
            Logger.error(e);
            _uiState.pageOption = PageOption.logout;
            notifyListeners();
          }
        });
      } else {
        _uiState.pageOption = PageOption.logout;
        notifyListeners();
      }
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      _uiState.pageOption = PageOption.logout;
      notifyListeners();
    }
  }

  Future<bool> loginEmail(String email, String password) async {
    debugPrint('loginEmail');
    _uiState.pageOption = PageOption.loading;
    clearError();
    try {
      await _repository.loginEmail(email, password);
      var isAuthenticated = _repository.isAuthenticated();
      if (isAuthenticated) {
        Timer(const Duration(seconds: 4), () async {
          try {
            await _getInitialInfo();
            _uiState.pageOption = PageOption.home;
            notifyListeners();
          } catch (e) {
            Logger.error(e);
            _uiState.pageOption = PageOption.logout;
            notifyListeners();
          }
        });
        return true;
      } else {
        _uiState.pageOption = PageOption.logout;
        notifyListeners();
        return false;
      }
    } catch (e) {
      if (e == 'user-not-found') {
        _uiState.errorMessage = 'Nessun utente trovato per questo email.';
        _uiState.error = true;
      } else if (e == 'wrong-password') {
        _uiState.errorMessage = "Password errata, riprova.";
        _uiState.error = true;
      } else {
        Logger.error(e);
      }

      _uiState.pageOption = PageOption.logout;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signupEmail(String email, String password, String? name) async {
    debugPrint('signupEmail');
    _uiState.pageOption = PageOption.loading;
    clearError();
    try {
      await _repository.signupEmail(email, password, name);
      displayName = name;
      var isAuthenticated = _repository.isAuthenticated();
      if (isAuthenticated) {
        Timer(const Duration(seconds: 4), () async {
          try {
            await _getInitialInfo();
            _uiState.pageOption = PageOption.home;
            notifyListeners();
          } catch (e) {
            Logger.error(e);
            _uiState.pageOption = PageOption.logout;
            notifyListeners();
          }
        });
        return true;
      } else {
        _uiState.pageOption = PageOption.logout;
        notifyListeners();
        return false;
      }
    } catch (e) {
      if (e == 'weak-password') {
        _uiState.errorMessage = 'La password fornita è troppo debole.';
        _uiState.error = true;
      } else if (e == 'email-already-in-use') {
        _uiState.errorMessage = "L'account esiste già per quello email.";
        _uiState.error = true;
      } else {
        Logger.error(e);
      }

      _uiState.pageOption = PageOption.logout;
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    debugPrint('logout');
    _uiState.pageOption = PageOption.loading;
    notifyListeners();
    try {
      await _repository.logout();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.pageOption = PageOption.logout;
      notifyListeners();
    }
  }

  void clearError() {
    _uiState.error = false;
    _uiState.errorMessage = '';
    notifyListeners();
  }

  Future<void> _getInitialInfo() async {
    if (isAdmin) {
      var admin = await _repository.isAdmin();
      if (!admin) {
        await _repository.logout();
        throw ('Non Sei un utente admin');
      }
    } else {
      AppData.user = await _repository.getUserInfo();
      await _repository.saveDeviceToken();
      if (displayName != null && displayName != '') {
        AppData.user!.displayName = displayName;
      }
    }
  }
}
