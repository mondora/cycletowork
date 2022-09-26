enum PageOption {
  logout,
  login,
  loginEmail,
  signupEmail,
  home,
}

class UiState {
  bool loading = true;
  bool error = false;
  String errorMessage = '';
  PageOption pageOption = PageOption.logout;
}
