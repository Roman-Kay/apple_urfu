import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';


class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._(); // Singleton instance
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool notificationPermission = false;

  FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final iosInitializationSetting = DarwinInitializationSettings();

  //проверка на разрешения получения уведомлений на андроиде
  Future<bool> isAndroidPermissionGranted() async {
    final bool granted = await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() ?? false;
    return granted;
  }

  // запрос разрешения на получение уведомлений
  Future<void> requestPermissions() async {
    PermissionStatus status = await Permission.notification.status;

    if (!status.isGranted) {
      await Permission.notification.request();
    }

    // if (Platform.isAndroid) {
    //
    //
    //   // bool  isGranted = await isAndroidPermissionGranted();
    //   //
    //   // if(isGranted){
    //   //   notificationPermission = isGranted;
    //   // }
    //   // else{
    //   //   final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    //   //   _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    //   //
    //   //   final bool? grantedNotificationPermission = await androidImplementation?.requestNotificationsPermission();
    //   //   notificationPermission = grantedNotificationPermission ?? false;
    //   // }
    // }
    // else{
    //   // for ios
    //
    //   final bool? grantedNotificationPermission =  await _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
    //     alert: true,
    //     badge: true,
    //     sound: true,
    //   );
    //
    //   notificationPermission = grantedNotificationPermission ?? false;
    // }
  }

  // отправка уведомлений
  Future<void> showNotification({
    required String title,
    required String body
}) async {
    requestPermissions();

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
    );

    const iosNotificationDetail = DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosNotificationDetail,
    );

    _notifications.initialize(InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iosInitializationSetting,
    ));

    await _notifications.show(0, title, body, platformChannelSpecifics);
  }

}
