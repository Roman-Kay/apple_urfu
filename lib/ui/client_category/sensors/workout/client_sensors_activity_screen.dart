import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/workout/health_workout_bloc.dart';
import 'package:garnetbook/bloc/client/health/workout/workout_chart/workout_chart_bloc.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/workout/tabbar/client_sensors_activity_tabbar_check.dart';
import 'package:garnetbook/ui/client_category/sensors/workout/tabbar/client_sensors_activity_tabbar_dynamic.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

@RoutePage()
class ClientSensorsActivityScreen extends StatefulWidget {
  const ClientSensorsActivityScreen({super.key});

  @override
  State<ClientSensorsActivityScreen> createState() => _ClientSensorsActivityScreenState();
}

class _ClientSensorsActivityScreenState extends State<ClientSensorsActivityScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final _selectedDate = SelectedDate();
  late TooltipBehavior tooltipBehavior;
  int dayQuantity = 7;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(_selectedDate.date));
    context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, _selectedDate.date));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double heightSafeArea = constraints.maxHeight;

              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    color: AppColors.basicwhiteColor,
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientTurquoiseReverse,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                context.router.maybePop();
                              },
                              icon: Image.asset(
                                AppImeges.arrow_back_png,
                                color: AppColors.darkGreenColor,
                                height: 25.h,
                                width: 25.w,
                              ),
                            ),
                          ),
                          Text(
                            'Моя активность',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: heightSafeArea - 56.h,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/my_day_activity.webp',
                          width: double.infinity,
                          height: double.infinity - 56.h,
                          fit: BoxFit.cover,
                        ),
                        Column(
                          children: [
                            Container(
                              color: AppColors.basicwhiteColor.withOpacity(0.1),
                              height: 54.h,
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: AppColors.grey20Color,
                                      ),
                                      TabBar(
                                        indicatorColor: AppColors.basicwhiteColor,
                                        controller: tabController,
                                        labelColor: AppColors.basicwhiteColor,
                                        unselectedLabelColor: AppColors.basicwhiteColor.withOpacity(0.5),
                                        indicatorSize: TabBarIndicatorSize.label,
                                        labelStyle: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                        tabs: [
                                          SizedBox(
                                            width: 150.w,
                                            height: 56.h,
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
                                            height: 56.h,
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: heightSafeArea - 56.h - 54.h,
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  ClientSensorsActivityTabBarCheck(
                                    selectedDate: _selectedDate,
                                  ),
                                  ClientSensorsActivityTabBarDynamic(selectedDate: _selectedDate),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
