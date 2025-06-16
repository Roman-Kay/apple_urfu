import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_fit/flutter_health_fit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/sleep/health_sleep_bloc.dart';
import 'package:garnetbook/bloc/client/health/sleep/week_sleep/week_sleep_bloc.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/sleep/tabbar/client_sensors_sleep_check_tab_bar.dart';
import 'package:garnetbook/ui/client_category/sensors/sleep/tabbar/client_sensors_sleep_dynamic_tab_bar.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/add_fit_button.dart';

@RoutePage()
class ClientSensorsSleepScreen extends StatefulWidget {
  const ClientSensorsSleepScreen({super.key});

  @override
  State<ClientSensorsSleepScreen> createState() => _ClientSensorsSleepScreenState();
}

class _ClientSensorsSleepScreenState extends State<ClientSensorsSleepScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final flutterHealthFit = FlutterHealthFit();

  final _isRequested = RequestedValue();
  final _selectedDate = SelectedDate();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    getRequested();

    if (BlocProvider.of<HealthSleepBloc>(context).state is HealthSleepLoadedState) {} else {
      context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(DateTime.now()));
    }

    context.read<WeekSleepBloc>().add(WeekSleepGetEvent(date: DateTime.now(), dayQuantity: 7));
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
        child: SafeArea(
          child:  LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            final double heightSafeArea = constraints.maxHeight;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListenableBuilder(
                      listenable: _isRequested,
                      builder: (context, child) {
                        return Container(
                          width: double.infinity,
                          height: 56.h,
                          color: AppColors.basicwhiteColor,
                          child: Container(
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
                                  'Сон',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.sp,
                                    fontFamily: 'Inter',
                                    color: AppColors.darkGreenColor,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: AddFitButton(
                                    onPressed: () {
                                      context.read<HealthSleepBloc>().add(HealthConnectedEvent(DateTime.now()));
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
                                  'Сон',
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
                        );
                      }),
                  Container(
                    width: double.infinity,
                    height: heightSafeArea - 56.h,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/sleep_bg.webp',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: heightSafeArea - 56.h,
                        ),
                        Column(
                          children: [
                            Container(
                              color: AppColors.basicwhiteColor.withOpacity(0.2),
                              height: 54.h,
                              child: ClipRRect(
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
                            ),
                            SizedBox(
                              height: heightSafeArea - 56.h - 54.h,
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  ClientSensorsCheckTabbar(isRequested: _isRequested, selectedDate: _selectedDate),
                                  ClientSensorSleepDynamicTabBar(isRequested: _isRequested, selectedDate: _selectedDate),
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

  getRequested() async {
    final isAuth = await flutterHealthFit.isAuthorized();
    if (!isAuth) {
      _isRequested.select(false);
    } else {
      _isRequested.select(true);
    }
  }
}
