enum PageOption {
  loading,
  logout,
  login,
  signup,
  home,
}

class UiState {
  bool error = false;
  String errorMessage = '';
  PageOption pageOption = PageOption.loading;
}
