import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_pushed_messaging/flutter_pushed_messaging.dart';
import 'package:garnetbook/data/models/notificaton/notification_message_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/notification/notification_service.dart';
import 'package:garnetbook/on_main_start.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'firebase_options.dart';
import 'widgets/loaders/loader_overlay.dart';

const platform = MethodChannel('com.example.longlife/googlefit');

@pragma('vm:entry-point')
Future<void> backgroundMessage(Map<dynamic, dynamic> message) async {
  final notificationService = NotificationService();
  final storage = SharedPreferenceData.getInstance();

  String profileId = "";
  final counterService = CounterService();
  await counterService.init(); // Загрузка значения счетчика из памяти
  profileId = await storage.getItem(SharedPreferenceData.clientIdKey);

  var messageData = jsonEncode(message);
  Map<String, dynamic> valueMap = json.decode(messageData.trim());

  if (valueMap != "") {
    NotificationMessageData model = NotificationMessageData.fromJson(valueMap);

    if (model.data != null) {
      Payload newData = model.data!;

      if (newData.userId != null && newData.userId == profileId && newData.text != null) {
        notificationService.showNotification(title: "apple", body: newData.text!);
      }

      if (newData.type == "MESSAGE") {
        if (newData.authorId != profileId && profileId != "") {
          if (newData.text != null && newData.authorDisplayName != null) {
            notificationService.showNotification(title: newData.authorDisplayName!, body: newData.text!);
          }
        }
      } else if (newData.type == "FILE") {
        if (newData.authorId != profileId && profileId != "") {
          if (newData.authorDisplayName != null) {
            notificationService.showNotification(title: newData.authorDisplayName!, body: "Новое сообщение");
          }
        }
      }
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final counterService = CounterService();
  await counterService.init(); // Загрузить значение из памяти

  int currentCount = counterService.counter;
  print('Текущее значение счетчика: $currentCount');

  print('Новое значение счетчика: ${counterService.counter}');
  await Firebase.initializeApp(name: "garnetbool", options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await FlutterPushedMessaging.init(backgroundMessage);
  OnMainStart().main();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/images/logoo.webp'), context);
    precacheImage(const AssetImage('assets/images/background_white.webp'), context);
    precacheImage(const AssetImage('assets/images/ring.webp'), context);

    return GlobalLoaderOverlay(
      overlayColor: Colors.black.withOpacity(0.6),
      useDefaultLoading: false,
      overlayWidgetBuilder: (v) {
        return LoaderOverlayWidget();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1),
            ),
            child: CupertinoApp.router(
              routerDelegate: _appRouter.delegate(),
              routeInformationParser: _appRouter.defaultRouteParser(),
              locale: const Locale('ru', 'RU'),
              supportedLocales: const [Locale('ru', 'RU')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }
}
