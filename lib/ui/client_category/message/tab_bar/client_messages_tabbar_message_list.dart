import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/my_expert/my_expert_cubit.dart';
import 'package:garnetbook/bloc/message/chat/chat_bloc/chat_bloc.dart';
import 'package:garnetbook/bloc/message/chat/list_chat_cubit/list_chat_cubit.dart';
import 'package:garnetbook/data/models/message/message_chat_models/list_chat_models.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:intl/intl.dart';

class ClientMessagesTabBarMessageList extends StatefulWidget {
  const ClientMessagesTabBarMessageList({super.key});

  @override
  State<ClientMessagesTabBarMessageList> createState() => _ClientMessagesTabBarMessageListState();
}

class _ClientMessagesTabBarMessageListState extends State<ClientMessagesTabBarMessageList> with AutomaticKeepAliveClientMixin {
  String myUserId = "";
  final storage = SharedPreferenceData.getInstance();
  Map<int, FileView?> userList = {};

  List<MessageChatModel> list = [];
  List<int> contactList = [];

  @override
  void initState() {
    getUserId();
    if(BlocProvider.of<MyExpertCubit>(context).state is MyExpertLoadedState){}else{
      context.read<MyExpertCubit>().check();
    }

    if(BlocProvider.of<ListChatCubit>(context).state is ListChatLoadedState){}else{
      context.read<ListChatCubit>().check();
    }
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: AppColors.darkGreenColor,
      onRefresh: () {
        context.read<ListChatCubit>().check();
        getUserId();
        if(BlocProvider.of<MyExpertCubit>(context).state is MyExpertLoadedState){}else{
          context.read<MyExpertCubit>().check();
        }
        return Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 20.h),
          SizedBox(
            height: 64.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Все сообщения',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                  Container(
                    width: 48.h,
                    height: 42.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: AppColors.darkGreenColor,
                    ),
                    child: FormForButton(
                      borderRadius: BorderRadius.circular(4.r),
                      onPressed: () {
                        context.read<ChatBloc>().add(ChatDisposeEvent());
                        context.router.push(ClientMessageNewMessageRoute(listOfUsers: contactList));
                      },
                      child: SvgPicture.asset(
                        'assets/images/add.svg',
                        height: 18.h,
                        width: 18.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          BlocBuilder<MyExpertCubit, MyExpertState>(
            builder: (context, userState) {
              return BlocBuilder<ListChatCubit, ListChatState>(builder: (context, state) {
                if (state is ListChatLoadedState) {
                  getMyExpertList(userState);
                  check(state.list);

                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      reverse: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final chat = list[index];
                        final isChatUnread =
                            chat.lastMessage?.authorId != myUserId && chat.lastMessage?.authorId != null && chat.lastMessage?.readed == false
                                ? true
                                : false;
                        int expertId = getExpertId(chat);

                        return Padding(
                          padding: EdgeInsets.only(
                            left: 14.w,
                            right: 14.w,
                            bottom: 12.h,
                          ),
                          child: Stack(
                            children: [
                              isChatUnread
                                  ? const SizedBox()
                                  : Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            gradient: AppColors.gradientTurquoise,
                                          ),
                                        ),
                                      ),
                                    ),
                              Container(
                                width: double.infinity,
                                height: 79.23.h -
                                    (12.sp * 1.33 + 14.sp * 1.21 + 14.sp * 1.4) +
                                    ((12.sp * 1.33 + 14.sp * 1.21 + 14.sp * 1.4) * MediaQuery.of(context).textScaleFactor),
                                decoration: isChatUnread
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        gradient: AppColors.gradientTurquoise,
                                      )
                                    : BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                child: FormForButton(
                                  borderRadius: BorderRadius.circular(8.r),
                                  onPressed: () {
                                    if (chat.id != null) {
                                      String userName = "";
                                      if (chat.users != null && chat.users!.isNotEmpty) {
                                        for (var element in chat.users!) {
                                          if (element.id != myUserId && element.displayName != null) {
                                            userName = element.displayName!;
                                            break;
                                          }
                                        }
                                      }

                                      context.router.push(ClientMessagesChatRoute(
                                          senderName: userName,
                                          chatId: chat.id!,
                                          expertId: expertId,
                                          view: userList[expertId],
                                          isNew: false)).then((value) {
                                        context.read<ListChatCubit>().getChat();
                                        context.read<ChatBloc>().add(ChatDisposeEvent());
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 3.36.w, right: 13.36.w),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(
                                          width: 55.w,
                                          height: 55.h,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              if(userList.containsKey(expertId) && userList[expertId]?.fileBase64 != null && userList[expertId]?.fileBase64 != "")
                                                CircleAvatar(
                                                    radius: 40,
                                                    backgroundImage: CachedMemoryImageProvider(
                                                        "app://client_specialist_tabbar_${expertId}",
                                                        base64: userList[expertId]?.fileBase64))
                                              else
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: AppColors.gradientThird,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  height: 55,
                                                  width: 55,
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 22,
                                                    color: AppColors.darkGreenColor,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      getDate(chat.lastMessageTimestamp),
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        height: 1.33,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w500,
                                                        color: isChatUnread ? AppColors.darkGreenColor : AppColors.grey50Color,
                                                      ),
                                                    ),
                                                    Text(
                                                      getTime(chat.lastMessageTimestamp),
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        height: 1.33,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w500,
                                                        color: isChatUnread ? AppColors.darkGreenColor : AppColors.grey50Color,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  getUserName(chat.users),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily: 'Inter',
                                                    height: 1.21,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.darkGreenColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  width: 200.w,
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                          padding: EdgeInsets.only(right: 13.0),
                                                          child: Text(
                                                            chat.lastMessage?.type == "FILE" ? "Отправил(а) документ" : chat.lastMessage?.text ?? "",
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              height: 1.4,
                                                              fontFamily: 'Inter',
                                                              fontWeight: FontWeight.w400,
                                                              color: isChatUnread ? AppColors.darkGreenColor : AppColors.grey50Color,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
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
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.8,
                      child: Center(
                        child: Text(
                          "У вас нет сообщений",
                          style: TextStyle(color: AppColors.darkGreenColor, fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  }
                }
                else if (state is ListChatLoadingState) {
                  return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.6,
                      child: ProgressIndicatorWidget());
                }
                else if (state is ListChatErrorState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: ErrorWithReload(
                      callback: () {
                        context.read<ListChatCubit>().check();
                      },
                    ),
                  );
                }
                return Container();
              });
            }
          ),
        ],
      ),
    );
  }

  int getExpertId(MessageChatModel message){
    int expertId = 0;
    if(message.users != null && message.users!.isNotEmpty && message.users!.length > 1){
      message.users!.forEach((element){
        if(element.id != myUserId && element.id != null){
          expertId = int.parse(element.id!);
        }
      });
    }
    return expertId;
  }

  getMyExpertList(userState){
    userList.clear();

    if(userState is MyExpertLoadedState){
      if(userState.view != null && userState.view!.isNotEmpty){
        userState.view!.forEach((element){
          if(element.expertId != null){
            userList.update(element.expertId!, (value) => element?.avatarBase64, ifAbsent: () => element?.avatarBase64);
          }
        });
      }
    }
  }

  getUserId() async {
    final userId = await storage.getItem(SharedPreferenceData.clientIdKey);
    if (userId != "") {
      setState(() {
        myUserId = userId;
      });
    }
  }

  check(List<MessageChatModel>? chat) {
    list.clear();

    if (chat != null && chat.isNotEmpty) {
      chat.forEach((element) {
        if (element.lastMessageTimestamp != null && element.lastMessageTimestamp != 0 && element.users!.length > 1 && element.lastMessage != null) {
          bool isExist = list.any((item) => item.id == element.id);

          if (!isExist) {
            list.add(element);
          }

          element.users?.forEach((user) {
            if (user.id != null && user.id != myUserId) {
              int userId = int.parse(user.id!);

              if (!contactList.contains(userId)) {
                contactList.add(userId);
              }
            }
          });
        }
      });

      if (list.isNotEmpty) {
        list.sort((a, b) {
          DateTime aDateTime = DateTime.fromMillisecondsSinceEpoch(a.lastMessageTimestamp!);
          DateTime bDateTime = DateTime.fromMillisecondsSinceEpoch(b.lastMessageTimestamp!);
          return aDateTime.compareTo(bDateTime);
        });
      }
    }
  }

  String getUserName(List<MessageUsers>? users) {
    if (users != null && users.isNotEmpty) {
      String userName = "";
      for (var element in users) {
        if (element.id != myUserId && element.displayName != null) {
          userName = element.displayName!;
          break;
        }
      }
      return userName;
    }
    return "";
  }

  String getDate(int? timeStamp) {
    if (timeStamp != null) {
      DateTime today = DateTime.now();
      DateTime myDateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      String date = DateFormatting().formatDateRUWithYear(myDateTime);

      if (myDateTime.day == today.day && myDateTime.month == today.month && myDateTime.year == today.year) {
        return "Сегодня, $date";
      } else {
        String week = DateFormat('EEEE', 'ru_RU').format(myDateTime);
        String newWeek = week.characters.first.toUpperCase();
        String myWeek = week.substring(1);

        return "$newWeek$myWeek, $date";
      }
    }
    return "";
  }

  String getTime(int? timeStamp) {
    if (timeStamp != null) {
      DateTime myDateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      String time = DateFormatting().formatTime(myDateTime);
      return time;
    }
    return "";
  }
}
