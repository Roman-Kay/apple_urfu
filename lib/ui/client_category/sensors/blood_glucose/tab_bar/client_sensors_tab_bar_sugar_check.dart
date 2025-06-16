import 'dart:io';
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/blood_glucose/blood_glucose_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_glucose/bottom_sheet/client_sensors_blood_glucose_info_sheet.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_glucose/bottom_sheet/client_sensors_blood_glucose_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/portion_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/error_handler/error_handler_sensors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:health/health.dart';

class ClientTabBarSugarCheck extends StatefulWidget {
  const ClientTabBarSugarCheck({Key? key, required this.selectedDate, required this.isRequested}) : super(key: key);

  final SelectedDate selectedDate;
  final RequestedValue isRequested;

  @override
  State<ClientTabBarSugarCheck> createState() => _ClientTabBarSugarCheckState();
}

class _ClientTabBarSugarCheckState extends State<ClientTabBarSugarCheck> with AutomaticKeepAliveClientMixin {
  bool isMol = true;
  double value = 0;
  double valueMol = 0;
  List<String> conditions = [];
  Health health = Health();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
        listenable: widget.selectedDate,
        builder: (context, child) {
          return Stack(
            children: [
              BlocBuilder<BloodGlucoseBloc, BloodGlucoseState>(builder: (context, state) {
                if(state is BloodGlucoseLoadedState){
                  getValue(state.currentVal);
                  getConditions(state.currentVal?.conditions);

                  return RefreshIndicator(
                    color: AppColors.darkGreenColor,
                    onRefresh: () {
                      context.read<BloodGlucoseBloc>().add(BloodGlucoseGetEvent(widget.selectedDate.date, widget.isRequested));
                      return Future.delayed(const Duration(seconds: 1));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: ListView(
                        children: [
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Text(
                                'Единицы\nизмерения:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  height: 1,
                                  fontFamily: 'Inter',
                                  color: AppColors.basicwhiteColor,
                                ),
                              ),
                              Spacer(),
                              Container(
                                height: 44.h,
                                width: 226.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppColors.vivaMagentaColor.withOpacity(0.7),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                                      child: AnimatedAlign(
                                        duration: Duration(milliseconds: 100),
                                        alignment: isMol ? Alignment.centerLeft : Alignment.centerRight,
                                        child: Container(
                                          height: 36.h,
                                          width: 109.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(9.r),
                                            color: AppColors.basicwhiteColor,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 10,
                                                color: AppColors.basicblackColor.withOpacity(0.1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 109.w,
                                            height: 36.h,
                                            child: FormForButton(
                                              borderRadius: BorderRadius.circular(8.r),
                                              onPressed: () {
                                                setState(() {
                                                  isMol = true;
                                                });
                                              },
                                              child: Center(
                                                child: Text(
                                                  'Ммоль/л',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp,
                                                    height: 1,
                                                    fontFamily: 'Inter',
                                                    color: !isMol ? AppColors.basicwhiteColor : AppColors.vivaMagentaColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 109.w,
                                            height: 36.h,
                                            child: FormForButton(
                                              borderRadius: BorderRadius.circular(8.r),
                                              onPressed: () {
                                                setState(() {
                                                  isMol = false;
                                                });
                                              },
                                              child: Center(
                                                child: Text(
                                                  'Мг/дл',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp,
                                                    height: 1,
                                                    fontFamily: 'Inter',
                                                    color: isMol ? AppColors.basicwhiteColor : AppColors.vivaMagentaColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            clipBehavior: Clip.hardEdge,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: AppColors.basicwhiteColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap:(){
                                        if (getValueText(state.currentVal) == "Гипогликемия") {
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
                                              title: 'Гипогликемия',
                                              content: BloodGlucoseInfoSheet(),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: getValueColor(state.currentVal),
                                          borderRadius: BorderRadius.circular(99)
                                        ),
                                        child: Center(
                                          child: Icon(Icons.info_outline,
                                              size: 16,
                                              color: getValueText(state.currentVal) == "Гипогликемия"
                                                  ? AppColors.basicwhiteColor
                                                  : Colors.transparent),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      getValueText(state.currentVal),
                                      style: TextStyle(
                                        height: 2.h,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.h,
                                        fontFamily: 'Inter',
                                        color: AppColors.basicwhiteColor,
                                      ),
                                    ),

                                    const Spacer(),
                                    SizedBox(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          children: [
                                            Text(
                                              isMol ? removeDecimalZeroFormat(valueMol) : removeDecimalZeroFormat(value),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 64.h,
                                                height: 1,
                                                fontFamily: 'Inter',
                                                color: AppColors.basicwhiteColor,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              isMol ? 'ммоль/л' : "мг/дл",
                                              style: TextStyle(
                                                height: 2.h,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.h,
                                                fontFamily: 'Inter',
                                                color: AppColors.basicwhiteColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          if (conditions.isNotEmpty)
                            Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              decoration: BoxDecoration(
                                color: AppColors.darkGreenColor.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Когда вы проводили измерение?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.basicwhiteColor,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: AppColors.basicwhiteColor
                                  ),
                                  SizedBox(height: 10.h),
                                  Wrap(
                                    spacing: 4.w,
                                    runSpacing: 8.h,
                                    children: [
                                      for (var text in conditions)
                                        PortionButton(
                                          haveNullSize: true,
                                          textColor: AppColors.darkGreenColor,
                                          gradient: AppColors.gradientTurquoise,
                                          borderColor: Color(0x0000000),
                                          text: text,
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          if (state.currentVal?.health != null)
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.darkGreenColor.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ваше самочувствие',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.basicwhiteColor,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: AppColors.basicwhiteColor
                                  ),
                                  SizedBox(height: 10.h),
                                  Wrap(
                                    spacing: 4.w,
                                    runSpacing: 8.h,
                                    children: [
                                      PortionButton(
                                        haveNullSize: true,
                                        textColor: AppColors.darkGreenColor,
                                        gradient: AppColors.gradientTurquoise,
                                        borderColor: Color(0x0000000),
                                        text: state.currentVal?.health ?? 'Нормальное',
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          if (state.currentVal?.health != null) SizedBox(height: 16.h),
                          if (state.currentVal?.comment != null)
                            CustomTextFieldLabel(
                              controller: TextEditingController(text: state.currentVal?.comment),
                              enabled: false,
                              textColor: AppColors.vivaMagentaColor,
                              hintText: 'Как вы себя чувствуете?',
                              keyboardType: TextInputType.multiline,
                              maxLines: 15,
                            ),
                          SizedBox(height: 150.h),
                        ],
                      ),
                    ),
                  );
                }
                else if(state is BloodGlucoseLoadingState){
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: Center(
                      child: ProgressIndicatorWidget(isWhite: true),
                    ),
                  );
                }
                else if(state is BloodGlucoseErrorState){
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: Center(
                        child: ErrorWithReload(
                          isWhite: true,
                            callback: () {
                              context.read<BloodGlucoseBloc>().add(BloodGlucoseGetEvent(widget.selectedDate.date, widget.isRequested));
                            }
                        )),
                  );
                }
                else if(state is BloodGlucoseNotConnectedState){
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: ErrorHandler(
                      addValueFunction: () => addNewVal(),
                    ),
                  );
                }
                return Container();

              }),
              BlocBuilder<BloodGlucoseBloc, BloodGlucoseState>(builder: (context, state) {
                if(state is BloodGlucoseLoadedState){
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 16.h),
                      child: WidgetButton(
                        onTap: () => addNewVal(),
                        boxShadow: true,
                        color: AppColors.darkGreenColor,
                        text: 'добавить запись'.toUpperCase(),
                      ),
                    ),
                  );
                }
                else if(state is BloodGlucoseNotConnectedState){
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
                                context.read<BloodGlucoseBloc>().add(BloodGlucoseConnectedEvent(widget.selectedDate.date, widget.isRequested));
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
        });
  }

  addNewVal(){
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
        title: 'Добавить запись',
        content: ClientSensorsBloodGlucoseSheet(
          date: widget.selectedDate.date,
        ),
      ),
    ).then((val) async {
      if (val == true) {
        context.read<BloodGlucoseBloc>().add(BloodGlucoseUpdateEvent(widget.selectedDate.date, widget.isRequested));
      }
    });
  }

  getRequested() async {
    final requested = Platform.isAndroid
        ? await health.hasPermissions([HealthDataType.BLOOD_GLUCOSE], permissions: [HealthDataAccess.READ_WRITE])
        : await health.requestAuthorization([HealthDataType.BLOOD_GLUCOSE], permissions: [HealthDataAccess.READ_WRITE]);

    if (Platform.isAndroid) {
      if (requested == true) {
        widget.isRequested.select(true);
      } else {
        widget.isRequested.select(false);
      }
    }
  }

  getConditions(String? value) {
    conditions.clear();

    if (value != null) {
      conditions = value.split(';').toList();
    }
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  String getValueText(ClientSensorsView? view) {
    if (view != null && view.healthSensorVal != null) {
      double mol = view.healthSensorVal!.toDouble();

      if (mol < 3.9) {
        return "Гипогликемия";
      } else if (mol <= 5.5 && mol >= 3.9) {
        return "Норма";
      } else if (mol > 5.6) {
        return "Уровень сахара выше нормы";
      }
      return "";
    }
    return "";
  }

  Color getValueColor(ClientSensorsView? view) {
    if (view != null && view.healthSensorVal != null) {
      double mol = view.healthSensorVal!.toDouble();

      if (mol < 3.9) {
        return AppColors.blueColor;
      } else if (mol <= 5.5 && mol >= 3.9) {
        return AppColors.ultralightgreenColor;
      } else if (mol > 5.6) {
        return AppColors.redColor;
      }
      return AppColors.blueColor;
    }
    return Colors.transparent;
  }

  getValue(ClientSensorsView? view) {
    value = 0;
    valueMol = 0;

    if (view != null && view.healthSensorVal != null) {
      valueMol = view.healthSensorVal!.toDouble();
      value = valueMol * 18.018;
    }
  }
}
