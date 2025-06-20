import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/survey/survey_bloc.dart';
import 'package:garnetbook/bloc/client/survey/survey_list/survey_list_cubit.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_response.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/extension/string_externsions.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/utils/functions/status_color.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';

class ClientSurveyMainNowTabBar extends StatefulWidget {
  ClientSurveyMainNowTabBar({super.key});

  @override
  State<ClientSurveyMainNowTabBar> createState() => _ClientSurveyMainNowTabBarState();
}

class _ClientSurveyMainNowTabBarState extends State<ClientSurveyMainNowTabBar> {
  List<QuestionnaireShort> surveyList = [];

  @override
  Widget build(BuildContext context) {
    double heightTextColumn = 48.h - (18.w * 1.2 + 12.w * 1.3) + (18.w * 1.2 + 12.w * 1.3) * MediaQuery.of(context).textScaleFactor;

    return BlocBuilder<SurveyListCubit, SurveyListState>(builder: (context, state) {
      if (state is SurveyListLoadedState) {
        getList(state.list);

        if (surveyList.isNotEmpty) {
          return RefreshIndicator(
            color: AppColors.darkGreenColor,
            onRefresh: () {
              context.read<SurveyListCubit>().check();
              return Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.only(left: 14.w, right: 14.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        height: 64.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientThird,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: FormForButton(
                          borderRadius: BorderRadius.circular(4.r),
                          onPressed: () {
                            context.router.push(ClientSurveyBalanceWheelRoute());
                          },
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Image.asset(
                                "assets/images/balance_wheel.webp",
                                height: 64.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.basicblackColor.withOpacity(0.6),
                                      AppColors.basicblackColor.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Колесо баланса",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.basicwhiteColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ListView.builder(
                      itemCount: surveyList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final questionnaireItem = surveyList[index];

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          margin: EdgeInsets.only(
                            right: 14.w,
                            left: 14.w,
                            bottom: 16.h,
                          ),
                          decoration: BoxDecoration(
                            image: questionnaireItem.questionnaireId == 909
                                ? DecorationImage(
                                    image: AssetImage('assets/images/tree/enter_tree.png'),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: AppColors.basicwhiteColor,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.basicblackColor.withOpacity(0.1),
                                blurRadius: 10.r,
                                spreadRadius: 2.r,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: FormForButton(
                            borderRadius: BorderRadius.circular(8.r),
                            onPressed: () {
                              if (questionnaireItem.questionnaireId == 909) {
                                // if (questionnaireItem.expertId != null) {
                                //   context.router
                                //       .push(
                                //     SurvayTreeMainRoute(expertId: questionnaireItem.expertId!, surveyId: questionnaireItem.id!),
                                //   )
                                //       .then((value) {
                                //     if (value == true) {
                                //       context.read<SurveyListCubit>().check();
                                //     }
                                //   });
                                // }
                              } else if (questionnaireItem.expertId != null) {
                                context.router
                                    .push(ClientSurveyWatchRoute(
                                        id: questionnaireItem.questionnaireId!,
                                        expertId: questionnaireItem.expertId,
                                        surveyId: questionnaireItem.id!))
                                    .then((value) {
                                  context.read<SurveyBloc>().add(SurveyNewEvent());

                                  if (value == true) {
                                    context.read<SurveyListCubit>().check();
                                  }
                                });
                              }
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 8.h),
                                Container(
                                  constraints: BoxConstraints(minHeight: heightTextColumn),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 16.w),
                                        getTitle(questionnaireItem.expertFirstName, questionnaireItem.expertPosition,
                                            questionnaireItem.questionnaireId == 909),
                                        SizedBox(width: 16.w),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientSecond,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        questionnaireItem.title ?? "",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          color: questionnaireItem.questionnaireId == 909
                                              ? AppColors.basicwhiteColor
                                              : AppColors.darkGreenColor,
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      Row(
                                        children: [
                                          Text(
                                            questionnaireItem.create != null ? DateFormatting().formatDate(questionnaireItem.create) : "",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              color: questionnaireItem.questionnaireId == 909
                                                  ? AppColors.basicwhiteColor
                                                  : AppColors.vivaMagentaColor,
                                            ),
                                          ),
                                          const Spacer(),
                                          CircleAvatar(
                                            radius: 4.r,
                                            backgroundColor: StatusColor().getSurveyStatusColor(questionnaireItem.statusName),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            StatusColor().getSurveyStatusName(questionnaireItem.statusName).toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                              color: StatusColor().getSurveyStatusColor(questionnaireItem.statusName),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        } else {
          return RefreshIndicator(
            color: AppColors.darkGreenColor,
            onRefresh: () {
              context.read<SurveyListCubit>().check();
              return Future.delayed(const Duration(seconds: 1));
            },
            child: ListView(
              children: [
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.only(left: 14.w, right: 14.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      height: 64.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientThird,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: FormForButton(
                        borderRadius: BorderRadius.circular(4.r),
                        onPressed: () {
                          context.router.push(ClientSurveyBalanceWheelRoute());
                        },
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Image.asset(
                              "assets/images/balance_wheel.webp",
                              height: 64.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.basicblackColor.withOpacity(0.6),
                                    AppColors.basicblackColor.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Колесо баланса",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.basicwhiteColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: Center(
                    child: Text(
                      "Данные отсутствуют",
                      style: TextStyle(color: AppColors.darkGreenColor, fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else if (state is SurveyListErrorState) {
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.7,
            child: ErrorWithReload(
              callback: () {
                context.read<SurveyListCubit>().check();
              },
            ),
          ),
        );
      } else if (state is SurveyListLoadingState) {
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.6,
            child: Center(
              child: ProgressIndicatorWidget(),
            ),
          ),
        );
      }
      return Container();
    });
  }

  getList(List<QuestionnaireShort>? list) {
    surveyList.clear();

    if (list != null && list.isNotEmpty) {
      list.forEach((element) {
        if (element.statusName != "PASSED" && element.statusName != "Пройден") {
          surveyList.add(element);
        }
      });
    }

    if (surveyList.isNotEmpty) {
      surveyList.sort((a, b) {
        DateTime aDate = DateTime.parse(a.create!);
        DateTime bDate = DateTime.parse(b.create!);
        return bDate.compareTo(aDate);
      });
    }
  }

  Widget getTitle(String? name, String? position, bool isTree) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: position == null ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text(
            name ?? "",
            style: TextStyle(
              height: 1.2,
              fontSize: 18.w,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: isTree ? AppColors.basicwhiteColor : AppColors.darkGreenColor,
            ),
          ),
          SizedBox(height: position == null ? 0 : 8.h),
          position == null
              ? const SizedBox()
              : Text(
                  position.capitalize(),
                  style: TextStyle(
                    height: 1.3,
                    fontSize: 12.w,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    color: isTree ? AppColors.basicwhiteColor : AppColors.vivaMagentaColor,
                  ),
                ),
        ],
      ),
    );
  }
}
