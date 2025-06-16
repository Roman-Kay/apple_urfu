// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pushed_messaging/flutter_pushed_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/message/push/push_cubit.dart';
import 'package:garnetbook/data/models/notificaton/notification_message_model.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/message/message_service.dart';
import 'package:garnetbook/bloc/message/chat/chat_bloc/chat_bloc.dart';
import 'package:garnetbook/bloc/message/chat/list_chat_cubit/list_chat_cubit.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/notification/notification_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class BottomNavigationBarClientPage extends StatefulWidget {
  int startPageIndex;
  BottomNavigationBarClientPage({super.key, this.startPageIndex = 2});

  @override
  State<BottomNavigationBarClientPage> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarClientPage> {
  int pageIndex = -1;
  String clientId = "";
  String secret = "";
  final notificationService = NotificationService();
  final storage = SharedPreferenceData.getInstance();
  String _token = "";

  late final AppLifecycleListener lifecycleListener;
  Timer? forceDetachTimer;
  bool isMessageIsUnread = false;
  bool isFromNotification = false;

  final List<PageRouteInfo> pages = [
    ClientMainContainerRoute(),
    ClientCalendarContainerRoute(),
    ClientMyDayContainerRoute(),
    ClientMessagesContainerRoute(),
    ClientProfileRoute(),
  ];

  @override
  void initState() {
    super.initState();
    lifecycleListener = AppLifecycleListener(onStateChange: onAppStateChanged);
    initPlatformState();
    notificationService.requestPermissions();
    getSecretForNotificationService();

    if (Platform.isAndroid) {
      GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.androidUser);
    } else {
      GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.iosUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListChatCubit, ListChatState>(builder: (context, messageState) {
      return BlocBuilder<PushCubit, PushState>(builder: (context, pushState) {
        if (messageState is ListChatLoadedState) {
          checkNotificationIsUnread(messageState, pushState);
        }
        if (pushState is PushLoadedState) {
          checkNotificationIsUnread(messageState, pushState);
        }

        return AutoTabsRouter(
            routes: pages,
            builder: (context, child) {
              final tabsRouter = AutoTabsRouter.of(context);
              return Scaffold(
                body: child,
                bottomNavigationBar: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    boldText: false,
                    textScaler: TextScaler.linear(1),
                  ),
                  child: CupertinoTabBar(
                    height: 53,
                    activeColor: AppColors.vivaMagentaColor,
                    backgroundColor: AppColors.basicwhiteColor,
                    items: [
                      bottomNavigationBarItem(
                        imageName: 'assets/images/home.svg',
                        label: 'Главная',
                        pageIndex: pageIndex == -1 ? widget.startPageIndex : pageIndex,
                        itemIndex: 0,
                        context: context,
                      ),
                      bottomNavigationBarItem(
                        imageName: 'assets/images/calendar.svg',
                        label: 'Календарь',
                        pageIndex: pageIndex == -1 ? widget.startPageIndex : pageIndex,
                        itemIndex: 1,
                        context: context,
                      ),
                      bottomNavigationBarItem(
                        imageName: 'assets/images/logoo.webp',
                        label: null,
                        pageIndex: pageIndex == -1 ? widget.startPageIndex : pageIndex,
                        itemIndex: 2,
                        context: context,
                      ),
                      bottomNavigationBarItem(
                          imageName: 'assets/images/messages.svg',
                          label: 'Сообщения',
                          pageIndex: pageIndex == -1 ? widget.startPageIndex : pageIndex,
                          itemIndex: 3,
                          context: context,
                          isUnreadIcon: isMessageIsUnread),
                      bottomNavigationBarItem(
                        imageName: 'assets/images/profile.svg',
                        label: 'Профиль',
                        pageIndex: pageIndex == -1 ? widget.startPageIndex : pageIndex,
                        itemIndex: 4,
                        context: context,
                      ),
                    ],
                    currentIndex: tabsRouter.activeIndex,
                    onTap: (index) {
                      if (tabsRouter.activeIndex == index) {
                        context.navigateTo(BottomNavigationBarClientRoute(children: [pages[index]]));
                      } else {
                        tabsRouter.setActiveIndex(index);
                      }
                    },
                  ),
                ),
              );
            });
      });
    });
  }

  checkNotificationIsUnread(messageState, pushState) {
    if (messageState is ListChatLoadedState) {
      if (messageState.list != null && messageState.list!.isNotEmpty) {
        for (var element in messageState.list!) {
          if (element.lastMessageTimestamp != null &&
              element.lastMessageTimestamp != 0 &&
              element.users!.length > 1 &&
              element.lastMessage != null &&
              element.lastMessage?.readed == false) {
            isMessageIsUnread = true;
            return;
          }
        }
      }
    }

    if (pushState is PushLoadedState) {
      if (pushState.view != null && pushState.view?.list != null && pushState.view!.list!.isNotEmpty) {
        for (var element in pushState.view!.list!) {
          if (element.readed == false && element.authorId != element.userId) {
            isMessageIsUnread = true;
            isFromNotification = true;
            return;
          }
        }
      }
    }
    isMessageIsUnread = false;
    isFromNotification = false;
  }

  // прослушка сообщений/уведомлений; получение токена от стороннего сервера
  Future<void> initPlatformState() async {
    FlutterPushedMessaging.onMessage().listen((message) {
      debugPrint("MY MESSAGE IS >>>>>>>>>>>>>>>>>>> $message");

      var newdata = jsonEncode(message);
      Map<String, dynamic> valueMap = json.decode(newdata.trim());

      if (valueMap != "") {
        onData(valueMap);
      }
    });

    if (!mounted) return;

    setState(() {
      _token = FlutterPushedMessaging.token ?? "";
    });

    if (_token != "") {
      await storage.setItem(SharedPreferenceData.pushedToken, _token);
    }
  }

  // отправка данных/регистрация на стороннем сервере; получение secret
  Future<void> getSecretForNotificationService() async {
    final service = MessageService();

    debugPrint("TOKEN FROM NOTIFICATION PLUGIN >>>>>>> $_token");

    final clientIdTest = await storage.getItem(SharedPreferenceData.clientIdKey);
    setState(() {
      clientId = clientIdTest;
    });

    if (_token != "") {
      await service.createUser(_token);
    }
  }

  // сортировка/отображение пушей/ автообновление страниц
  Future<void> onData(data) async {
    NotificationMessageData model = NotificationMessageData.fromJson(data);

    if (model.data != null) {
      Payload newData = model.data!;

      if (newData.userId != null && newData.userId == clientId && newData.text != null) {
        notificationService.showNotification(title: "Garnetbook", body: newData.text!);
        BlocProvider.of<PushCubit>(context).check();
      }

      if (newData.type == "MESSAGE") {
        if (newData.authorId != clientId && newData.chatId != null) {
          BlocProvider.of<ListChatCubit>(context).getChat();
          BlocProvider.of<ChatBloc>(context).add(ChatGetEvent(chatId: newData.chatId!, pageKey: 0));

          if (newData.text != null && newData.authorDisplayName != null) {
            notificationService.showNotification(title: newData.authorDisplayName!, body: newData.text!);
          }
        }
      } else if (newData.type == "FILE") {
        if (newData.authorId != clientId && newData.chatId != null) {
          BlocProvider.of<ListChatCubit>(context).getChat();
          BlocProvider.of<ChatBloc>(context).add(ChatGetEvent(chatId: newData.chatId!, pageKey: 0));

          if (newData.authorDisplayName != null) {
            notificationService.showNotification(title: newData.authorDisplayName!, body: "Новое сообщение");
          }
        }
      }
    }
  }

  void forceDetachApp() {
    debugPrint(">>>>>>>>>>>>>>. CLOSE APP");
    forceDetachTimer = null;
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    if (Platform.isIOS) {
      exit(0);
    }
  }

  void onAppStateChanged(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      debugPrint(">>>>>>>....... TIMER START");
      forceDetachTimer = Timer(Duration(minutes: 10), forceDetachApp);
    } else {
      debugPrint(">>>>>>>>>>>>>> TIMER CANCEL");
      forceDetachTimer?.cancel();
      forceDetachTimer = null;
    }
  }

  BottomNavigationBarItem bottomNavigationBarItem({
    required String imageName,
    required String? label,
    required int pageIndex,
    required int itemIndex,
    required BuildContext context,
    bool isUnreadIcon = false,
  }) {
    return BottomNavigationBarItem(
      activeIcon: Padding(
        padding: label == null ? EdgeInsets.zero : EdgeInsets.only(bottom: 2.h, top: 3),
        child: label == null
            ? Image.asset(
                imageName,
                height: 42.h,
                width: 42.w,
              )
            : Stack(
                children: [
                  SvgPicture.asset(
                    imageName,
                    width: 23.w,
                    height: 25.h,
                    color: AppColors.vivaMagentaColor,
                  ),
                  if (isUnreadIcon)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.basicwhiteColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        width: 11,
                        height: 11,
                      ),
                    ),
                  if (isUnreadIcon)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.redColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        width: 9,
                        height: 9,
                      ),
                    ),
                ],
              ),
      ),
      icon: Padding(
        padding: label == null ? EdgeInsets.zero : EdgeInsets.only(bottom: 2.h, top: 3),
        child: label == null
            ? Image.asset(
                imageName,
                height: 42.h,
                width: 42.w,
              )
            : Stack(
                children: [
                  SvgPicture.asset(
                    imageName,
                    width: 23.w,
                    height: 25.h,
                    color: Color(0xFFC1C7CD),
                  ),
                  if (isUnreadIcon)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.basicwhiteColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        width: 11,
                        height: 11,
                      ),
                    ),
                  if (isUnreadIcon)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.redColor,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        width: 9,
                        height: 9,
                      ),
                    ),
                ],
              ),
      ),
      label: label,
    );
  }
}
