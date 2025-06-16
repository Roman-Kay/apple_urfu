import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/health/pressure/pressure_bloc.dart';
import 'package:garnetbook/bloc/client/health/pulse/pulse_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/pressure/sheets/client_sensors_pressure_add_sheet.dart';
import 'package:garnetbook/ui/client_category/sensors/pressure/sheets/client_sensors_pressure_type_problem_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/portion_button.dart';
import 'package:garnetbook/widgets/buttons/switch_widget.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/error_handler/error_handler_sensors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:health/health.dart';

class ClientSensorsPressureTabBarCheck extends StatefulWidget {
  const ClientSensorsPressureTabBarCheck({
    required this.selectedDate,
    required this.isRequested,
    required this.isInit,
    required this.isPulseInit,
    super.key});

  final SelectedDate selectedDate;
  final RequestedValue isRequested;
  final SelectedBool isInit;
  final SelectedBool2 isPulseInit;

  @override
  State<ClientSensorsPressureTabBarCheck> createState() => _ClientSensorsPressureTabBarCheckState();
}

class _ClientSensorsPressureTabBarCheckState extends State<ClientSensorsPressureTabBarCheck> with AutomaticKeepAliveClientMixin {
  bool isAritmia = false;
  Health healthFit = Health();
  int pulse = 0;
  int diastolicPressure = 0;
  int systolicPressure = 0;
  String? pressureDate;
  String? health;
  List<String> conditions = [];
  String? comment;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        RefreshIndicator(
          color: AppColors.darkGreenColor,
          onRefresh: () {
            context.read<PressureBloc>().add(PressureGetEvent(widget.selectedDate.date, widget.isRequested));
            context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
            return Future.delayed(const Duration(seconds: 1));
          },
          child: ListView(
            children: [
              BlocBuilder<PressureBloc, PressureState>(builder: (context, pressureState) {
                if (pressureState is PressureLoadedState) {
                  getRequested();
                  getPressure(pressureState.currentVal);

                  return ListenableBuilder(
                      listenable: widget.selectedDate,
                      builder: (context, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            children: [
                              SizedBox(height: 16.h),

                              if (pressureDate != null)
                                CustomTextFieldLabel(
                                  backGroudColor: AppColors.darkGreenColor.withOpacity(0.8),
                                  controller: TextEditingController(
                                    text: DateFormatting().formatDate(widget.selectedDate.date) + ' ' + DateFormatting().formatTime(pressureDate!),
                                  ),
                                  labelText: 'Дата и время измерения давления:',
                                  textColor: AppColors.basicwhiteColor,
                                  labelColor: AppColors.basicwhiteColor,
                                  borderColor: AppColors.darkGreenColor.withOpacity(0.8),
                                  icon: SvgPicture.asset(
                                    'assets/images/clock.svg',
                                    color: AppColors.basicwhiteColor,
                                  ),
                                )
                              else
                                CustomTextFieldLabel(
                                  backGroudColor: AppColors.darkGreenColor.withOpacity(0.8),
                                  controller: TextEditingController(
                                    text: DateFormatting().formatDate(widget.selectedDate.date),
                                  ),
                                  borderColor: AppColors.darkGreenColor.withOpacity(0.8),
                                  labelText: 'Дата и время измерения давления:',
                                  textColor: AppColors.basicwhiteColor,
                                  labelColor: AppColors.basicwhiteColor,
                                  icon: SvgPicture.asset(
                                    'assets/images/clock.svg',
                                    color: AppColors.basicwhiteColor,
                                  ),
                                ),

                              SizedBox(height: 24.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                clipBehavior: Clip.hardEdge,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.basicblackColor.withOpacity(0.1),
                                        blurRadius: 8.r,
                                      ),
                                    ],
                                    color: AppColors.redBEColor.withOpacity(0.5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: 14.h),
                                          Text(
                                            diastolicPressure != 0 && systolicPressure != 0 ? "$systolicPressure/$diastolicPressure" : "0",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 42.w,
                                              fontFamily: 'Inter',
                                              color: AppColors.basicwhiteColor,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'mmHg',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.w,
                                              height: 1.1,
                                              fontFamily: 'Inter',
                                              color: AppColors.basicwhiteColor,
                                            ),
                                          ),
                                          SizedBox(height: 14.h),
                                        ],
                                      ),
                                      BlocBuilder<PulseBloc, PulseState>(builder: (context, pulseState) {
                                        if (pulseState is PulseLoadedState) {
                                          getPulse(pulseState.list);
                                          checkAritmia();

                                          if (pulse != 0) {
                                            return Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 34.w, right: 18.w),
                                                  child: SvgPicture.asset(
                                                    'assets/images/pulse.svg',
                                                    width: 34.w,
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      pulse.toString(),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 42.w,
                                                        fontFamily: 'Inter',
                                                        color: AppColors.basicwhiteColor,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      'BPM',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 14.w,
                                                        height: 1.1,
                                                        fontFamily: 'Inter',
                                                        color: AppColors.basicwhiteColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                        return Container();
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppColors.basicwhiteColor.withOpacity(0.2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 8.h),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8.r),
                                            clipBehavior: Clip.hardEdge,
                                            child: Container(
                                              height: 64.h,
                                              decoration: BoxDecoration(
                                                color: AppColors.darkGreenColor.withOpacity(0.5),
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 16.w),
                                                  Text(
                                                    'Выявлена аритмия?',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16.w,
                                                      fontFamily: 'Inter',
                                                      color: AppColors.basicwhiteColor,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  SwitchWidget(
                                                    activeColor: AppColors.darkGreenColor,
                                                    activeTrackColor: AppColors.lightGreenColor,
                                                    inactiveTrackColor: AppColors.grey20Color,
                                                    inactiveThumbColor: AppColors.grey40Color,
                                                    isSwitched: isAritmia,
                                                    onChanged: (value) {},
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.r),
                                              color: AppColors.darkGreenColor.withOpacity(0.5),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8.r),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 16.h),
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 2.5.w + (50.w * 6 + 10.w * 5) * getPercent(diastolicPressure, systolicPressure),
                                                        // 0.5 это процент на сколько умножаем
                                                      ),
                                                      child: SvgPicture.asset(
                                                        'assets/images/cursor.svg',
                                                        width: 20.w,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Center(
                                                    child: Row(
                                                      spacing: 10.w,
                                                      children: [
                                                        ColorContainer(color: AppColors.blueSecondaryColor),
                                                        ColorContainer(color: AppColors.greenLightColor),
                                                        ColorContainer(color: AppColors.orangeColor),
                                                        ColorContainer(color: AppColors.tints3Color),
                                                        ColorContainer(color: Color(0xFFCD5B6F)),
                                                        ColorContainer(color: AppColors.redColor),
                                                      ],
                                                    ),
                                                  ),
                                                  if (getPressureStatus(diastolicPressure, systolicPressure) != "")
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(height: 16.h),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(8.r),
                                                              border: Border.all(width: 1, color: AppColors.limeColor),
                                                            ),
                                                            child: FormForButton(
                                                              borderRadius: BorderRadius.circular(16.r),
                                                              onPressed: () => showModalBottomSheet(
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
                                                                  color: AppColors.darkGreenColor,
                                                                  title: 'Тип проблемы',
                                                                  content: ClientSensorsPressureTypeProblemSheet(),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                                                child: Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                      backgroundColor: getPressureColor(diastolicPressure, systolicPressure),
                                                                      radius: 6.r,
                                                                    ),
                                                                    SizedBox(width: 12.w),
                                                                    Expanded(
                                                                      child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: FittedBox(
                                                                          fit: BoxFit.scaleDown,
                                                                          child: Text(
                                                                            getPressureStatus(diastolicPressure, systolicPressure),
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 18.w,
                                                                              fontFamily: 'Inter',
                                                                              color: AppColors.basicwhiteColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 10.w),
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            CircleAvatar(
                                                                              backgroundColor: AppColors.basicwhiteColor,
                                                                              radius: (2.5).r,
                                                                            ),
                                                                            SizedBox(width: 10.w),
                                                                            Text(
                                                                              getSystolicTitle(diastolicPressure, systolicPressure),
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 16.w,
                                                                                fontFamily: 'Inter',
                                                                                color: AppColors.basicwhiteColor,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            CircleAvatar(
                                                                              backgroundColor: AppColors.basicwhiteColor,
                                                                              radius: (2.5).r,
                                                                            ),
                                                                            SizedBox(width: 10.w),
                                                                            Text(
                                                                              getDiastolicTitle(diastolicPressure, systolicPressure),
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 16.w,
                                                                                fontFamily: 'Inter',
                                                                                color: AppColors.basicwhiteColor,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 8.h),
                                                          Text(
                                                            'Все отлично! Ваше артериальное давление соответсвует норме',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14.w,
                                                              fontFamily: 'Inter',
                                                              color: AppColors.basicwhiteColor,
                                                            ),
                                                          ),
                                                          SizedBox(height: 16.h),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (health != null) SizedBox(height: 16.h),
                                          if (health != null)
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8.r),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.r),
                                                  color: AppColors.darkGreenColor.withOpacity(0.5),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 8.h),
                                                      Text(
                                                        'Ваше самочувствие',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16.w,
                                                          fontFamily: 'Inter',
                                                          color: AppColors.basicwhiteColor,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      Container(
                                                        width: double.infinity,
                                                        height: 1,
                                                        color: AppColors.basicwhiteColor,
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                width: 1,
                                                                color: AppColors.basicwhiteColor,
                                                              ),
                                                              borderRadius: BorderRadius.circular(8.r),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal: 8.w,
                                                                vertical: 8.h,
                                                              ),
                                                              child: Text(
                                                                health ?? 'Нормальное',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 14.sp,
                                                                  fontFamily: 'Inter',
                                                                  color: AppColors.basicwhiteColor,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 16.w),
                                                          Text(
                                                            comment ?? '',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14.sp,
                                                              fontFamily: 'Inter',
                                                              color: AppColors.basicwhiteColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8.h),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (conditions.isNotEmpty) SizedBox(height: 16.h),
                                          if (conditions.isNotEmpty)
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Условия измерения',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.w,
                                                  fontFamily: 'Inter',
                                                  color: AppColors.basicwhiteColor,
                                                ),
                                              ),
                                            ),
                                          if (conditions.isNotEmpty) SizedBox(height: 8.h),
                                          if (conditions.isNotEmpty)
                                            SizedBox(
                                              width: double.infinity,
                                              child: Wrap(
                                                spacing: 4.w,
                                                runSpacing: 8.h,
                                                children: [
                                                  for (var text in conditions)
                                                    PortionButton(
                                                      haveNullSize: true,
                                                      textColor: AppColors.basicwhiteColor,
                                                      backgroundColor: AppColors.darkGreenColor.withOpacity(0.5),
                                                      borderColor: Color(0x0000000),
                                                      text: text,
                                                    )
                                                ],
                                              ),
                                            ),
                                          SizedBox(height: 16.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              WidgetButton(
                                onTap: () => addNewValue(),
                                boxShadow: true,
                                color: AppColors.darkGreenColor,
                                text: 'добавить новое измерение'.toUpperCase(),
                              ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        );
                      });
                }
                else if (pressureState is PressureNotConnectedState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: ErrorHandler(
                      addValueFunction: () => addNewValue(),
                    ),
                  );
                }
                else if (pressureState is PressureLoadingState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: Center(
                      child: ProgressIndicatorWidget(isWhite: true),
                    ),
                  );
                }
                else if (pressureState is PressureErrorState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: Center(
                        child: ErrorWithReload(
                            isWhite: true,
                            callback: () {
                              widget.isInit.select(false);
                              widget.isPulseInit.select(false);
                              context.read<PressureBloc>().add(PressureGetEvent(widget.selectedDate.date, widget.isRequested));
                              context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
                            },
                        )),
                  );
                }

                return Container();
              }),
            ],
          ),
        ),
        BlocBuilder<PressureBloc, PressureState>(builder: (context, pressureState) {
          if (pressureState is PressureNotConnectedState) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: WidgetButton(
                        onTap: (){
                          context.read<PressureBloc>().add(PressuredConnectedEvent(widget.selectedDate.date, widget.isRequested));
                          context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
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
          return Container();
        }),
      ],
    );
  }

  addNewValue(){
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
        color: AppColors.darkGreenColor,
        title: 'Добавить измерение',
        content: ClientSensorsPressureAddSheet(
          date: widget.selectedDate.date,
        ),
      ),
    ).then((val) {
      if (val == true) {
        widget.isInit.select(false);
        widget.isPulseInit.select(false);
        context.read<PressureBloc>().add(PressureUpdateEvent(widget.selectedDate.date, widget.isRequested));
        context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
      }
    });
  }

  checkAritmia() {
    if ((pulse > 100 || pulse < 60) && pulse != 0) isAritmia = true;
  }

  getRequested() async {
    List<HealthDataType> healthDataType = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC, HealthDataType.BLOOD_PRESSURE_SYSTOLIC];

    List<HealthDataAccess> permissions = [HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE];

    final requested = Platform.isAndroid
        ? await healthFit.hasPermissions(healthDataType, permissions: permissions)
        : await healthFit.requestAuthorization(healthDataType, permissions: permissions);

    if (Platform.isAndroid) {
      if (requested == true) {
        widget.isRequested.select(true);
      } else {
        widget.isRequested.select(false);
      }
    }
  }

  double getPercent(int diastolic, int systolic) {
    if (
        // diastolic < 80
        // ||
        systolic < 120) {
      return 0.07;
    } else if (
        // (diastolic >= 80 && diastolic < 85)
        //  &&
        (systolic >= 120 && systolic < 130)) {
      return 0.24;
    } else if (
        // (diastolic >= 85 && diastolic < 90)
        //  &&
        (systolic >= 130 && systolic < 140)) {
      return 0.415;
    } else if (
        // (diastolic >= 90 && diastolic < 100)
        //  ||
        (systolic >= 140 && systolic < 160)) {
      return 0.585;
    } else if (
        // (diastolic >= 100 && diastolic < 110)
        // ||
        (systolic >= 160 && systolic < 180)) {
      return 0.755;
    } else if (
        // diastolic >= 110
        //  ||
        systolic >= 180) {
      return 0.93;
    } else {
      return 0.5;
    }
  }

  Color getPressureColor(int diastolic, int systolic) {
    if (systolic < 80 || systolic < 120) {
      return AppColors.blueSecondaryColor;
    } else if (
        // (diastolic >= 80 && diastolic < 85)
        //  &&
        (systolic >= 120 && systolic < 130)) {
      return AppColors.greenLightColor;
    } else if (
        // (diastolic >= 85 && diastolic < 90) &&
        (systolic >= 130 && systolic < 140)) {
      return AppColors.orangeColor;
    } else if (
        // (diastolic >= 90 && diastolic < 100) ||
        (systolic >= 140 && systolic < 160)) {
      return AppColors.tints3Color;
    } else if (
        // (diastolic >= 100 && diastolic < 110) ||
        (systolic >= 160 && systolic < 180)) {
      return Color(0xFFCD5B6F);
    } else if (
        // diastolic >= 110 ||
        systolic >= 180) {
      return AppColors.redColor;
    } else {
      return AppColors.grey50Color;
    }
  }

  String getPressureStatus(int diastolic, int systolic) {
    // diastolic < 80 ||
    if (systolic < 120) {
      return "Оптимальное";
    } else if (
        // (diastolic >= 80 && diastolic < 85) &&
        (systolic >= 120 && systolic < 130)) {
      return "Нормальное";
    } else if (
        // (diastolic >= 85 && diastolic < 90) &&
        (systolic >= 130 && systolic < 140)) {
      return "Высокое нормальное";
    } else if (
        // (diastolic >= 90 && diastolic < 100) ||
        (systolic >= 140 && systolic < 160)) {
      return "I степень (мягкая АГ)";
    } else if (
        // (diastolic >= 100 && diastolic < 110) ||
        (systolic >= 160 && systolic < 180)) {
      return "II степень (умеренная АГ)";
      // diastolic >= 110 ||
    } else if (systolic >= 180) {
      return "III степень (тяжелая АГ)";
    } else {
      return "Изолированна\nсистолическая гипертезия";
    }
  }

  String getSystolicTitle(int diastolic, int systolic) {
    if (
        // diastolic < 80 ||
        systolic < 120) {
      return "СИС < 120";
    } else if (
        // (diastolic >= 80 && diastolic < 85)
        //  &&
        (systolic >= 120 && systolic < 130)) {
      return "СИС < 130";
    } else if
        // diastolic >= 85 && diastolic < 90) &&
        (systolic >= 130 && systolic < 140) {
      return "СИС 130-139";
    } else if (
        // (diastolic >= 90 && diastolic < 100) ||
        (systolic >= 140 && systolic < 160)) {
      return "СИС 140-159";
    } else if (
        // (diastolic >= 100 && diastolic < 110) ||
        (systolic >= 160 && systolic < 180)) {
      return "СИС 160-179";
    } else if
        // (diastolic >= 110 ||
        (systolic >= 180) {
      return "СИС >= 180 ";
    } else {
      return "СИС >= 140 ";
    }
  }

  String getDiastolicTitle(int diastolic, int systolic) {
    if (diastolic < 80 || systolic < 120) {
      return "ДИА < 80";
    } else if ((diastolic >= 80 && diastolic < 85) && (systolic >= 120 && systolic < 130)) {
      return "ДИА < 85";
    } else if ((diastolic >= 85 && diastolic < 90) && (systolic >= 130 && systolic < 140)) {
      return "ДИА 85-89";
    } else if ((diastolic >= 90 && diastolic < 100) || (systolic >= 140 && systolic < 160)) {
      return "ДИА 90-99";
    } else if ((diastolic >= 100 && diastolic < 110) || (systolic >= 160 && systolic < 180)) {
      return "ДИА 100-109";
    } else if (diastolic >= 110 || systolic >= 180) {
      return 'ДИА >= 110';
    } else {
      return "ДИА < 90";
    }
  }

  pulseReconnected() async {
    List<HealthDataType> healthDataType = [HealthDataType.HEART_RATE];

    List<HealthDataAccess> permissions = [HealthDataAccess.READ_WRITE];
    bool requested = await healthFit.requestAuthorization(healthDataType, permissions: permissions);
    if (requested) {
      context.read<PressureBloc>().add(PressureGetEvent(widget.selectedDate.date, widget.isRequested));
      context.read<PulseBloc>().add(PulseGetEvent(widget.selectedDate.date));
    }
  }

  Widget ColorContainer({
    required Color color,
  }) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 8.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.r),
          color: color,
        ),
      ),
    );
  }

  getPressure(ClientSensorsView? view) {
    if (view != null) {
      var pressure = view.healthSensorVal?.toDouble();

      if (pressure != null) {
        String newTest = pressure.toString();

        List values = newTest.split(".");

        diastolicPressure = int.parse(setDecimalDigits(values.first));
        systolicPressure = int.parse(setDecimalDigits(values.last));
      }

      if (view.dateSensor != null) {
        pressureDate = view.dateSensor!;
      }

      if (view.comment != null) {
        comment = view.comment;
      }

      if (view.health != null) {
        health = view.health;
      }

      if (view.conditions != null) {
        conditions = view.conditions!.split(";").toList();
      }
    }
  }

  getPulse(List<ClientSensorsView>? view) {
    if (view != null && view.isNotEmpty) {
      bool isExist = view.any((element) => element.dateSensor == pressureDate);

      if (isExist) {
        for (var element in view) {
          if (element.dateSensor == pressureDate) {
            if (element.healthSensorVal?.toInt() != null) pulse = element.healthSensorVal!.toInt();
            break;
          }
        }
      }
    }
  }

  String setDecimalDigits(String number) {
    String firstChar = number[0];

    if (number.length == 1) {
      if (firstChar == "1" || firstChar == "2") {
        return number + "00";
      }
      return number + "0";
    }

    if ((firstChar == "1" || firstChar == "2") && number.length == 2) {
      return number + "0";
    }
    return number;
  }
}
