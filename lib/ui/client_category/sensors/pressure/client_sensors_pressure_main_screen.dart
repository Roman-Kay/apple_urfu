import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/pressure/pressure_bloc.dart';
import 'package:garnetbook/bloc/client/health/pulse/pulse_bloc.dart';
import 'package:garnetbook/bloc/client/my_expert/my_expert_cubit.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/pressure/tab_bar/client_sensors_pressure_tabbar_check.dart';
import 'package:garnetbook/ui/client_category/sensors/pressure/tab_bar/client_sensors_pressure_tabbar_dynamic.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/add_fit_button.dart';
import 'package:health/health.dart';

@RoutePage()
class ClientSensorsPressureMainScreen extends StatefulWidget {
  const ClientSensorsPressureMainScreen({super.key});

  @override
  State<ClientSensorsPressureMainScreen> createState() => _ClientSensorsPressureMainScreenState();
}

class _ClientSensorsPressureMainScreenState extends State<ClientSensorsPressureMainScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final _selectedDate = SelectedDate();
  final _isRequested = RequestedValue();
  final _isInit = SelectedBool();
  final _isInitPressure = SelectedBool2();
  Health health = Health();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    getRequested();

    if (BlocProvider.of<PressureBloc>(context).state is PressureLoadedState) {} else {
      context.read<PressureBloc>().add(PressureGetEvent(DateTime.now(), _isRequested));
    }

    if (BlocProvider.of<PulseBloc>(context).state is PulseLoadedState) {} else {
      context.read<PulseBloc>().add(PulseGetEvent(DateTime.now()));
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
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: AppColors.gradientTurquoiseReverse),
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
                                          'Давление и пульс',
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
                                    padding: EdgeInsets.only(right: 8.w, left: 8.w),
                                    child: AddFitButton(
                                      onPressed: () {
                                        context.read<PressureBloc>().add(PressuredConnectedEvent(_selectedDate.date, _isRequested));
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
                                      onPressed: () => context.router.maybePop(),
                                      icon: Image.asset(
                                        AppImeges.arrow_back_png,
                                        color: AppColors.darkGreenColor,
                                        height: 25.h,
                                        width: 25.w,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Давление и пульс',
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
                      Expanded(
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/back_pressure.webp',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Column(
                              children: [
                                ClipRRect(
                                  child: Container(
                                    color: AppColors.basicwhiteColor.withOpacity(0.2),
                                    height: 54.h,
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                                      ClientSensorsPressureTabBarCheck(
                                          isRequested: _isRequested,
                                          selectedDate: _selectedDate,
                                          isInit: _isInit,
                                          isPulseInit: _isInitPressure,
                                      ),
                                      ClientSensorsPressureTabBarDynamic(
                                          isRequested: _isRequested,
                                          selectedDate: _selectedDate,
                                          isPulseInit: _isInitPressure,
                                          isInit: _isInit,
                                      ),
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
    List<HealthDataType> healthDataType = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC, HealthDataType.BLOOD_PRESSURE_SYSTOLIC];

    List<HealthDataAccess> permissions = [HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE];

    final requested = Platform.isAndroid
        ? await health.hasPermissions(healthDataType, permissions: permissions)
        : await health.requestAuthorization(healthDataType, permissions: permissions);

    if (Platform.isAndroid) {
      if (requested == true) {
        _isRequested.select(true);
      } else {
        _isRequested.select(false);
      }
    }
  }
}
