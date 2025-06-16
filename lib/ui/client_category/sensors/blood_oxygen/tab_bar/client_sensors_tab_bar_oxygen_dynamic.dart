import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/blood_oxygen/blood_oxygen_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_oxygen/bottom_sheet/client_blood_oxygen_add_sheet.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/calendar/calendar_row.dart';
import 'package:garnetbook/widgets/error_handler/error_handler_sensors.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/custom_oxygen_graphic.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/modal_sheet.dart';
import 'package:health/health.dart';

class ClientSensorsTabBarOxygenDynamic extends StatefulWidget {
  const ClientSensorsTabBarOxygenDynamic({required this.selectedDate, required this.isRequested, super.key});

  final SelectedDate selectedDate;
  final RequestedValue isRequested;

  @override
  State<ClientSensorsTabBarOxygenDynamic> createState() => _ClientSensorsTabBarOxygenDynamicState();
}

class _ClientSensorsTabBarOxygenDynamicState extends State<ClientSensorsTabBarOxygenDynamic> with AutomaticKeepAliveClientMixin {
  Map<DateTime, double> oxygenList = {};
  Map<DateTime, double> shortedList = {};
  Health health = Health();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        BlocBuilder<BloodOxygenBloc, BloodOxygenState>(builder: (context, state) {
          if (state is BloodOxygenLoadedState) {
            getList(state.list);

            return RefreshIndicator(
              color: AppColors.darkGreenColor,
              onRefresh: () {
                context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(widget.selectedDate.date, widget.isRequested));
                return Future.delayed(const Duration(seconds: 1));
              },
              child: ListView(
                children: [
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.basicwhiteColor.withOpacity(0.6),
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
                              SizedBox(height: 8.h),
                              CalendarRow(
                                selectedDate: widget.selectedDate.date,
                                onPressedDateCon: () {
                                  DatePickerBdaya.showDatePicker(
                                    context,
                                    showTitleActions: true,
                                    minTime: DateTime(2023, 0, 0),
                                    maxTime: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                    ),
                                    onConfirm: (newDate) {
                                      widget.selectedDate.select(newDate);
                                      context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(newDate, widget.isRequested));
                                    },
                                    currentTime: widget.selectedDate.date,
                                    locale: LocaleType.ru,
                                  );
                                },
                                onPressedLeft: () {
                                  widget.selectedDate.select(widget.selectedDate.date.subtract(Duration(days: 1)));
                                  context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(widget.selectedDate.date, widget.isRequested));
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
                                    context
                                        .read<BloodOxygenBloc>()
                                        .add(BloodOxygenGetEvent(widget.selectedDate.date, widget.isRequested));
                                  }
                                },
                              ),

                              if (oxygenList.isNotEmpty)
                                Column(
                                  children: [
                                    SizedBox(height: 12.h),
                                    CustomOxygenGraphic(oxygenList: shortedList),
                                    SizedBox(height: 16.h),
                                    ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: oxygenList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final value = oxygenList.values.toList()[index];
                                        final date = oxygenList.keys.toList()[index];

                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                                          child: Column(
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
                                                          color: AppColors.darkGreenColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          value.toStringAsFixed(0) + "%",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 18.sp,
                                                            fontFamily: 'Inter',
                                                            color: AppColors.darkGreenColor,
                                                          ),
                                                        ),
                                                        SizedBox(width: 12.w),
                                                        CircleAvatar(
                                                          radius: 5.r,
                                                          backgroundColor: getValueColor(value.toInt()),
                                                        ),
                                                        SizedBox(width: 1.w),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          else if (state is BloodOxygenNotConnectedState) {
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
                      title: 'Ввести показатели',
                      content: ClientBloodOxygenAddSheet(date: widget.selectedDate.date),
                    ),
                  ).then((val) {
                    if (val == true) {
                      context.read<BloodOxygenBloc>().add(BloodOxygenUpdateEvent(widget.selectedDate.date, widget.isRequested));
                    }
                  });
                },
              ),
            );
          }
          else if (state is BloodOxygenErrorState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.6,
              child: Center(
                child: ErrorWithReload(
                  isWhite: true,
                    callback: () {
                      context.read<BloodOxygenBloc>().add(BloodOxygenGetEvent(widget.selectedDate.date, widget.isRequested));
                    },
                ),
              ),
            );
          }
          else if(state is BloodOxygenLoadingState){
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.6,
              child: Center(
                child: ProgressIndicatorWidget(isWhite: true),
              ),
            );
          }
          return Container();
        }),
        BlocBuilder<BloodOxygenBloc, BloodOxygenState>(builder: (context, state) {
          if (state is BloodOxygenNotConnectedState) {
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
                          context.read<BloodOxygenBloc>().add(BloodOxygenConnectedEvent(widget.selectedDate.date, widget.isRequested));
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

  getList(List<ClientSensorsView>? view) {
    oxygenList.clear();
    shortedList.clear();

    if (view != null && view.isNotEmpty) {
      view.forEach((element) {
        if (element.healthSensorVal != null && element.dateSensor != null) {
          DateTime tempDate = DateTime.parse(element.dateSensor!);

          oxygenList.putIfAbsent(tempDate, () => element.healthSensorVal!.toDouble());
        }
      });

      if (oxygenList.isNotEmpty) {
        oxygenList = SplayTreeMap<DateTime, double>.from(oxygenList, (a, b) => b.compareTo(a));

        oxygenList.forEach((key, val){
          if(shortedList.length != 7){
            shortedList.putIfAbsent(key, ()=> val);
          }
        });
      }
    }
  }

  Color getValueColor(int value) {
    if (value >= 95) {
      return AppColors.ultralightgreenColor;
    } else if (value <= 94 && value >= 90) {
      return AppColors.orangeColor;
    } else {
      return AppColors.redColor;
    }
  }

}
