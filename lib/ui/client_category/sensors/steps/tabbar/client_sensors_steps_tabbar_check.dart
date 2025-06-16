import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/health/steps/health_step_bloc.dart';
import 'package:garnetbook/bloc/client/health/steps/step_list/step_list_bloc.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/steps/bottom_sheet/client_steps_add_bottom_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/error_handler/error_handler_sensors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/custom_radial_persent_widget.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class ClientSensorsStepsTabBarCheck extends StatefulWidget {
  const ClientSensorsStepsTabBarCheck({super.key, required this.isRequested});

  final RequestedValue isRequested;

  @override
  State<ClientSensorsStepsTabBarCheck> createState() => _ClientSensorsStepsTabBarCheckState();
}

class _ClientSensorsStepsTabBarCheckState extends State<ClientSensorsStepsTabBarCheck> with AutomaticKeepAliveClientMixin {
  Health health = Health();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final double heightSafeArea = constraints.maxHeight;
        return Stack(
          children: [
            BlocBuilder<HealthStepBloc, HealthStepState>(
              builder: (context, state) {
                if (state is HealthStepLoadedState) {
                  getRequested();

                  if (state.connected == false && state.steps == 0 && state.distance == 0 && state.hours == 0) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: ErrorHandler(
                        addValueFunction: (){
                          showModalBottomSheet(
                            useSafeArea: true,
                            backgroundColor: AppColors.basicwhiteColor,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            context: context,
                            builder: (context) => ModalSheet(
                              color: AppColors.darkGreenColor,
                              title: "Ввести показатели",
                              content: ClientStepsAddBottomSheet(),
                            ),
                          ).then((val){
                            if(val == true){
                              context.read<HealthStepBloc>().add(HealthStepGetEvent());
                              context.read<StepListBloc>().add(StepListGetEvent(DateTime.now().month, DateTime.now().year, null));
                            }
                          });
                        },
                      ),
                    );
                  }
                  else {
                    return RefreshIndicator(
                      color: AppColors.darkGreenColor,
                      onRefresh: () {
                        context.read<HealthStepBloc>().add(HealthStepGetEvent());
                        context.read<StepListBloc>().add(StepListGetEvent(DateTime.now().month, DateTime.now().year, null));
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: heightSafeArea,
                          child: Column(
                            children: [
                              SizedBox(height: 16.h),
                              Container(
                                width: double.infinity,
                                height: 61.h,
                                color: AppColors.grey60Color.withOpacity(0.6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Сегодня вы прошли:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp,
                                        fontFamily: 'Inter',
                                        color: AppColors.basicwhiteColor,
                                      ),
                                    ),
                                    SizedBox(width: 18.w),
                                    Text(
                                      getText(state.steps),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24.sp,
                                        fontFamily: 'Inter',
                                        color: AppColors.basicwhiteColor,
                                      ),
                                    ),
                                    SizedBox(width: 18.w),
                                    Text(
                                      'от цели дня',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                        fontFamily: 'Inter',
                                        color: AppColors.basicwhiteColor,
                                        decorationColor: AppColors.basicwhiteColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Center(
                                child: RadialPercentWidget(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/footsteps_icon.svg',
                                              color: AppColors.orangeColor,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          state.steps.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 48.sp,
                                            fontFamily: 'Inter',
                                            color: AppColors.basicwhiteColor,
                                          ),
                                        ),
                                        SizedBox(height: 4.w),
                                        Text(
                                          'шаг',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.sp,
                                            fontFamily: 'Inter',
                                            color: AppColors.grey30Color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  percent: getPercent(state.steps),
                                  lineColor: AppColors.grey40Color.withOpacity(0.3),
                                  endLineColor: AppColors.grey50Color.withOpacity(0.7),
                                  linePercentColor: AppColors.orangeColor,
                                  freePaintColor: AppColors.grey60Color.withOpacity(0.8),
                                  backGroundColor: AppColors.grey60Color.withOpacity(0.8),
                                  boxShadowColor: Color(0x000000000),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 110.w,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey60Color.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 4.h),
                                            SvgPicture.asset(
                                              'assets/images/energy_human.svg',
                                              width: 32.w,
                                              height: 32.h,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              'Энергия',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                                fontFamily: 'Inter',
                                                color: AppColors.grey40Color,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: getCalorie(state),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.orangeColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' ккал',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.orangeColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 110.w,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey60Color.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 4.h),
                                            SvgPicture.asset(
                                              'assets/images/located.svg',
                                              width: 32.w,
                                              height: 32.h,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              'Расстояние',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                                fontFamily: 'Inter',
                                                color: AppColors.grey40Color,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: getDistance(state),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.orangeColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' км',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.orangeColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 110.w,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey60Color.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 4.h),
                                            SvgPicture.asset(
                                              'assets/images/clock.svg',
                                              width: 32.w,
                                              height: 32.h,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              'Время',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                                fontFamily: 'Inter',
                                                color: AppColors.grey40Color,
                                              ),
                                            ),
                                            SizedBox(height: 5.h),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: getHours(state),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.orangeColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' мин',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.orangeColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),
                              if (state.connected == false && state.steps != 0 && state.distance != 0 && state.hours != 0)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                                  child: WidgetButton(
                                    onTap: () {
                                      showModalBottomSheet(
                                        useSafeArea: true,
                                        backgroundColor: AppColors.basicwhiteColor,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                        ),
                                        context: context,
                                        builder: (context) => ModalSheet(
                                          color: AppColors.darkGreenColor,
                                          title: "Ввести показатели",
                                          content: ClientStepsAddBottomSheet(),
                                        ),
                                      ).then((val) {
                                        if (val == true) {
                                          context.read<HealthStepBloc>().add(HealthStepGetEvent());
                                          context.read<StepListBloc>().add(StepListGetEvent(DateTime.now().month, DateTime.now().year, null));
                                        }
                                      });
                                    },
                                    color: AppColors.darkGreenColor,
                                    text: 'изменить'.toUpperCase(),
                                  ),
                                ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }
                else if (state is HealthStepLoadingState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: Center(
                      child: ProgressIndicatorWidget(isWhite: true),
                    ),
                  );
                }
                else if (state is HealthStepErrorState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: Center(
                      child: ErrorWithReload(
                        isWhite: true,
                        callback: () {
                          context.read<HealthStepBloc>().add(HealthStepGetEvent());
                          context.read<StepListBloc>().add(StepListGetEvent(DateTime.now().month, DateTime.now().year, null));
                        },
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            BlocBuilder<HealthStepBloc, HealthStepState>(
              builder: (context, state) {
                if (state is HealthStepLoadedState) {
                  if (state.connected == false && state.steps == 0 && state.distance == 0 && state.hours == 0) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: WidgetButton(
                                onTap: () async{
                                  var permissions = [HealthDataAccess.READ, HealthDataAccess.READ, HealthDataAccess.READ];

                                  var iosTypes = [HealthDataType.STEPS, HealthDataType.ACTIVE_ENERGY_BURNED, HealthDataType.DISTANCE_WALKING_RUNNING];

                                  var androidTypes = [HealthDataType.STEPS, HealthDataType.ACTIVE_ENERGY_BURNED, HealthDataType.DISTANCE_DELTA];

                                  final requested = Platform.isIOS
                                      ? await health.requestAuthorization(iosTypes, permissions: permissions)
                                      : await health.requestAuthorization(androidTypes, permissions: permissions);

                                  if (requested == true) {
                                    widget.isRequested.select(true);

                                    final isStepRequested = await Permission.activityRecognition.isGranted;
                                    if (!isStepRequested) {
                                      await Permission.activityRecognition.request();
                                    }

                                    context.read<HealthStepBloc>().add(HealthStepGetEvent());
                                    context.read<StepListBloc>().add(StepListGetEvent(DateTime.now().month, DateTime.now().year, null));
                                  }
                                },
                                color: AppColors.darkGreenColor,
                                text: 'повторить'.toUpperCase(),
                              ),
                            ),
                            SizedBox(width: 30.h),
                            Expanded(
                              child: WidgetButton(
                                onTap: () => context.router.maybePop(),
                                color: AppColors.seaColor,
                                textColor: AppColors.darkGreenColor,
                                text: 'на главную'.toUpperCase(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
          ],
        );
      }
    );
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
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
        widget.isRequested.select(true);

        final isStepRequested = await Permission.activityRecognition.isGranted;
        if (!isStepRequested) {
          await Permission.activityRecognition.request();
        }
      } else {
        widget.isRequested.select(false);
      }
    }
  }

  String getText(int steps) {
    if (steps > 10000) {
      return "100%";
    } else {
      double value = (steps * 100) / 10000;
      int result = value.toInt();
      return "${result.toString()}%";
    }
  }

  double getPercent(int steps) {
    if (steps > 10000) {
      return 1;
    } else {
      double value = steps / 10000;
      return value;
    }
  }

  String getCalorie(state) {
    if (state is HealthStepLoadedState) {
      return state.calorie.floorToDouble().toStringAsFixed(0) + " ";
    }
    return "0 ";
  }

  String getDistance(state) {
    if (state is HealthStepLoadedState) {
      return removeDecimalZeroFormat(state.distance);
    }
    return "0 ";
  }

  String getHours(state) {
    if (state is HealthStepLoadedState) {
      return state.hours.toString();
    }
    return "0";
  }
}
