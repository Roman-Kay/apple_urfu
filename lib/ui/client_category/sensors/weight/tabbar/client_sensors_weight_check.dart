import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/weight/weight_bloc.dart';
import 'package:garnetbook/bloc/client/target/target_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/target/target_view_model.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/my_day/bottom_sheets/client_my_day_tracker_slot_finish.dart';
import 'package:garnetbook/ui/client_category/sensors/weight/bottom_sheet/client_sensors_weight_add_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/calendar/calendar_row.dart';
import 'package:garnetbook/widgets/error_handler/error_handler_sensors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/target_line_chart.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:health/health.dart';


class ClientSensorsWeightCheck extends StatefulWidget {
  const ClientSensorsWeightCheck({super.key, required this.isRequested, required this.selectedDate});

  final RequestedValue isRequested;
  final SelectedDate selectedDate;

  @override
  State<ClientSensorsWeightCheck> createState() => _ClientSensorsWeightCheckState();
}

class _ClientSensorsWeightCheckState extends State<ClientSensorsWeightCheck> with AutomaticKeepAliveClientMixin{
  Map<DateTime, double> weightList = {};
  Health health = Health();
  List<String> weekList = [];
  int dayQuantity = 7;
  int? height;
  List<int> targetWeight = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TargetBloc, TargetState>(builder: (context, targetState) {
      if (targetState is TargetLoadedState) {
        getTargetWeight(targetState.view);
      }

      return Stack(
        children: [
          BlocBuilder<WeightBloc, WeightState>(builder: (context, state) {
            if (state is WeightLoadedState) {
              getRequested();

              if (state.targetView?.completed == true) {
                return ListenableBuilder(
                    listenable: widget.selectedDate,
                    builder: (context, child) {

                      return Stack(
                        children: [
                          RefreshIndicator(
                            color: AppColors.darkGreenColor,
                            onRefresh: () {
                              context.read<WeightBloc>().add(WeightGetEvent(7, widget.selectedDate.date));
                              return Future.delayed(const Duration(seconds: 1));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              child: ListView(
                                children: [
                                  SizedBox(height: 24.h),
                                  Container(
                                    width: double.infinity,
                                    height: 68.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: AppColors.basicwhiteColor.withOpacity(0.4),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      child: CalendarRow(
                                        color: AppColors.basicwhiteColor,
                                        selectedDate: widget.selectedDate.date,
                                        onPressedDateCon: () {
                                          DatePickerBdaya.showDatePicker(
                                            context,
                                            showTitleActions: true,
                                            minTime: DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day),
                                            maxTime: DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day,
                                            ),
                                            onConfirm: (date) {
                                              widget.selectedDate.select(date);
                                              context.read<WeightBloc>().add(WeightGetEvent(7, widget.selectedDate.date));
                                            },
                                            currentTime: widget.selectedDate.date,
                                            locale: LocaleType.ru,
                                          );
                                        },
                                        onPressedLeft: () {
                                          widget.selectedDate.select(widget.selectedDate.date.subtract(Duration(days: 1)));
                                          context.read<WeightBloc>().add(WeightGetEvent(7, widget.selectedDate.date));
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
                                            context.read<WeightBloc>().add(WeightGetEvent(7, widget.selectedDate.date));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                  Container(
                                    height: 116.h,
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: AppColors.basicwhiteColor.withOpacity(0.7),
                                    ),
                                    child: state.currentVal != null && state.currentVal!.healthSensorVal != null
                                        ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            width: 122.w,
                                            child: Text(
                                              "Текущее значение",
                                              style: TextStyle(
                                                color: AppColors.darkGreenColor,
                                                fontFamily: 'Inter',
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 16.w),
                                            Text(
                                              removeDecimalZeroFormat(state.currentVal!.healthSensorVal!.toDouble()),
                                              style: TextStyle(
                                                color: AppColors.darkGreenColor,
                                                fontFamily: 'Inter',
                                                fontSize: 64.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              'кг',
                                              style: TextStyle(
                                                color: AppColors.darkGreenColor,
                                                fontFamily: 'Inter',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                        : Center(
                                      child: Text(
                                        'Данные отсутствуют',
                                        style: TextStyle(
                                          color: AppColors.darkGreenColor,
                                          fontFamily: 'Inter',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w).copyWith(bottom: 16.h),
                              child: WidgetButton(
                                onTap: () => addNewValue(state),
                                color: AppColors.darkGreenColor,
                                text: setAddRestriction(state.currentVal?.dateSensor)
                                    ? 'Изменить'.toUpperCase()
                                    : 'добавить'.toUpperCase(),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              }
              else {
                return Stack(
                  children: [
                    RefreshIndicator(
                      color: AppColors.darkGreenColor,
                      onRefresh: () {
                        context.read<WeightBloc>().add(WeightUpdateEvent(dayQuantity, widget.selectedDate.date));
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        child: ListView(
                          children: [
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: AppColors.darkGreenColor.withOpacity(0.8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            'текущее значение:',
                                            style: TextStyle(
                                              color: AppColors.basicwhiteColor,
                                              fontFamily: 'Inter',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        state.currentVal != null && state.currentVal!.healthSensorVal != null
                                            ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              removeDecimalZeroFormat(state.currentVal!.healthSensorVal!.toDouble()),
                                              style: TextStyle(
                                                color: AppColors.basicwhiteColor,
                                                fontFamily: 'Inter',
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              'кг',
                                              style: TextStyle(
                                                color: AppColors.basicwhiteColor,
                                                fontFamily: 'Inter',
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ],
                                        )
                                            : Text(
                                          'Нет информации',
                                          style: TextStyle(
                                            color: AppColors.darkGreenColor,
                                            fontFamily: 'Inter',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: AppColors.darkGreenColor.withOpacity(0.8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            'целевое значение:',
                                            style: TextStyle(
                                              color: AppColors.basicwhiteColor,
                                              fontFamily: 'Inter',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        state.targetView != null
                                            ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              getExpectedWeight(state.targetView),
                                              style: TextStyle(
                                                color: AppColors.basicwhiteColor,
                                                fontFamily: 'Inter',
                                                fontSize: 36.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              'кг',
                                              style: TextStyle(
                                                color: AppColors.basicwhiteColor,
                                                fontFamily: 'Inter',
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          ],
                                        )
                                            : Text(
                                          'Нет информации',
                                          style: TextStyle(
                                            color: AppColors.darkGreenColor,
                                            fontFamily: 'Inter',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (state.targetView != null && state.targetView!.dateA != null && state.targetView!.dateB != null)
                              Container(
                                margin: EdgeInsets.only(top: 40.h),
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: AppColors.basicwhiteColor.withOpacity(0.2)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Путь к цели',
                                      style: TextStyle(
                                        color: AppColors.basicwhiteColor,
                                        fontFamily: 'Inter',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      height: 1,
                                      color: AppColors.basicwhiteColor,
                                    ),
                                    SizedBox(height: 16.h),
                                    TargetLineChart(
                                      isOpacity: true,
                                      dateStart: state.targetView!.dateA,
                                      dateEnd: state.targetView!.dateB,
                                      pointA: state.targetView!.pointA ?? 0,
                                      pointB: state.targetView!.pointB ?? 0,
                                      userSpots: getTable(state.targetView),
                                    ),
                                  ],
                                ),
                              ),

                            SizedBox(height: 90.h),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.w).copyWith(bottom: 16.h),
                        child: WidgetButton(
                          onTap: () => addNewValue(state),
                          color: AppColors.darkGreenColor,
                          text: setAddRestriction(state.currentVal?.dateSensor) ? 'Изменить'.toUpperCase() : 'добавить'.toUpperCase(),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            else if (state is WeightNotConnectedState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                child: ErrorHandler(
                  addValueFunction: () => addNewValue(state),
                ),
              );
            }
            else if (state is WeightErrorState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.6,
                child: Center(
                  child: ErrorWithReload(
                    isWhite: true,
                    callback: () {
                      context.read<WeightBloc>().add(WeightGetEvent(dayQuantity, widget.selectedDate.date));
                    },
                  ),
                ),
              );
            }
            else if (state is WeightLoadingState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.6,
                child: Center(
                  child: ProgressIndicatorWidget(isWhite: true),
                ),
              );
            }
            return Container();
          }),
          BlocBuilder<WeightBloc, WeightState>(builder: (context, state) {
            if (state is WeightNotConnectedState) {
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
                            context.read<WeightBloc>().add(WeightConnectedEvent(dayQuantity, widget.selectedDate.date));
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

  addNewValue(state) async{
    showModalBottomSheet(
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (context) => ModalSheet(
        color: AppColors.darkGreenColor,
        title: setAddRestriction(state.currentVal?.dateSensor) ? 'Изменить вес' : 'Добавить вес',
        content: ClientSensorsWeightAddScreen(
          date: widget.selectedDate.date,
          view: state.currentVal,
        ),
      ),
    ).then((val) {
      if (val != null) {
        if (targetWeight.isNotEmpty) {
          bool isFinishTarget = false;

          for (var element in targetWeight) {
            if (element == val) {
              isFinishTarget = true;
              break;
            }
          }

          if (isFinishTarget) {
            showModalBottomSheet(
              useSafeArea: true,
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => Padding(
                padding: const EdgeInsets.only(top: 50),
                child: ModalSheet(
                    title: "Поздравляем!",
                    content: ClientMyDayTrackerSlotsFinish(
                      isTracker: false,
                      clientTrackerId: null,
                    )),
              ),
            );
            context.read<TargetBloc>().add(TargetCheckEvent());
          }
        }

        context.read<WeightBloc>().add(WeightUpdateEvent(dayQuantity, widget.selectedDate.date));
      }
    });
  }

  getRequested() async {
    final requested = Platform.isAndroid
        ? await health.hasPermissions([HealthDataType.WEIGHT], permissions: [HealthDataAccess.READ_WRITE])
        : await health.requestAuthorization([HealthDataType.WEIGHT], permissions: [HealthDataAccess.READ_WRITE]);
    ;

    if (Platform.isAndroid) {
      if (requested == true) {
        widget.isRequested.select(true);
      } else {
        widget.isRequested.select(false);
      }
    }
  }

  bool setAddRestriction(String? date) {
    if (date != null) {
      DateTime testDate = DateTime.parse(date);

      if (testDate.day == DateTime.now().day && testDate.month == DateTime.now().month && testDate.year == DateTime.now().year) {
        return true;
      }
      return false;
    }
    return false;
  }

  getTargetWeight(List<ClientTargetsView>? view) {
    if (view != null && view.isNotEmpty) {
      view.forEach((element) {
        if (element.target?.name == "Сбросить вес" || element.target?.name == "Набрать вес") {
          if (element.pointB != null && !targetWeight.contains(element.pointB)) {
            targetWeight.add(element.pointB!);
          }
        }
      });
    }
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  List<FlSpot> getTable(ClientTargetsView? view) {
    if (view != null && view.pointA != null && view.pointB != null && view.dateA != null && view.dateB != null) {
      if (view.pointA! < view.pointB!) {
        return [FlSpot(1, 3), FlSpot(2, 3), FlSpot(8, 7), FlSpot(9, 7)];
      } else {
        return [FlSpot(1, 7), FlSpot(2, 7), FlSpot(8, 3), FlSpot(9, 3)];
      }
    }
    return [];
  }

  String getCurrentWeight(ClientSensorsView? view) {
    if (view != null && view.healthSensorVal != null) {
      return view.healthSensorVal!.toInt().toString();
    }
    return "0";
  }

  String getExpectedWeight(ClientTargetsView? view) {
    if (view != null && view.pointB != null) {
      return view.pointB.toString();
    }
    return "0";
  }
}
