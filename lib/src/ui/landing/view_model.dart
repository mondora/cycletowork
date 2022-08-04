import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:flutter/material.dart';

import '../../utility/user_auth.dart';

enum LandingViewModelStatus {
  loading,
  logout,
  login,
  signup,
  home,
  error,
}

class LandingViewModel extends ChangeNotifier {
  LandingViewModelStatus _status = LandingViewModelStatus.loading;
  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  LandingViewModelStatus get status => _status;

  LandingViewModel() : this.instance();

  LandingViewModel.instance() {
    getter();
  }

  void getter() async {
    _status = LandingViewModelStatus.loading;
    notifyListeners();
    try {
      UserAuth.isAuthenticated().listen((isAuthenticated) async {
        if (isAuthenticated) {
          _status = LandingViewModelStatus.login;
          notifyListeners();
          return;
        } else {
          _status = LandingViewModelStatus.logout;
          notifyListeners();
          return;
        }
      });
      Timer(const Duration(seconds: 3), () {
        if (_status == LandingViewModelStatus.loading) {
          _status = LandingViewModelStatus.logout;
          notifyListeners();
        }
      });
    } catch (e) {
      _errorMessage = e.toString();
      _status = LandingViewModelStatus.logout;
      notifyListeners();
      return;
    }
  }

  void loginEmail(String email, String password, String? name) async {
    debugPrint('login');
    AppData.user = User(
      userType: UserType.other,
      email: 'claudia.rossi@aria.it',
      displayName: 'Claudia Rossi',
      imageUrl:
          null, // 'https://lh3.googleusercontent.com/ogw/AOh-ky0d1LLWqZxcF0Tik6VqijGavwOmRza931h8nnm5bg',
    );
    _status = LandingViewModelStatus.home;
    notifyListeners();
    // _status = LandingViewModelStatus.loading;
    // notifyListeners();
    // try {
    //   var result = await UserAuth.loginEmail(email, password);
    //   if (result ?? false) {
    //     _status = LandingViewModelStatus.login;
    //     notifyListeners();
    //     return;
    //   } else {
    //     _status = LandingViewModelStatus.logout;
    //     notifyListeners();
    //     return;
    //   }
    // } catch (e) {
    //   _errorMessage = e.toString();
    //   _status = LandingViewModelStatus.error;
    //   notifyListeners();
    //   return;
    // }
  }

  void signupEmail() async {
    debugPrint('signupEmail');
    _status = LandingViewModelStatus.signup;
    notifyListeners();
    return;
  }

  void logout() async {
    debugPrint('logout');
    _status = LandingViewModelStatus.loading;
    notifyListeners();
    try {
      await UserAuth.logout();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _status = LandingViewModelStatus.logout;
    notifyListeners();
    return;
  }

  void clearError() {
    _status = LandingViewModelStatus.logout;
    _errorMessage = '';
    notifyListeners();
  }
}
