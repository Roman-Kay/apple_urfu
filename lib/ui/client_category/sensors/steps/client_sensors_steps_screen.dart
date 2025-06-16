import 'dart:io';
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/steps/health_step_bloc.dart';
import 'package:garnetbook/bloc/client/health/steps/step_list/step_list_bloc.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/steps/tabbar/client_sensors_steps_tabbar_check.dart';
import 'package:garnetbook/ui/client_category/sensors/steps/tabbar/client_sensors_steps_tabbar_dynamic.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/add_fit_button.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class ClientSensorsStepsScreen extends StatefulWidget {
  const ClientSensorsStepsScreen({Key? key}) : super(key: key);

  @override
  State<ClientSensorsStepsScreen> createState() => _ClientSensorsStepsScreenState();
}

class _ClientSensorsStepsScreenState extends State<ClientSensorsStepsScreen> with SingleTickerProviderStateMixin {
  final _isRequested = RequestedValue();
  Health health = Health();
  int dayQuantity = 7;
  late TabController tabController;

  @override
  void initState() {
    getRequested();
    tabController = TabController(length: 2, vsync: this);

    context.read<HealthStepBloc>().add(HealthStepGetEvent());
    context.read<StepListBloc>().add(StepListGetEvent(DateTime.now().month, DateTime.now().year, null));

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
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
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
                              gradient: AppColors.gradientTurquoiseReverse,
                            ),
                            child: !_isRequested.isNotRequested && Platform.isAndroid
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
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
                                      Text(
                                        'Шаги',
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
                                          onPressed: () async {
                                            var permissions = [HealthDataAccess.READ, HealthDataAccess.READ, HealthDataAccess.READ];

                                            var iosTypes = [
                                              HealthDataType.STEPS,
                                              HealthDataType.ACTIVE_ENERGY_BURNED,
                                              HealthDataType.DISTANCE_WALKING_RUNNING
                                            ];

                                            var androidTypes = [
                                              HealthDataType.STEPS,
                                              HealthDataType.ACTIVE_ENERGY_BURNED,
                                              HealthDataType.DISTANCE_DELTA
                                            ];

                                            final requested = Platform.isIOS
                                                ? await health.requestAuthorization(iosTypes, permissions: permissions)
                                                : await health.requestAuthorization(androidTypes, permissions: permissions);

                                            if (requested == true) {
                                              final isStepRequested = await Permission.activityRecognition.isGranted;
                                              if (!isStepRequested) {
                                                await Permission.activityRecognition.request();
                                              }
                                              context.read<HealthStepBloc>().add(HealthStepGetEvent());
                                              context.read<StepListBloc>().add(StepListGetEvent(DateTime.now().month, DateTime.now().year, null));
                                            }
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
                                      Text(
                                        'Шаги',
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
                          'assets/images/my_day_steps.webp',
                          width: double.infinity,
                          height: double.infinity - 56.h,
                          fit: BoxFit.cover,
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
                                  ClientSensorsStepsTabBarCheck(isRequested: _isRequested),
                                  ClientSensorsStepsTabbarDynamic(isRequested: _isRequested),
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
    var permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    var androidTypes = [HealthDataType.STEPS, HealthDataType.ACTIVE_ENERGY_BURNED, HealthDataType.DISTANCE_DELTA];

    final requested = await health.hasPermissions(androidTypes, permissions: permissions);

    if (Platform.isAndroid) {
      if (requested == true) {
        _isRequested.select(true);

        final isStepRequested = await Permission.activityRecognition.isGranted;
        if (!isStepRequested) {
          await Permission.activityRecognition.request();
        }
      } else {
        _isRequested.select(false);
      }
    }
  }
}
