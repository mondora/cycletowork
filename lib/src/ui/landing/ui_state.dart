enum PageOption {
  loading,
  logout,
  login,
  home,
}

class UiState {
  bool error = false;
  String errorMessage = '';
  PageOption pageOption = PageOption.loading;
}
