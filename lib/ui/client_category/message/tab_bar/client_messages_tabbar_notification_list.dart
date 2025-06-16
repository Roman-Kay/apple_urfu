import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/my_expert/my_expert_cubit.dart';
import 'package:garnetbook/bloc/message/push/push_cubit.dart';
import 'package:garnetbook/data/models/notificaton/push_list_model.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:garnetbook/domain/services/notification/push_service.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:intl/intl.dart';


class ClientMessagesTabBarNotificationList extends StatefulWidget {
  const ClientMessagesTabBarNotificationList({super.key, required this.controller});
  final TabController controller;

  @override
  State<ClientMessagesTabBarNotificationList> createState() => _ClientMessagesTabBarNotificationListState();
}

class _ClientMessagesTabBarNotificationListState extends State<ClientMessagesTabBarNotificationList> with AutomaticKeepAliveClientMixin{
  List<ListElement> pushList = [];
  Map<int, FileView?> userList = {};
  final pushService = PushService();

  @override
  void initState() {
    if(BlocProvider.of<PushCubit>(context).state is PushLoadedState){}else{
      context.read<PushCubit>().check();
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
      onRefresh: (){
        pushList.clear();
        context.read<PushCubit>().check();
        if(BlocProvider.of<MyExpertCubit>(context).state is MyExpertLoadedState){}else{
          context.read<MyExpertCubit>().check();
        }
        return Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          BlocBuilder<MyExpertCubit, MyExpertState>(
            builder: (context, userState) {
              return BlocBuilder<PushCubit, PushState>(
                builder: (context, state) {
                  if(state is PushLoadedState){
                    getMyExpertList(userState);
                    getList(state.view?.list);
                    setPushRead();

                    if(pushList.isNotEmpty){
                      return Column(
                        children: [
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async{
                                  bool isRequestDone = false;

                                  for(int index = 0; index < pushList.length; index++) {
                                    if(pushList[index].readed == false && pushList[index].id != null){
                                      final response = await pushService.readPush(pushList[index].id!);

                                      if(response.result){
                                        if(!isRequestDone){
                                          isRequestDone = true;
                                        }
                                      }
                                    }
                                  }

                                  if(isRequestDone){
                                    context.read<PushCubit>().check();
                                  }
                                },
                                child: Text(
                                  "Отметить все",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    fontFamily: "Inter",
                                    color: AppColors.darkGreenColor
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Divider(color: AppColors.seaColor),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: pushList.length,
                            separatorBuilder: (context, index) {
                              if (pushList[index].readed != false) {
                                return  Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientTurquoise,
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                            itemBuilder: (context, index) {
                              final push = pushList[index];
                              int expertId = push.authorId != null ? int.parse(push.authorId!) : 0;

                              return Container(
                                margin: EdgeInsets.only(
                                  top: 8.h,
                                  left: 14.w,
                                  right: 14.w,
                                  bottom: index + 1 == pushList.length ? 40.h : 8.h,
                                ),
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                decoration: push.readed == false
                                    ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  gradient: AppColors.gradientTurquoise,
                                )
                                    : BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          if(userList.containsKey(expertId) && userList[expertId]?.fileBase64 != null && userList[expertId]?.fileBase64 != "")
                                            CircleAvatar(
                                                radius: 30,
                                                backgroundImage: CachedMemoryImageProvider(
                                                    "app://client_specialist_tabbar_${expertId}",
                                                    base64: userList[expertId]?.fileBase64))
                                          else Container(
                                            decoration: BoxDecoration(
                                              gradient: AppColors.gradientThird,
                                              shape: BoxShape.circle,
                                            ),
                                            height: 40,
                                            width: 40,
                                            child: Icon(
                                              Icons.person,
                                              size: 20,
                                              color: AppColors.darkGreenColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getDate(push.timestamp),
                                                style: TextStyle(
                                                  fontSize: 12.h,
                                                  height: 1.33,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  color: push.readed == false
                                                      ? AppColors.darkGreenColor
                                                      : AppColors.grey50Color,
                                                ),
                                              ),
                                              Text(
                                                getTime(push.timestamp),
                                                style: TextStyle(
                                                  fontSize: 12.h,
                                                  height: 1.33,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  color: push.readed == false
                                                      ? AppColors.vivaMagentaColor
                                                      : AppColors.grey50Color,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            push.text ?? "",
                                            style: TextStyle(
                                              fontSize: 14.h,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              color: push.readed == false
                                                  ? AppColors.darkGreenColor
                                                  : AppColors.grey50Color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    else{
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: Center(
                          child: Text(
                            "У вас нет уведомлений",
                            style: TextStyle(
                                color: AppColors.darkGreenColor,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  else if(state is PushErrorState){
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ErrorWithReload(
                        callback: () {
                          context.read<PushCubit>().check();
                        },
                      ),
                    );
                  }
                  else if(state is PushLoadingState){
                    if(pushList.isNotEmpty){
                      return Column(
                        children: [
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async{
                                  bool isRequestDone = false;

                                  for(int index = 0; index < pushList.length; index++) {
                                    if(pushList[index].readed == false && pushList[index].id != null){
                                      final response = await pushService.readPush(pushList[index].id!);

                                      if(response.result){
                                        if(!isRequestDone){
                                          isRequestDone = true;
                                        }
                                      }
                                    }
                                  }

                                  if(isRequestDone){
                                    context.read<PushCubit>().check();
                                  }
                                },
                                child: Text(
                                  "Отметить все",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      fontFamily: "Inter",
                                      color: AppColors.darkGreenColor
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Divider(color: AppColors.seaColor),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: pushList.length,
                            separatorBuilder: (context, index) {
                              if (pushList[index].readed != false) {
                                return  Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientTurquoise,
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                            itemBuilder: (context, index) {
                              final push = pushList[index];

                              return Container(
                                margin: EdgeInsets.only(
                                  top: 8.h,
                                  left: 14.w,
                                  right: 14.w,
                                  bottom: index + 1 == pushList.length ? 40.h : 8.h,
                                ),
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                decoration: push.readed == false
                                    ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  gradient: AppColors.gradientTurquoise,
                                )
                                    : BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: AppColors.gradientThird,
                                        shape: BoxShape.circle,
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: Icon(
                                        Icons.person,
                                        size: 20,
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getDate(push.timestamp),
                                                style: TextStyle(
                                                  fontSize: 12.h,
                                                  height: 1.33,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  color: push.readed == false
                                                      ? AppColors.darkGreenColor
                                                      : AppColors.grey50Color,
                                                ),
                                              ),
                                              Text(
                                                getTime(push.timestamp),
                                                style: TextStyle(
                                                  fontSize: 12.h,
                                                  height: 1.33,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  color: push.readed == false
                                                      ? AppColors.vivaMagentaColor
                                                      : AppColors.grey50Color,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            push.text ?? "",
                                            style: TextStyle(
                                              fontSize: 14.h,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              color: push.readed == false
                                                  ? AppColors.darkGreenColor
                                                  : AppColors.grey50Color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: ProgressIndicatorWidget());
                  }
                  return Container();

                }
              );
            }
          ),
        ],
      ),
    );
  }

  getMyExpertList(userState){
    userList.clear();

    if(userState is MyExpertLoadedState){
      if(userState.view != null && userState.view!.isNotEmpty){
        userState.view!.forEach((element){
          if(element.expertId != null){
            userList.update(element.expertId!, (value) => element.avatarBase64, ifAbsent: () => element.avatarBase64);
          }
        });
      }
    }
  }

  getList(List<ListElement>? view) {
    pushList.clear();

    if (view != null && view.isNotEmpty) {
      view.forEach((element) {
        if(element.timestamp != null && element.authorId != element.userId){
          pushList.add(element);
        }
      });

      if (pushList.isNotEmpty) {
        pushList.sort((a, b) {
          DateTime aDateTime = DateTime.fromMillisecondsSinceEpoch(a.timestamp!);
          DateTime bDateTime = DateTime.fromMillisecondsSinceEpoch(b.timestamp!);
          return bDateTime.compareTo(aDateTime);
        });
      }
    }
  }

  setPushRead() async{
    if(pushList.isNotEmpty && widget.controller.index == 1 &&
        context.router.currentPath == "/client-messages-container-route"){

      bool isRequestDone = false;

      for(int index = 0; index < pushList.length; index++) {
        if(pushList[index].readed == false && pushList[index].id != null){
          final response = await pushService.readPush(pushList[index].id!);

          if(response.result){
            if(!isRequestDone){
              isRequestDone = true;
            }
          }
        }
      }

      if(isRequestDone){
        Future.delayed(Duration(seconds: 2), () {
          context.read<PushCubit>().check();
        });
      }
    }
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
