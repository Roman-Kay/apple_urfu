import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/survey/balance_wheel/balance_wheel_bloc.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/survey/balance_wheel/bottom_sheet/client_survey_balance_wheel_info_sheet.dart';
import 'package:garnetbook/ui/client_category/survey/balance_wheel/tab_bar/client_survey_balance_wheel_check_tab_bar.dart';
import 'package:garnetbook/ui/client_category/survey/balance_wheel/tab_bar/client_survey_balance_wheel_dymamic_tab_bar.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';


@RoutePage()
class ClientSurveyBalanceWheelScreen extends StatefulWidget {
  const ClientSurveyBalanceWheelScreen({super.key});

  @override
  State<ClientSurveyBalanceWheelScreen> createState() => _ClientSurveyBalanceWheelScreenState();
}

class _ClientSurveyBalanceWheelScreenState extends State<ClientSurveyBalanceWheelScreen> with SingleTickerProviderStateMixin{
  final _selectedDate = SelectedDate();
  final _isInit = SelectedBool();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    context.read<BalanceWheelBloc>().add(BalanceWheelGetEvent(DateTime.now()));
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
        color: AppColors.basicwhiteColor,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double heightSafeArea = constraints.maxHeight;
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => context.router.maybePop(),
                          icon: Image.asset(
                            AppImeges.arrow_back_png,
                            color: AppColors.darkGreenColor,
                            height: 25.h,
                            width: 25.w,
                          ),
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Center(
                              child: Text(
                                'Колесо баланса',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16.w, left: 8.w),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              showModalBottomSheet(
                                useSafeArea: true,
                                backgroundColor: AppColors.basicwhiteColor,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                context: context,
                                builder: (context) => ModalSheet(
                                  title: 'Что такое колесо баланса?',
                                  content: ClientSurveyBalanceWheelInfoSheet(),
                                ),
                              );
                            },
                            child: SvgPicture.asset(
                              'assets/images/info.svg',
                              height: 20.h,
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
                        SizedBox(
                          width: 150.w,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Tab(
                              height: 56.h,
                              text: 'Отслеживание',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150.w,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Tab(
                              height: 56.h,
                              text: 'Динамика',
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
                          child: ClientSurveyBalanceWheelCheckTabBar(
                            isInit: _isInit,
                            selectedDate: _selectedDate,
                          ),
                        ),
                        SizedBox(
                          height: heightSafeArea - (56 + 8 + 56 + 8).h,
                          child: ClientSurveyBalanceWheelDymamicTabBar(
                            isInit: _isInit,
                            selectedDate: _selectedDate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
