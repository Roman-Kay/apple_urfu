import 'dart:collection';
import 'dart:io';
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/health/blood_glucose/blood_glucose_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_glucose/bottom_sheet/client_sensors_blood_glucose_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/calendar/calendar_row.dart';
import 'package:garnetbook/widgets/error_handler/error_handler_sensors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/custom_blood_glucose_graphic.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:health/health.dart';

class GlucoseItem {
  double value;
  bool isInsulin;
  String? comment;
  String? health;
  String? conditions;

  GlucoseItem({this.comment, this.health, this.conditions, this.isInsulin = false, required this.value});
}

class ClientTabBarSugarDynamic extends StatefulWidget {
  const ClientTabBarSugarDynamic({required this.selectedDate, required this.isRequested, super.key});

  final SelectedDate selectedDate;
  final RequestedValue isRequested;

  @override
  State<ClientTabBarSugarDynamic> createState() => _ClientTabBarSugarDynamicState();
}

class _ClientTabBarSugarDynamicState extends State<ClientTabBarSugarDynamic> with AutomaticKeepAliveClientMixin {
  Map<DateTime, GlucoseItem> glucoseList = {};
  Map<DateTime, GlucoseItem> shortedList = {};
  Health health = Health();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        BlocBuilder<BloodGlucoseBloc, BloodGlucoseState>(builder: (context, state) {
          if (state is BloodGlucoseLoadedState) {
            getRequested();
            getList(state.list);

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
                    ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: AppColors.basicwhiteColor.withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.r,
                                color: AppColors.basicblackColor.withOpacity(0.1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Column(
                              children: [
                                SizedBox(height: 10.h),
                                CalendarRow(
                                  color: AppColors.basicwhiteColor,
                                  selectedDate: widget.selectedDate.date,
                                  onPressedDateCon: () {
                                    DatePickerBdaya.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
                                      maxTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                      onConfirm: (newDate) {
                                        widget.selectedDate.select(newDate);
                                        context.read<BloodGlucoseBloc>().add(BloodGlucoseGetEvent(newDate, widget.isRequested));
                                      },
                                      currentTime: widget.selectedDate.date,
                                      locale: LocaleType.ru,
                                    );
                                  },
                                  onPressedLeft: () {
                                    widget.selectedDate.select(widget.selectedDate.date.subtract(Duration(days: 1)));
                                    context.read<BloodGlucoseBloc>().add(BloodGlucoseGetEvent(widget.selectedDate.date, widget.isRequested));
                                  },
                                  onPressedRight: () {
                                    if (widget.selectedDate.date.add(Duration(days: 1)).isAfter(DateTime.now())) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            'Невозможно узнать будущие показатели',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      widget.selectedDate.select(widget.selectedDate.date.add(Duration(days: 1)));
                                      context.read<BloodGlucoseBloc>().add(BloodGlucoseGetEvent(widget.selectedDate.date, widget.isRequested));
                                    }
                                  },
                                ),
                                SizedBox(height: 16.h),

                                if(glucoseList.isNotEmpty)
                                  Column(
                                    children: [
                                      CustomBloodGlucoseGraphic(glucoseList: shortedList),
                                      SizedBox(height: 16.h),
                                      ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: glucoseList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final value = glucoseList.values.toList()[index];
                                          final date = glucoseList.keys.toList()[index];
                                          List<String> conditions = getConditions(value.conditions);

                                          return Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 8.w),
                                                        child: Text(
                                                          DateFormatting().formatTime(date),
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 16.sp,
                                                            fontFamily: 'Inter',
                                                            color: AppColors.basicwhiteColor,
                                                          ),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      CircleAvatar(
                                                        radius: 5.r,
                                                        backgroundColor: getValueColor(value.value),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            removeDecimalZeroFormat(value.value),
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 18.sp,
                                                              fontFamily: 'Inter',
                                                              color: AppColors.basicwhiteColor,
                                                            ),
                                                          ),
                                                          SizedBox(width: 8.w),
                                                          Text(
                                                            'ммоль/л',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 10.sp,
                                                              fontFamily: 'Inter',
                                                              color: AppColors.basicwhiteColor,
                                                            ),
                                                          ),
                                                          SizedBox(width: 8.w),
                                                          if (value.isInsulin)
                                                            SvgPicture.asset(
                                                              'assets/images/syringe.svg',
                                                              height: 24.h,
                                                            )
                                                          else
                                                            SizedBox(
                                                              width: 24.w,
                                                              child: Center(
                                                                child: Container(
                                                                  width: (13.5).w,
                                                                  height: 2.5,
                                                                  decoration: BoxDecoration(gradient: AppColors.gradientTurquoiseReverse),
                                                                ),
                                                              ),
                                                            ),
                                                          SizedBox(width: 8.w),
                                                          if (value.health != null)
                                                            Text(
                                                              value.health ?? 'Нормальное',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 12.sp,
                                                                fontFamily: 'Inter',
                                                                color: AppColors.basicwhiteColor,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (conditions.isNotEmpty)
                                                  Wrap(
                                                    spacing: 4.w,
                                                    runSpacing: 8.h,
                                                    children: [
                                                      for (var text in conditions)
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            gradient: AppColors.gradientTurquoise,
                                                            borderRadius: BorderRadius.circular(8.r),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                                            child: Text(
                                                              text,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 12.sp,
                                                                fontFamily: 'Inter',
                                                                color: AppColors.darkGreenColor,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                if (conditions.isNotEmpty) SizedBox(height: 10.h),
                                                if (value.comment != null)
                                                  ClipRRect(
                                                    clipBehavior: Clip.hardEdge,
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: AppColors.basicwhiteColor.withOpacity(0.5),
                                                          border: Border.all(
                                                            color: AppColors.seaColor,
                                                          ),
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                                        child: Text(
                                                          value.comment ?? "",
                                                          style: TextStyle(
                                                            fontFamily: "Inter",
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 12.sp,
                                                            color: AppColors.vivaMagentaColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (value.comment != null) SizedBox(height: 10.h),
                                                Container(
                                                  height: 1,
                                                  decoration: BoxDecoration(
                                                    gradient: AppColors.gradientTurquoise,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 27.h),
                                    ],
                                  )
                                else
                                  SizedBox(
                                    height: 250.h,
                                    child: Center(
                                      child: Text(
                                        "Данные отсутствуют",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.h,
                                          fontFamily: 'Inter',
                                          color: AppColors.basicwhiteColor,
                                        ),
                                      ),
                                    ),
                                  ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            );

          }
          else if (state is BloodGlucoseErrorState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: ErrorWithReload(
                isWhite: true,
                callback: () {
                  context.read<BloodGlucoseBloc>().add(BloodGlucoseGetEvent(widget.selectedDate.date, widget.isRequested));
                },
              ),
            );
          }
          else if (state is BloodGlucoseLoadingState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Center(
                child: ProgressIndicatorWidget(isWhite: true),
              ),
            );
          }
          else if (state is BloodGlucoseNotConnectedState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              child: ErrorHandler(
                addValueFunction: (){
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
                },
              ),
            );
          }
          return Container();
        }),
        BlocBuilder<BloodGlucoseBloc, BloodGlucoseState>(builder: (context, state) {
          if(state is BloodGlucoseNotConnectedState){
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

  List<String> getConditions(String? value) {
    if (value != null) {
      return value.split(';').toList();
    }
    return [];
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  Color getValueColor(double mol) {
    if (mol < 3.9) {
      return AppColors.blueColor;
    } else if (mol <= 5.5 && mol >= 3.9) {
      return AppColors.ultralightgreenColor;
    } else if (mol > 5.6) {
      return AppColors.redColor;
    }
    return AppColors.blueColor;
  }

  getList(List<ClientSensorsView>? list) {
    glucoseList.clear();
    shortedList.clear();

    if (list != null && list.isNotEmpty) {
      list.forEach((element) {
        if (element.healthSensorVal != null && element.dateSensor != null) {
          DateTime test = DateTime.parse(element.dateSensor!);

          glucoseList.putIfAbsent(
              test,
              () => GlucoseItem(
                  value: element.healthSensorVal!.toDouble(),
                  conditions: element.conditions,
                  comment: element.comment,
                  health: element.health,
                  isInsulin: element.insulin ?? false));
        }
      });

      if (glucoseList.isNotEmpty) {
        glucoseList = SplayTreeMap<DateTime, GlucoseItem>.from(glucoseList, (a, b) => b.compareTo(a));

        glucoseList.forEach((key, val){
          if(shortedList.length != 7){
            shortedList.putIfAbsent(key, () => val);
          }
        });
      }
    }
  }
}
