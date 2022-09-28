import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/landing/repository.dart';
import 'package:cycletowork/src/ui/landing/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  final bool isAdmin;
  bool _isWatingForGetUserInfo = false;
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  String? displayName;

  ViewModel() : this.instance();

  ViewModel.instance({this.isAdmin = false}) {
    getter();
  }

  getter() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      var isAuthenticated = _repository.isAuthenticated();
      if (isAuthenticated) {
        await _getInitialInfo();
        _uiState.pageOption = PageOption.home;
        _uiState.loading = false;
        notifyListeners();
      } else {
        _uiState.pageOption = PageOption.logout;
        _uiState.loading = false;
        notifyListeners();
      }
      _repository.isAuthenticatedStateChanges().listen((isAuthenticated) async {
        if (!isAuthenticated) {
          _uiState.pageOption = PageOption.logout;
          _uiState.loading = false;
          notifyListeners();
          return;
        }
      });
    } catch (e) {
      try {
        await _repository.logout();
      } catch (_) {}
      _uiState.loading = false;
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      _uiState.pageOption = PageOption.logout;
      notifyListeners();
    }
  }

  void loginApple() async {
    debugPrint('loginApple');
    _uiState.loading = true;
    clearError();
    try {
      await _repository.loginApple();
      var isAuthenticated = _repository.isAuthenticated();
      if (isAuthenticated) {
        await _tryGetUserInfo();
      } else {
        _uiState.loading = false;
        notifyListeners();
      }
    } catch (e) {
      try {
        await _repository.logout();
      } catch (_) {}
      _uiState.loading = false;
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      notifyListeners();
    }
  }

  void loginGoogleSignIn() async {
    debugPrint('loginGoogleSignIn');
    _uiState.loading = true;
    clearError();
    try {
      await _repository.loginGoogleSignIn();
      var isAuthenticated = _repository.isAuthenticated();
      if (isAuthenticated) {
        await _tryGetUserInfo();
      } else {
        _uiState.loading = false;
        notifyListeners();
      }
    } catch (e) {
      try {
        await _repository.logout();
      } catch (_) {}
      _uiState.loading = false;
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      notifyListeners();
    }
  }

  Future<bool> loginEmail(String email, String password) async {
    debugPrint('loginEmail');
    _uiState.loading = true;
    clearError();
    try {
      await _repository.loginEmail(email, password);
      var isAuthenticated = _repository.isAuthenticated();
      if (isAuthenticated) {
        await _tryGetUserInfo();
        return true;
      } else {
        _uiState.loading = false;
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
      } else if (e == 'invalid-email') {
        _uiState.errorMessage =
            "L'email non è valida o contiene i caratteri non accettabile.";
        _uiState.error = true;
      } else {
        _uiState.errorMessage = e.toString();
        Logger.error(e);
        _uiState.error = true;
      }
      try {
        await _repository.logout();
      } catch (_) {}
      _uiState.loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signupEmail(String email, String password, String? name) async {
    debugPrint('signupEmail');
    _uiState.loading = true;
    clearError();
    try {
      displayName = name;
      await _repository.signupEmail(email, password);
      var isAuthenticated = _repository.isAuthenticated();
      if (isAuthenticated) {
        await _tryGetUserInfo();
        return true;
      } else {
        _uiState.loading = false;
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
      } else if (e == 'invalid-email') {
        _uiState.errorMessage =
            "L'email non è valida o contiene i caratteri non accettabile.";
        _uiState.error = true;
      } else {
        _uiState.errorMessage = e.toString();
        Logger.error(e);
        _uiState.error = true;
      }
      try {
        await _repository.logout();
      } catch (_) {}
      _uiState.loading = false;
      notifyListeners();
      return false;
    }
  }

  void gotoLoginEmail() {
    _uiState.pageOption = PageOption.loginEmail;
    clearError();
  }

  void gotoLogout() {
    _uiState.pageOption = PageOption.logout;
    clearError();
  }

  void gotoSignupEmail() {
    _uiState.pageOption = PageOption.signupEmail;
    clearError();
  }

  Future<bool?> passwordReset(String email) async {
    debugPrint('passwordReset');
    clearError();
    try {
      return await _repository.passwordReset(email);
    } catch (e) {
      _uiState.errorMessage = e.toString();
      Logger.error(e);
      _uiState.error = true;
      notifyListeners();
      return false;
    }
  }

  void logout() async {
    debugPrint('logout');
    _uiState.loading = true;
    clearError();
    try {
      await _repository.logout();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.pageOption = PageOption.logout;
      _uiState.loading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _uiState.error = false;
    _uiState.errorMessage = '';
    notifyListeners();
  }

  Future<void> _tryGetUserInfo() async {
    try {
      var userInfoLocal = await _repository.getUserInfoFromLocal();
      if (userInfoLocal != null) {
        await _getInitialInfo();
        _uiState.pageOption = PageOption.home;
        _uiState.loading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      Logger.error(e);
    }

    int _counterTryGetUserInfo = 10;
    _isWatingForGetUserInfo = false;
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_isWatingForGetUserInfo) {
        return;
      }
      _isWatingForGetUserInfo = true;
      try {
        debugPrint('_tryGetUserInfo');
        debugPrint(_counterTryGetUserInfo.toString());
        await _getInitialInfo();
        _uiState.pageOption = PageOption.home;
        _uiState.loading = false;
        timer.cancel();
        _isWatingForGetUserInfo = false;
        notifyListeners();
      } catch (e) {
        if (_counterTryGetUserInfo == 0) {
          try {
            await _repository.logout();
          } catch (_) {}
          Logger.error(e);
          _uiState.pageOption = PageOption.logout;
          timer.cancel();
          notifyListeners();
          _isWatingForGetUserInfo = false;
          _uiState.loading = false;
        }
      } finally {
        _isWatingForGetUserInfo = false;
        _counterTryGetUserInfo--;
      }
    });
  }

  Future<void> _getInitialInfo() async {
    if (isAdmin) {
      var admin = await _repository.isAdmin();
      if (!admin) {
        await _repository.logout();
        throw ('Non Sei un utente admin');
      }
    } else {
      var result = await _repository.getUserInfo();
      if (result == null) {
        await _repository.logout();
        throw ('È stata una anomalia, riprova.');
      }
      AppData.user = result;
      await _repository.saveDeviceToken();
      if (displayName != null && displayName != '') {
        AppData.user!.displayName = displayName;
        await _repository.updateUserDisplayName(displayName!);
        displayName = null;
      }
    }
  }
}
