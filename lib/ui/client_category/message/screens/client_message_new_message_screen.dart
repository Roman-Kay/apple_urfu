import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/my_expert/my_expert_cubit.dart';
import 'package:garnetbook/data/models/expert/list/expert_list.dart';
import 'package:garnetbook/data/models/message/message_chat_models/list_chat_models.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/services/message/message_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/extension/string_externsions.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientMessageNewMessageScreen extends StatefulWidget {
  const ClientMessageNewMessageScreen({required this.listOfUsers, super.key});
  final List<int> listOfUsers;

  @override
  State<ClientMessageNewMessageScreen> createState() => _ClientMessageNewMessageScreenState();
}

class _ClientMessageNewMessageScreenState extends State<ClientMessageNewMessageScreen> {
  List<ExpertShortCardView> expertList = [];

  @override
  void initState() {
    if(BlocProvider.of<MyExpertCubit>(context).state is MyExpertLoadedState){}else{
      context.read<MyExpertCubit>().check();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.darkGreenColor,
              onRefresh: (){
                context.read<MyExpertCubit>().check();
                return Future.delayed(const Duration(seconds: 1));
              },
              child: ListView(
                children: [
                  SizedBox(height: 56.h + 20.h),
                  BlocBuilder<MyExpertCubit, MyExpertState>(
                    builder: (context, state) {
                      if(state is MyExpertLoadedState){
                        getList(state.view);

                        if(expertList.isNotEmpty){
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: expertList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final expert = expertList[index];

                              return InkWell(
                                onTap: () async{
                                  final storage = SharedPreferenceData.getInstance();
                                  final clientId = await storage.getItem(SharedPreferenceData.clientIdKey);

                                  if(expert.expertId != null && clientId != ""){
                                    FocusScope.of(context).unfocus();
                                    context.loaderOverlay.show();

                                    final service = MessageService();
                                    final response = await service.createNewChat(CreateNewChatModel(
                                        users: [clientId, expert.expertId!.toString()]
                                    ));

                                    if(response.result){
                                      context.loaderOverlay.hide();

                                      if(response.value?.id != null){
                                        context.router.popAndPush(ClientMessagesChatRoute(
                                            chatId: response.value!.id!,
                                            senderName: expert.firstName ?? "",
                                            isNew: true
                                        ));
                                      }
                                    }
                                    else{
                                      context.loaderOverlay.hide();
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Stack(
                                          children: [
                                            expert.avatarBase64?.fileBase64 != null && expert.avatarBase64?.fileBase64 != "" && expert.expertId != null
                                                ? CircleAvatar(
                                                radius: 40,
                                                backgroundImage: CachedMemoryImageProvider(
                                                    "app://client_specialist_tabbar_${expert.expertId}",
                                                    base64: expert.avatarBase64!.fileBase64!))
                                                : Container(
                                              decoration: BoxDecoration(
                                                gradient: AppColors.gradientThird,
                                                shape: BoxShape.circle,
                                              ),
                                              height: 50,
                                              width: 50,
                                              child: Icon(
                                                Icons.person,
                                                size: 22,
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      getTitle(expert.firstName, expert.position),
                                      SizedBox(width: 20.w),
                                      SvgPicture.asset(
                                        'assets/images/arrow_black.svg',
                                        color: AppColors.darkGreenColor,
                                        width: 24.w,
                                        height: 24.h,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        else{
                          return  SizedBox(
                            height: MediaQuery.of(context).size.height / 1.4,
                            child: Center(
                              child: Text(
                                "Список контактов пуст",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }
                      }
                      else if(state is MyExpertErrorState){
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.4,
                          child: ErrorWithReload(
                            callback: () {
                              context.read<MyExpertCubit>().check();
                            },
                          ),
                        );
                      }
                      else if(state is MyExpertLoadingState){
                        return SizedBox(
                            height: MediaQuery.of(context).size.height / 1.4,
                            child: ProgressIndicatorWidget());
                      }
                      return Container();
                    }
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 56.h,
              color: AppColors.basicwhiteColor,
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientTurquoise,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => context.router.maybePop(),
                        icon: Image.asset(
                          AppImeges.arrow_back_png,
                          color: AppColors.darkGreenColor,
                          height: 25.h,
                          width: 25.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Center(
                      child: Text(
                        'Новое сообщение',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          fontFamily: 'Inter',
                          color: AppColors.darkGreenColor,
                        ),
                      ),
                    ),
                    // const Spacer(),
                    // IconButton(
                    //   onPressed: (){},
                    //   icon: SvgPicture.asset(
                    //     'assets/images/search.svg',
                    //     color: AppColors.darkGreenColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getList(List<ExpertShortCardView>? list){
    if(list != null && list.isNotEmpty){
      expertList.clear();

      list.forEach((element) {
        if(element.expertId != null){
          if(!widget.listOfUsers.contains(element.expertId!)){
            expertList.add(element);
          }
        }
      });
    }
  }

  Widget getTitle(String? name, String? position) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        position == null ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text(
            name ?? "",
            style: TextStyle(
              height: 1.2,
              fontSize: 18.w,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreenColor,
            ),
          ),
          SizedBox(height: position == null ? 0 : 4.h),
          position == null
              ? const SizedBox()
              : Text(
            position.capitalize(),
            style: TextStyle(
              height: 1.1,
              fontSize: 12.w,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              color: AppColors.grey50Color,
            ),
          ),
        ],
      ),
    );
  }
}
