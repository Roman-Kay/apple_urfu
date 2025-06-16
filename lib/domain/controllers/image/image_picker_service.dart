import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garnetbook/domain/interactor/permission_handler.dart';
import 'package:image_picker/image_picker.dart';


class ImagePickerService {
  Future<PickedFile> pickImage(ImageSource image) async {
    final xFileSource = await ImagePicker().pickImage(source: image);
    return PickedFile(xFileSource!.path);
  }

  Future<File?> chooseImageFileCamera() async {
    try {
      final bool cameraStatus = Platform.isIOS ? true : await GetPermissions.getCameraPermission();
      if (cameraStatus) {
        final _image = ImagePicker();
        final file = await _image.pickImage(source: ImageSource.camera);

        if (file != null) {
          File selected = File(file.path);
          return selected;
        } else {
          return null;
        }
      }
    } catch (error) {
      debugPrint("Error in image picker service ... $error");
    }
    return null;
  }

  Future<File?> chooseImageFileGallery() async {
    try {
      final bool cameraStatus = await GetPermissions.getStoragePermission();
      if (cameraStatus) {
        final _image = ImagePicker();
        final file = await _image.pickImage(source: ImageSource.gallery);

        if (file != null) {
          File selected = File(file.path);
          return selected;
        } else {
          return null;
        }
      }

    } catch (error) {
      debugPrint("Error in image picker service ... $error");
    }
    return null;
  }
}
