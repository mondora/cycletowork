import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class Storage {
  static Future<String> saveImageInStorage(
    String imagePath,
    String fileName, {
    bool compressedFile = true,
    int compressedQuality = 50,
    int targetSize = 200,
    Map<String, String>? customMetadata,
  }) async {
    File file;
    if (compressedFile) {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(imagePath);
      file = await FlutterNativeImage.compressImage(imagePath,
          quality: compressedQuality,
          targetWidth: targetSize,
          targetHeight:
              (properties.height! * targetSize / properties.width!).round());
    } else {
      file = File(imagePath);
    }

    final storageRef = FirebaseStorage.instance.ref();
    final mountainImagesRef = storageRef.child('images/$fileName');

    SettableMetadata? metadata;
    if (customMetadata != null) {
      metadata = SettableMetadata(
        customMetadata: customMetadata,
      );
    }

    var uploadTask = await mountainImagesRef.putFile(file, metadata);
    var url = await uploadTask.ref.getDownloadURL();
    return url;
  }
}
