import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/survey/survey_list/survey_list_cubit.dart';
import 'package:garnetbook/data/models/survey/questionnaire/questionnaire_response.dart';
import 'package:garnetbook/ui/client_category/survey/tabbar/client_survey_main_now_tabbar.dart';
import 'package:garnetbook/ui/client_category/survey/tabbar/client_survey_main_passed_tabbar.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';

@RoutePage()
class ClientSurveyMainScreen extends StatefulWidget {
  const ClientSurveyMainScreen({super.key});

  @override
  State<ClientSurveyMainScreen> createState() => _ClientSurveyMainScreenState();
}

class _ClientSurveyMainScreenState extends State<ClientSurveyMainScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<QuestionnaireShort> surveyList = [];

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);

    if(BlocProvider.of<SurveyListCubit>(context).state is SurveyListLoadedState){}else{
      context.read<SurveyListCubit>().check();
    }
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.gradientTurquoiseReverse,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double heightSafeArea = constraints.maxHeight;
              return BlocBuilder<SurveyListCubit, SurveyListState>(builder: (context, state) {
                if(state is SurveyListLoadedState){
                  getList(state.list);
                }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientTurquoiseReverse,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.basicblackColor.withOpacity(0.1),
                              blurRadius: 10.r,
                              spreadRadius: 0,
                            ),
                          ],
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
                                'Опросники',
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
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        height: 56.h,
                        child: TabBar(
                          indicatorColor: AppColors.darkGreenColor,
                          controller: tabController,
                          labelColor: AppColors.darkGreenColor,
                          unselectedLabelColor: AppColors.darkGreenColor.withOpacity(0.5),
                          indicatorSize: TabBarIndicatorSize.label,
                          labelStyle: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: [
                            Stack(
                              children: [
                                SizedBox(
                                  width: 150.w,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Tab(
                                      height: 56.h,
                                      text: 'Рекомендованные   ',
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: surveyList.isNotEmpty
                                      ? Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.vivaMagentaColor,
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      surveyList.length.toString(),
                                      style: TextStyle(
                                          color: AppColors.basicwhiteColor,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Inter",
                                          fontSize: 10.sp),
                                    ),
                                  )
                                      : Container(),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 150.w,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Tab(
                                  height: 56.h,
                                  text: 'Пройденные',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: heightSafeArea - (56 + 8 + 56).h,
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            SizedBox(
                              height: heightSafeArea - (56 + 8 + 56 + 8).h,
                              child: ClientSurveyMainNowTabBar(),
                            ),
                            SizedBox(
                              height: heightSafeArea - (56 + 8 + 56 + 8).h,
                              child: ClientSurveyMainPassedTabBar(),
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
      ),
    );
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
}
