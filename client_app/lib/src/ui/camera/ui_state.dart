import 'package:camera/camera.dart';

enum FlashCamera {
  off,
  on,
  auto,
}

class UiState {
  bool loading = false;
  bool error = false;
  String errorMessage = '';
  FlashCamera flashCamera = FlashCamera.off;
  List<CameraDescription> listCamera = [];
  String? imagePath;
}
