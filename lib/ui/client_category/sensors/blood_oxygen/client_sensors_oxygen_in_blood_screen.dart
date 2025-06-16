import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/blood_oxygen/blood_oxygen_bloc.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_oxygen/tab_bar/client_sensors_tab_bar_oxygen_check.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_oxygen/tab_bar/client_sensors_tab_bar_oxygen_dynamic.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/add_fit_button.dart';
import 'package:health/health.dart';


@RoutePage()
class ClientSensorsOxygenInBloodScreen extends StatefulWidget {
  const ClientSensorsOxygenInBloodScreen({super.key});

  @override
  State<ClientSensorsOxygenInBloodScreen> createState() => _ClientSensorsOxygenInBloodScreenState();
}

class _ClientSensorsOxygenInBloodScreenState extends State<ClientSensorsOxygenInBloodScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final _selectedDate = SelectedDate();
  final _isRequested = RequestedValue();
  Health health = Health();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    getRequested();

    if (BlocProvider.of<BloodOxygenBloc>(context) is BloodOxygenLoadedState) {} else {
      context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(DateTime.now(), _isRequested));
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
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.gradientTurquoiseReverse),
        child: SafeArea(
          child: ListenableBuilder(
            listenable: _isRequested,
            builder: (context, child) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double heightSafeArea = constraints.maxHeight;
                  return RefreshIndicator(
                    onRefresh: () {
                      context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(_selectedDate.date, _isRequested));
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: Column(
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
                                          )),
                                    ),
                                    Text(
                                      'Кислород в крови',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.sp,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.w, left: 8.w),
                                      child: AddFitButton(
                                        onPressed: () {
                                          context.read<BloodOxygenBloc>().add(BloodOxygenConnectedEvent(_selectedDate.date, _isRequested));
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
                                          )),
                                    ),
                                    Text(
                                      'Кислород в крови',
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
                        Stack(
                          children: [
                            Image.asset(
                              'assets/images/lungs.png',
                              width: double.infinity,
                              height: heightSafeArea - 56.h,
                              fit: BoxFit.cover,
                            ),
                            Column(
                              children: [
                                Container(
                                  color: AppColors.basicwhiteColor.withOpacity(0.2),
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
                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                                      ClientSensorsTabBarOxygenCheck(isRequested: _isRequested, selectedDate: _selectedDate),
                                      ClientSensorsTabBarOxygenDynamic(isRequested: _isRequested, selectedDate: _selectedDate),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  getRequested() async {
    final requested = Platform.isAndroid
        ? await health.hasPermissions([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE])
        : await health.requestAuthorization([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE]);

    if (Platform.isAndroid) {
      if (requested == true) {
        _isRequested.select(true);
      } else {
        _isRequested.select(false);
      }
    }
  }
}
