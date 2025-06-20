import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/survey/survey_list/survey_list_cubit.dart';
import 'package:garnetbook/bloc/expert/client_card/client_survey/survey_data/survey_data_bloc.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_response.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/extension/string_externsions.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/utils/functions/status_color.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';

class ClientSurveyMainPassedTabBar extends StatefulWidget {
  ClientSurveyMainPassedTabBar({super.key});

  @override
  State<ClientSurveyMainPassedTabBar> createState() => _ClientSurveyMainPassedTabBarState();
}

class _ClientSurveyMainPassedTabBarState extends State<ClientSurveyMainPassedTabBar> {
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
            child: ListView.builder(
                itemCount: surveyList.length,
                itemBuilder: (context, index) {
                  final questionnaireItem = surveyList[index];

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    margin: EdgeInsets.only(
                      right: 14.w,
                      left: 14.w,
                      top: index == 0 ? 24.h : 0,
                      bottom: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.basicwhiteColor,
                      image: questionnaireItem.questionnaireId == 909
                          ? DecorationImage(
                              image: AssetImage('assets/images/tree/enter_tree.png'),
                              fit: BoxFit.cover,
                            )
                          : null,
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
                        // if(questionnaireItem.questionnaireId == 909 && questionnaireItem.statusName != "NEW" && questionnaireItem.id != null){
                        //   context.router.push(SpecialistSurveyTreeMainRoute(surveyId: questionnaireItem.id!));
                        // }
                        // else if(questionnaireItem.id != null){
                        //   context.router.push(SpecialistSurveyAllInfoRoute(
                        //       isClient: true,
                        //       surveyId: questionnaireItem.id!,
                        //       surveyName: questionnaireItem.title ?? ""
                        //   )).then((val){
                        //     context.read<SurveyDataBloc>().add(SurveyDataInitialEvent());
                        //   });
                        // }
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
                                    color: questionnaireItem.questionnaireId == 909 ? AppColors.basicwhiteColor : AppColors.darkGreenColor,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.6,
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
      } else if (state is SurveyListLoadingState) {
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.7,
            child: Center(
              child: ProgressIndicatorWidget(),
            ),
          ),
        );
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
      }
      return Container();
    });
  }

  getList(List<QuestionnaireShort>? list) {
    surveyList.clear();

    if (list != null && list.isNotEmpty) {
      list.forEach((element) {
        if ((element.statusName == "PASSED" || element.statusName == "Пройден") && element.expertId != null) {
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
