import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/blood_glucose/blood_glucose_bloc.dart';
import 'package:garnetbook/bloc/client/my_expert/my_expert_cubit.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_glucose/tab_bar/client_sensors_tab_bar_sugar_check.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_glucose/tab_bar/client_sensors_tab_bar_sugar_dynamic.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/add_fit_button.dart';
import 'package:health/health.dart';

@RoutePage()
class ClientSensorsSugarInBloodScreen extends StatefulWidget {
  const ClientSensorsSugarInBloodScreen({super.key});

  @override
  State<ClientSensorsSugarInBloodScreen> createState() => _ClientSensorsSugarInBloodScreenState();
}

class _ClientSensorsSugarInBloodScreenState extends State<ClientSensorsSugarInBloodScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final _selectedDate = SelectedDate();
  final _isRequested = RequestedValue();
  Health health = Health();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    getRequested();

    if (BlocProvider.of<BloodGlucoseBloc>(context).state is BloodGlucoseLoadedState) {} else {
      context.read<BloodGlucoseBloc>().add(BloodGlucoseGetEvent(DateTime.now(), _isRequested));
    }

    if (BlocProvider.of<MyExpertCubit>(context).state is MyExpertLoadedState) {} else {
      context.read<MyExpertCubit>().check();
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: ListenableBuilder(
              listenable: _isRequested,
              builder: (context, child) {
                return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  final double heightSafeArea = constraints.maxHeight;

                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientTurquoise,
                        ),
                        child: !_isRequested.isNotRequested && Platform.isAndroid
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Уровень сахара\nв крови',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp,
                                          height: 1.2,
                                          fontFamily: 'Inter',
                                          color: AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.w, left: 8.w),
                                    child: AddFitButton(
                                      onPressed: () {
                                        context.read<BloodGlucoseBloc>().add(BloodGlucoseConnectedEvent(DateTime.now(), _isRequested));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
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
                                  SizedBox(
                                    width: 290.w,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Уровень сахара в крови',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp,
                                          fontFamily: 'Inter',
                                          color: AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      Container(
                        width: double.infinity,
                        height: heightSafeArea - 56.h,
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/back_sugar.webp',
                              width: double.infinity,
                              height: double.infinity - 56.h,
                              fit: BoxFit.cover,
                            ),
                            Column(
                              children: [
                                Container(
                                  color: AppColors.basicwhiteColor.withOpacity(0.1),
                                  height: 54.h,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: AppColors.grey20Color,
                                      ),
                                      ClipRRect(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                          child: TabBar(
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
                                                height: 56.h,
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
                                                height: 56.h,
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
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: heightSafeArea - 56.h - 54.h,
                                  child: TabBarView(
                                    controller: tabController,
                                    children: [
                                      ClientTabBarSugarCheck(
                                        selectedDate: _selectedDate,
                                        isRequested: _isRequested,
                                      ),
                                      ClientTabBarSugarDynamic(isRequested: _isRequested, selectedDate: _selectedDate),
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
                });
              }),
        ),
      ),
    );
  }

  getRequested() async {
    final requested = Platform.isAndroid
        ? await health.hasPermissions([HealthDataType.BLOOD_GLUCOSE], permissions: [HealthDataAccess.READ_WRITE])
        : await health.requestAuthorization([HealthDataType.BLOOD_GLUCOSE], permissions: [HealthDataAccess.READ_WRITE]);

    if (Platform.isAndroid) {
      if (requested == true) {
        _isRequested.select(true);
      } else {
        _isRequested.select(false);
      }
    }
  }
}
