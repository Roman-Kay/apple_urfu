import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/domain/interactor/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class PdfFileController{

  Future<ImageView?> pickPdfFile() async {

    final bool storageStatus = await GetPermissions.getStoragePermission();

    if(storageStatus){
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final bytes = File(result.files.single.path!).readAsBytesSync();
        String file64= base64Encode(bytes);
        String fileName = result.files.first.name;

        return ImageView(
            format: "pdf",
            base64: file64,
            name: fileName
        );
      }
    }
    return null;
  }


  Future<String> createFileFromString(String encodedStr) async {
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await file.writeAsBytes(bytes);
    return file.path;
  }
}