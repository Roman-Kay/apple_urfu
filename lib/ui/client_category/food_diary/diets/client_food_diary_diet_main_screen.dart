
import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/diets/diets_full_data/diets_full_data_bloc.dart';
import 'package:garnetbook/bloc/client/diets/diets_list_bloc.dart';
import 'package:garnetbook/bloc/client/my_expert/my_expert_cubit.dart';
import 'package:garnetbook/data/models/client/food_diary/diets_model.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/utils/functions/status_color.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';


@RoutePage()
class ClientFoodDiaryDietMainScreen extends StatefulWidget {
  const ClientFoodDiaryDietMainScreen({super.key});

  @override
  State<ClientFoodDiaryDietMainScreen> createState() => _ClientFoodDiaryDietMainScreenState();
}

class _ClientFoodDiaryDietMainScreenState extends State<ClientFoodDiaryDietMainScreen> {
  List<Diets> list = [];
  Map<int, FileView?> userList = {};

  @override
  void initState() {
    if(BlocProvider.of<DietListBloc>(context).state is DietsListLoadedState){}else{
      context.read<DietListBloc>().add(DietsListGetEvent());
    }

    if(BlocProvider.of<MyExpertCubit>(context).state is MyExpertLoadedState){}else{
      context.read<MyExpertCubit>().check();
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.gradientTurquoiseReverse,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<MyExpertCubit, MyExpertState>(builder: (context, expertState) {
                if (expertState is MyExpertLoadedState) {
                  getMyExpertList(expertState);
                }

                  return BlocBuilder<DietListBloc, DietsListState>(builder: (context, state) {
                    if (state is DietsListLoadedState) {
                      getList(state.view);

                      if (list.isNotEmpty) {
                        return RefreshIndicator(
                          color: AppColors.darkGreenColor,
                          onRefresh: () {
                            context.read<DietListBloc>().add(DietsListGetEvent());
                            return Future.delayed(const Duration(seconds: 1));
                          },
                          child: ListView(
                            children: [
                              SizedBox(height: 56.h + 20.h),
                              ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                itemCount: list.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final item = list[index];

                                  return Padding(
                                    padding: EdgeInsets.only(top: index == 0 ? 0 : 18.h, left: 14.w, right: 14.w),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.gradientTurquoise,
                                        borderRadius: BorderRadius.circular(8.r),
                                        border: item.status?.additivePeriodicityId == 1  ? Border.all(
                                          color: AppColors.vivaMagentaColor
                                        ) : null,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 10.r,
                                            color: AppColors.basicblackColor.withOpacity(0.1),
                                          )
                                        ],
                                      ),
                                      child: FormForButton(
                                        borderRadius: BorderRadius.circular(8.r),
                                        onPressed: () {
                                          if (item.id != null) {
                                            context.router.push(ClientFoodDiarySingleDietRoute(id: item.id!)).then((v){
                                              context.read<DietsFullDataBloc>().add(DietsFullDataInitialEvent());
                                            });
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.basicwhiteColor,
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.nameDiet ?? "",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: "Inter",
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.darkGreenColor
                                                    ),
                                                  ),
                                                  SizedBox(height: 7.h),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                          DateFormatting().formatDate(item.createDate).toUpperCase(),
                                                          style: TextStyle(
                                                              fontFamily: "Inter",
                                                              fontSize: 12.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: AppColors.vivaMagentaColor
                                                          ),
                                                      ),
                                                      Spacer(),
                                                      CircleAvatar(
                                                        radius: 4.r,
                                                        backgroundColor: StatusColor().getTrackerStatusColor(item.status?.name),
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Text(
                                                        (item.status?.name ?? "").toUpperCase(),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 12.sp,
                                                          fontFamily: 'Inter',
                                                          color: StatusColor().getTrackerStatusColor(item.status?.name),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 14.w),
                                                if (item.expertId != null &&
                                                    userList.containsKey(item.expertId) &&
                                                    userList[item.expertId]?.fileBase64 != null &&
                                                    userList[item.expertId]?.fileBase64 != "")
                                                  CircleAvatar(
                                                      radius: 24,
                                                      backgroundImage: CachedMemoryImageProvider(
                                                          "app://client_specialist_tabbar_${item.expertId}",
                                                          base64: userList[item.expertId]?.fileBase64))
                                                else
                                                  CircleAvatar(
                                                    radius: 24,
                                                    backgroundColor: AppColors.seaColor,
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
                                                      Text(
                                                        item.firstNameExpert ?? "",
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: AppColors.darkGreenColor,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      if (item.positionExpert != null) SizedBox(height: 4.h),
                                                      if (item.positionExpert != null)
                                                        Text(
                                                          item.positionExpert ?? "",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: AppColors.redColor,
                                                              fontSize: 12.sp,
                                                              fontFamily: "Inter"),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                              ],
                                            ),
                                            SizedBox(height: 12.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 94.h),
                            ],
                          ),
                        );
                      }
                      else {
                        return RefreshIndicator(
                          color: AppColors.darkGreenColor,
                          onRefresh: () {
                            context.read<DietListBloc>().add(DietsListGetEvent());
                            return Future.delayed(const Duration(seconds: 1));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: ListView(
                              children: [
                                SizedBox(height: 56.h + 20.h),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height / 1.6,
                                  child: Center(
                                    child: Text(
                                      "Данные отсутствуют",
                                      style: TextStyle(
                                          color: AppColors.basicwhiteColor, fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 94.h),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    else if (state is DietsListErrorState) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: ErrorWithReload(
                          callback: () {
                            context.read<DietListBloc>().add(DietsListGetEvent());
                          },
                        ),
                      );
                    }
                    return SizedBox(height: MediaQuery.of(context).size.height / 1.2, child: ProgressIndicatorWidget());
                  });
                }
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
                      Center(
                        child: Text(
                          'Рацоны',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
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
    );
  }


  getList(List<Diets>? view){
    list.clear();

    if(view != null && view.isNotEmpty){
      view.forEach((element){
        if(element.id != null && element.createDate != null && element.expertId != null){
          list.add(element);
        }
      });
    }
  }


  getMyExpertList(userState) {
    userList.clear();

    if (userState is MyExpertLoadedState) {
      if (userState.view != null && userState.view!.isNotEmpty) {
        userState.view!.forEach((element) {
          if (element.expertId != null) {
            userList.update(element.expertId!, (value) => element.avatarBase64, ifAbsent: () => element.avatarBase64);
          }
        });
      }
    }
  }
}
