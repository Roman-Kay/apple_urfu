import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/sleep/health_sleep_bloc.dart';
import 'package:garnetbook/bloc/client/health/sleep/week_sleep/week_sleep_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/drop_down.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/custom_sleep_graphic.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:intl/intl.dart';

class ClientSensorSleepDynamicTabBar extends StatefulWidget {
  const ClientSensorSleepDynamicTabBar({super.key, required this.isRequested, required this.selectedDate});

  final RequestedValue isRequested;
  final SelectedDate selectedDate;

  @override
  State<ClientSensorSleepDynamicTabBar> createState() => _ClientSensorSleepDynamicTabBarState();
}

class _ClientSensorSleepDynamicTabBarState extends State<ClientSensorSleepDynamicTabBar> with AutomaticKeepAliveClientMixin {
  Map<DateTime, ClientSensorsView> sleepList = {};
  Map<DateTime, ClientSensorsView> shortedList = {};

  List<String> items = ['Неделя', '10 дней', '30 дней', '60 дней'];
  String dropDownValue = 'Неделя';
  int dayQuantity = 7;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: widget.selectedDate,
      builder: (context, child) {
        return BlocBuilder<WeekSleepBloc, WeekSleepState>(
          builder: (context, listState) {
            if (listState is WeekSleepLoadedState) {
              getList(listState.list);

              return RefreshIndicator(
                color: AppColors.darkGreenColor,
                onRefresh: () {
                  context.read<WeekSleepBloc>().add(WeekSleepGetEvent(date: widget.selectedDate.date, dayQuantity: dayQuantity));
                  context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(widget.selectedDate.date));
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  children: [
                    SizedBox(height: 20.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.basicwhiteColor.withOpacity(0.24),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),
                            Text(
                              "Динамика изменения времени сна",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                                color: AppColors.basicwhiteColor,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              width: double.infinity,
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: AppColors.gradientTurquoise,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.basicwhiteColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(color: AppColors.basicwhiteColor)
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                    child: Text(
                                      "${DateFormat('d MMMM', 'ru_RU').format(widget.selectedDate.date.subtract(Duration(days: dayQuantity == 7 ? 6 : dayQuantity)))} - ${DateFormat('d MMMM', 'ru_RU').format(widget.selectedDate.date)}",
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        color: AppColors.basicwhiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 12.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.basicwhiteColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  child: DropDown(
                                    colorText: AppColors.darkGreenColor,
                                    colorBack: AppColors.basicwhiteColor,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropDownValue = newValue!;

                                        if (newValue == 'Неделя') {
                                          dayQuantity = 7;
                                        } else if (newValue == '10 дней') {
                                          dayQuantity = 10;
                                        } else if (newValue == '30 дней') {
                                          dayQuantity = 30;
                                        } else if (newValue == '60 дней') {
                                          dayQuantity = 60;
                                        }
                                      });

                                      DateTime newDate = DateUtils.dateOnly(widget.selectedDate.date);

                                      context.read<WeekSleepBloc>().add(WeekSleepGetEvent(date: newDate, dayQuantity: dayQuantity));
                                    },
                                    dropdownvalue: dropDownValue,
                                    items: items,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),

                            if(sleepList.isNotEmpty)
                              Column(
                                children: [
                                  CustomSleepGraphic(sleepList: shortedList, isSpec: true),
                                  SizedBox(height: 20.h),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: sleepList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final date = sleepList.keys.toList()[index];
                                      final value = sleepList.values.toList()[index];

                                      return Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8.h),
                                            child: Row(
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    SizedBox(width: 4.w),
                                                    Text(
                                                      getDay(date),
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: AppColors.basicwhiteColor,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.h,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    Text(
                                                      getMonthWithDayWeek(date).toLowerCase(),
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: AppColors.basicwhiteColor,
                                                        fontSize: 14.sp,
                                                        height: 1.h,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Text(
                                                  getTimeString(value.healthSensorVal?.toInt() ?? 0),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18.sp,
                                                    fontFamily: 'Inter',
                                                    color: AppColors.basicwhiteColor,
                                                  ),
                                                ),
                                                SizedBox(width: 16.w),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            decoration: BoxDecoration(
                                              gradient: AppColors.gradientTurquoise,
                                            ),
                                          ),
                                          SizedBox(height: 7.h),
                                        ],
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
                                      color: AppColors.basicwhiteColor,
                                    ),
                                  ),
                                ),
                              ),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              );
            }
            else if (listState is WeekSleepLoadingState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.8,
                child: Center(
                  child: ProgressIndicatorWidget(
                    isWhite: true,
                  ),
                ),
              );
            }
            else if (listState is WeekSleepErrorState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.8,
                child: ErrorWithReload(
                  isWhite: true,
                  callback: () {
                    context.read<WeekSleepBloc>().add(WeekSleepGetEvent(date: widget.selectedDate.date, dayQuantity: dayQuantity));
                    context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(widget.selectedDate.date));
                  },
                ),
              );
            }
            return Container();
          },
        );
      }
    );
  }

  Color getHealthColor(String? health) {
    if (health != null) {
      if (health == "Плохое")
        return AppColors.redColor;
      else if (health == "Нормальное")
        return AppColors.orangeColor;
      else if (health == "Отличное") return AppColors.ultralightgreenColor;
    }
    return Colors.transparent;
  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;

    if (hour == 0 && minutes == 0) {
      return "0";
    }

    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  String getDay(DateTime? date) {
    if (date != null) {
      return DateFormat('dd.MM.yy').format(date).substring(0, 2);
    }
    return "";
  }

  getList(List<ClientSensorsView>? list) {
    sleepList.clear();
    shortedList.clear();

    if (list != null && list.isNotEmpty) {
      list.forEach((element) {
        if (element.healthSensorVal != null && element.dateSensor != null && element.healthSensorVal != 0) {
          DateTime date = DateTime.parse(element.dateSensor!);
          DateTime newDate = DateTime(date.year, date.month, date.day);
          double value = element.healthSensorVal!.toDouble();

          sleepList.update(
            newDate,
            (newVal) => ClientSensorsView(
              health: element.health != null && element.health != "" ? element.health : newVal.health,
              healthSensor: element.healthSensor,
              healthSensorVal: (newVal.healthSensorVal!.toDouble() + value),
              dateSensor: element.dateSensor,
            ),
            ifAbsent: () => element,
          );
        }
      });

      if (sleepList.isNotEmpty) {
        sleepList = SplayTreeMap<DateTime, ClientSensorsView>.from(sleepList, (a, b) => b.compareTo(a));

        sleepList.forEach((key, element){
          if(shortedList.length != 7){
            shortedList.putIfAbsent(key, ()=> element);
          }
        });
      }
    }
  }

  String getMonthWithDayWeek(DateTime? date) {
    if (date != null) {
      String week = DateFormat('EE', 'ru_RU').format(date);
      String month = CalendarStorage.nameMonthByNumber[date.month].toString();
      String newWeek = week.characters.first.toUpperCase();
      String myWeek = week.substring(1);

      return '$month, $newWeek$myWeek';
    }
    return "";
  }

}
