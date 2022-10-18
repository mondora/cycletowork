import 'package:camera/camera.dart';
import 'package:cycletowork/src/ui/camera/ui_state.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/material.dart';

class ViewModel extends ChangeNotifier {
  int cameraIndex = 0;
  final _uiState = UiState();
  UiState get uiState => _uiState;

  CameraController? _controller;
  CameraController? get controller => _controller;

  ViewModel() : this.instance();

  ViewModel.instance() {
    getter();
  }

  getter() async {
    _uiState.loading = true;
    notifyListeners();
    try {
      final cameras = await availableCameras();
      _uiState.listCamera = cameras;
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller!.initialize();
      await _controller!.setFlashMode(FlashMode.off);
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          case 'CameraAccessDeniedWithoutPrompt':
            _uiState.errorMessage =
                "È necessario acconsentire all'utilizzo della fotocamera";
            _uiState.error = true;
            return;
          default:
            _uiState.errorMessage = e.toString();
            break;
        }
      } else {
        _uiState.errorMessage = e.toString();
      }

      _uiState.error = true;
      Logger.error(e);
    } finally {
      _uiState.loading = false;
      notifyListeners();
    }
  }

  toggleFlashCamera() async {
    FlashCamera newFlashCamera;
    switch (_uiState.flashCamera) {
      case FlashCamera.off:
        newFlashCamera = FlashCamera.on;
        if (cameraIndex == 0) {
          await _controller?.setFlashMode(FlashMode.torch);
        } else {
          await _controller?.setFlashMode(FlashMode.always);
        }
        break;
      case FlashCamera.on:
        newFlashCamera = FlashCamera.auto;
        await _controller?.setFlashMode(FlashMode.auto);
        break;
      case FlashCamera.auto:
        newFlashCamera = FlashCamera.off;
        await _controller?.setFlashMode(FlashMode.off);
        break;
    }
    _uiState.flashCamera = newFlashCamera;
    notifyListeners();
  }

  toggleCamera() async {
    cameraIndex++;
    if (cameraIndex + 1 > _uiState.listCamera.length) {
      cameraIndex = 0;
    }

    _controller = CameraController(
      _uiState.listCamera[cameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller!.initialize();

    switch (_uiState.flashCamera) {
      case FlashCamera.off:
        await _controller?.setFlashMode(FlashMode.off);
        break;
      case FlashCamera.on:
        if (cameraIndex == 0) {
          await _controller?.setFlashMode(FlashMode.torch);
        } else {
          await _controller?.setFlashMode(FlashMode.always);
        }

        break;
      case FlashCamera.auto:
        await _controller?.setFlashMode(FlashMode.auto);
        break;
    }
    notifyListeners();
  }

  Future<void> takePicture() async {
    try {
      if (_controller != null) {
        final image = await _controller!.takePicture();
        _uiState.imagePath = image.path;

        notifyListeners();
      }
    } catch (e) {
      _uiState.errorMessage = e.toString();
      _uiState.error = true;
      Logger.error(e);
      notifyListeners();
    }
  }

  clearPhoto() {
    _uiState.imagePath = null;
    notifyListeners();
  }

  void clearError() {
    _uiState.error = false;
    _uiState.errorMessage = '';
    notifyListeners();
  }
}
