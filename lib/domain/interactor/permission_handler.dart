
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class GetPermissions{
  static Future<bool> getCameraPermission() async{
    PermissionStatus permissionStatus = await Permission.camera.status;

    if(permissionStatus.isGranted){
      return true;
    }
    else if(permissionStatus.isDenied){
      PermissionStatus status = await Permission.camera.request();
      if(status.isGranted){
        return true;
      }else{
        return false;
      }
    }
    return false;
  }

  static Future<bool> getStoragePermission() async{
    PermissionStatus? permissionStatus;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permissionStatus = await Permission.storage.request();
      }
      else {
        permissionStatus = await Permission.photos.request();
      }
    }
    else{
      permissionStatus = await Permission.storage.request();
    }


    if(permissionStatus.isGranted){
      return true;
    }
    else if(permissionStatus.isDenied){
      PermissionStatus status = await Permission.storage.request();
      if(status.isGranted){
       return true;
      }else{
        return false;
      }
    }
    return false;
  }
}