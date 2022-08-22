import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/landing/repository.dart';
import 'package:cycletowork/src/ui/landing/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

//   void loginEmail(String email, String password, String? name) async {
//     debugPrint('login');
//     // AppData.user = User(
//     //   userType: UserType.other,
//     //   email: 'claudia.rossi@aria.it',
//     //   displayName: 'Claudia Rossi',
//     //   imageUrl:
//     //       null, // 'https://lh3.googleusercontent.com/ogw/AOh-ky0d1LLWqZxcF0Tik6VqijGavwOmRza931h8nnm5bg',
//     // );
//     // _status = LandingViewModelStatus.home;
//     // notifyListeners();

//     // _status = LandingViewModelStatus.loading;
//     // notifyListeners();
//     // try {
//     //   var result = await UserAuth.loginEmail(email, password);
//     //   if (result ?? false) {
//     //     _status = LandingViewModelStatus.login;
//     //     notifyListeners();
//     //     return;
//     //   } else {
//     //     _status = LandingViewModelStatus.logout;
//     //     notifyListeners();
//     //     return;
//     //   }
//     // } catch (e) {
//     //   _errorMessage = e.toString();
//     //   _status = LandingViewModelStatus.error;
//     //   notifyListeners();
//     //   return;
//     // }
//   }

class ViewModel extends ChangeNotifier {
  final _repository = Repository();

  final _uiState = UiState();
  UiState get uiState => _uiState;

  ViewModel() : this.instance();

  ViewModel.instance() {
    getter();
  }

  getter() async {
    _uiState.pageOption = PageOption.loading;
    notifyListeners();
    try {
      var isAuthenticated = await _repository.isAuthenticated();
      if (isAuthenticated) {
        await _repository.saveDeviceToken();
        // AppData.user = await _repository.getUserInfo();
        _uiState.pageOption = PageOption.home;
        notifyListeners();
      } else {
        _uiState.pageOption = PageOption.logout;
        notifyListeners();
      }
      _repository.isAuthenticatedStateChanges().listen((isAuthenticated) async {
        if (isAuthenticated) {
          await _repository.saveDeviceToken();
          if (_uiState.pageOption != PageOption.home) {
            _uiState.pageOption = PageOption.home;
            notifyListeners();
            return;
          }
        } else {
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

  void loginGoogleSignIn() async {
    debugPrint('loginGoogleSignIn');
    _uiState.pageOption = PageOption.loading;
    notifyListeners();
    try {
      await _repository.loginGoogleSignIn();
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      _uiState.pageOption = PageOption.logout;
      notifyListeners();
    }
  }

  void loginEmail(
    String email,
    String password,
    String? name,
  ) async {
    debugPrint('loginEmail');
  }

  signupEmail() async {
    debugPrint('signupEmail');
    _uiState.pageOption = PageOption.loading;
    notifyListeners();
    try {} catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.pageOption = PageOption.signup;
      notifyListeners();
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
}
