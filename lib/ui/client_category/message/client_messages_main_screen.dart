
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/message/push/push_cubit.dart';
import 'package:garnetbook/ui/client_category/message/tab_bar/client_messages_tabbar_message_list.dart';
import 'package:garnetbook/ui/client_category/message/tab_bar/client_messages_tabbar_notification_list.dart';
import 'package:garnetbook/utils/colors.dart';


@RoutePage()
class ClientMessagesMainScreen extends StatefulWidget {
  ClientMessagesMainScreen({super.key, this.tabIndex = 0});
  final int tabIndex;

  @override
  State<ClientMessagesMainScreen> createState() => _ClientMessagesMainScreenState();
}

class _ClientMessagesMainScreenState extends State<ClientMessagesMainScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: widget.tabIndex);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double heightSafeArea = constraints.maxHeight;
            return BlocBuilder<PushCubit, PushState>(
                builder: (context, pushState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientTurquoise,
                      ),
                      child: TabBar(
                        indicatorColor: AppColors.darkGreenColor,
                        controller: tabController,
                        labelColor: AppColors.darkGreenColor,
                        unselectedLabelColor:
                            AppColors.darkGreenColor.withOpacity(0.5),
                        indicatorSize: TabBarIndicatorSize.label,
                        onTap: (value){
                          if(value == 1){
                            checkUnreadPush(pushState);
                          }
                        },
                        labelStyle: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: [
                          SizedBox(
                            width: 150.w,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Tab(
                                height: 56.h,
                                text: 'Cообщения',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150.w,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Tab(
                                height: 56.h,
                                text: 'Уведомления',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: heightSafeArea - (56).h,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: tabController,
                        children: [
                          SizedBox(
                            height: heightSafeArea - (56).h,
                            child: ClientMessagesTabBarMessageList(),
                          ),
                          SizedBox(
                            height: heightSafeArea - (56).h,
                            child: ClientMessagesTabBarNotificationList(controller: tabController),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            );
          },
        ),
      ),
    );
  }

  checkUnreadPush(pushState){
    if(pushState is PushLoadedState){
      if(pushState.view != null && pushState.view?.list != null && pushState.view!.list!.isNotEmpty){
        bool isMessageIsUnread = false;

        for(var element in pushState.view!.list!){
          if(element.readed == false && element.authorId != element.userId){
            isMessageIsUnread = true;
            break;
          }
        }

        if(isMessageIsUnread){
          context.read<PushCubit>().check();
        }
      }
    }
  }
}
