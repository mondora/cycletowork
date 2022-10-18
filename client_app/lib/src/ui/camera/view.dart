import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/ui/camera/ui_state.dart';
import 'package:cycletowork/src/ui/camera/view_model.dart';
import 'package:cycletowork/src/widget/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    var scale = context.read<AppData>().scale;

    return ChangeNotifierProvider<ViewModel>(
      create: (_) => ViewModel.instance(),
      child: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
          var textTheme = Theme.of(context).textTheme;
          var colorScheme = Theme.of(context).colorScheme;

          if (viewModel.uiState.error) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                      SnackBar(
                        backgroundColor: colorScheme.error,
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: colorScheme.onError,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                viewModel.uiState.errorMessage.toUpperCase(),
                                style: textTheme.caption!.apply(
                                  color: colorScheme.onError,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .closed
                    .then((value) => viewModel.clearError());
              },
            );
          }

          if (viewModel.uiState.loading || viewModel.controller == null) {
            return const Scaffold(
              body: Center(
                child: AppProgressIndicator(),
              ),
            );
          }

          if (viewModel.uiState.imagePath != null) {
            return Scaffold(
              body: SafeArea(
                child: Container(
                  color: Colors.black,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(viewModel.uiState.imagePath!),
                      ),
                      Positioned(
                        top: 50.0 * scale,
                        right: 0,
                        left: 0,
                        child: Image.asset(
                          'assets/images/camera_image_filter.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: Container(
                          height: 100.0 * scale,
                          padding: EdgeInsets.only(
                            top: 20 * scale,
                          ),
                          color: Colors.black,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(16.0 * scale),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0 * scale),
                                    ),
                                  ),
                                  foregroundColor: colorScheme.onSecondary,
                                ),
                                onPressed: viewModel.clearPhoto,
                                child: Text(
                                  'Scatta di nuovo',
                                  style: textTheme.bodyText1!.copyWith(
                                    color: colorScheme.onSecondary,
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(16.0 * scale),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0 * scale),
                                    ),
                                  ),
                                  foregroundColor: colorScheme.onSecondary,
                                ),
                                onPressed: () => Navigator.pop(
                                  context,
                                  viewModel.uiState.imagePath,
                                ),
                                child: Text(
                                  'Usa foto',
                                  style: textTheme.bodyText1!.copyWith(
                                    color: colorScheme.onSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            body: SafeArea(
              child: Container(
                color: Colors.black,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(viewModel.controller!),
                    Positioned(
                      top: 50 * scale,
                      right: 0,
                      left: 0,
                      child: Image.asset(
                        'assets/images/camera_filter.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        color: Colors.black,
                        alignment: Alignment.centerLeft,
                        height: 50 * scale,
                        padding: EdgeInsets.only(left: 17.0 * scale),
                        child: Container(
                          height: 40.0 * scale,
                          width: 50.0 * scale,
                          padding: EdgeInsets.only(right: 4.0 * scale),
                          color: Colors.transparent,
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0 * scale),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10.0 * scale),
                              onTap: () => viewModel.toggleFlashCamera(),
                              child: Icon(
                                _getFlashIcon(viewModel.uiState.flashCamera),
                                size: 25 * scale,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.black,
                        height: 120 * scale,
                        width: 66 * scale,
                        padding: EdgeInsets.only(
                          top: 34 * scale,
                          bottom: 20.0 * scale,
                        ),
                        child: FittedBox(
                          child: FloatingActionButton(
                            backgroundColor: colorScheme.primary,
                            onPressed: () async {
                              await viewModel.takePicture();
                            },
                            child: CircleAvatar(
                              radius: 66 * scale / 2 - 10,
                              backgroundColor: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundColor: colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 20 * scale,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(16.0 * scale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0 * scale),
                                ),
                              ),
                              foregroundColor: colorScheme.onSecondary,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Annulla',
                              style: textTheme.bodyText1!.copyWith(
                                color: colorScheme.onSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(16.0 * scale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0 * scale),
                                ),
                              ),
                              foregroundColor: colorScheme.onSecondary,
                            ),
                            onPressed: viewModel.uiState.listCamera.length < 2
                                ? null
                                : viewModel.toggleCamera,
                            child: Icon(
                              Icons.flip_camera_ios_outlined,
                              size: 30.0 * scale,
                              color: viewModel.uiState.listCamera.length < 2
                                  ? Colors.grey
                                  : colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            extendBody: true,
          );
        },
      ),
    );
  }

  IconData _getFlashIcon(FlashCamera flashCamera) {
    switch (flashCamera) {
      case FlashCamera.off:
        return Icons.flash_off_outlined;
      case FlashCamera.on:
        return Icons.flash_on_outlined;
      case FlashCamera.auto:
        return Icons.flash_auto_outlined;
    }
  }
}
