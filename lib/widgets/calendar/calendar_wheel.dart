
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/sleep/health_sleep_bloc.dart';
import 'package:garnetbook/bloc/client/health/workout/health_workout_bloc.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

class CalendarWheel extends StatefulWidget {
  const CalendarWheel({super.key, this.type, this.selectedDate});
  final String? type;
  final SelectedDate? selectedDate;

  @override
  State<CalendarWheel> createState() => _CalendarWheelState();
}

class _CalendarWheelState extends State<CalendarWheel> {
  int startingYear = 2020;

  int currentYear = DateTime.now().year + 1;
  Map yearMapWithMonth = {};
  List<Map<int, List>> listOfMapMonth = [];
  List listOfYear = [];

  int selectedMonth = (DateTime.now().year - 2020) * 12 + DateTime.now().month - 1;
  // минус 1 так как это индекс
  // умножить на 12 так как кол во месяцев в году
  int selectedDay = DateTime.now().day - 1;

  FixedExtentScrollController _scrollControllerMonth =
  FixedExtentScrollController(initialItem: (DateTime.now().year - 2020) * 12 + DateTime.now().month - 1);

  FixedExtentScrollController _scrollControllerDay = FixedExtentScrollController(initialItem: DateTime.now().day - 1);

  RestartableTimer timer = RestartableTimer(Duration(seconds: 1), () {});


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    double itemWidthMonth = MediaQuery.of(context).size.width / 3;
    double itemWidthDay = MediaQuery.of(context).size.width / 5;

    // ignore: unused_local_variable
    List yearList = List.generate((currentYear - startingYear) + 1, (index) {
      setState(() {
        yearMapWithMonth[startingYear + index] = List.generate(12, (month) {
          return {
            DateTime(startingYear + index).month + month: List.generate(
              DateTime(
                startingYear + index,
                DateTime(startingYear + index).month + month + 1,
                0,
              ).day,
              (day) => day + 1,
            ),
          };
        });
      });
    });

    yearMapWithMonth.values.forEach((list) {
      listOfMapMonth.addAll(list);
    });
    yearMapWithMonth.keys.forEach(
      (year) => listOfYear.add(year),
    );

    return SizedBox(
      width: 352.w,
      child: Column(
        children: [
          SizedBox(
            height: 65.h -
                (24.h + 14.h) +
                (24.h + 14.h) * MediaQuery.of(context).textScaleFactor,
            child: Center(
              child: RotatedBox(
                quarterTurns: -1,
                child: ListWheelScrollView(
                  diameterRatio: 100,
                  useMagnifier: true,
                  onSelectedItemChanged: (m) {
                    setState(() {
                      selectedMonth = m;
                    });
                    int year = startingYear + (selectedMonth + 1) ~/ 12;
                    int month = (selectedMonth + 1) % 12;
                    int day = selectedDay + 1;
                    DateTime newDate = DateTime(year, month, day);

                    if (widget.selectedDate != null) {
                      widget.selectedDate!.select(newDate);
                    }

                    if (widget.type == "sleep") {
                      timer.cancel();
                      timer = RestartableTimer(Duration(milliseconds: 700), () {
                        context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(newDate));
                      });
                      timer.reset();
                    }
                    else if (widget.type == "workout") {
                      context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(newDate));
                    }
                  },
                  controller: _scrollControllerMonth,
                  physics: const FixedExtentScrollPhysics(),
                  children: List.generate(
                    listOfMapMonth.length,
                    (m) => RotatedBox(
                      quarterTurns: 1,
                      child: Column(
                        children: [
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: m == selectedMonth
                                ? null
                                : () {
                                    _scrollControllerMonth.animateToItem(
                                      m,
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.ease,
                                    );
                                  },
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: AnimatedDefaultTextStyle(
                                duration: Duration(milliseconds: 150),
                                child: Text(
                                  CalendarStorage.nameMonth[listOfMapMonth[m]
                                      .keys
                                      .toList()
                                      .first]?[m == selectedMonth ? 0 : 1],
                                  // берем если выбранный месяц полное название из index == 0 иначе не полное 1
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: m == selectedMonth ? 24.h : 20.h,
                                  fontFamily: 'Inter',
                                  height: 1,
                                  color: m == selectedMonth
                                      ? AppColors.darkGreenColor
                                      : AppColors.grey50Color,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            m == selectedMonth
                                ? listOfYear[m ~/ 12].toString()
                                // выбраный месяц мы делем на 12 без остатка тем самам получаем нужный индекс года
                                : '',
                            style: TextStyle(
                              height: 1,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.h,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  itemExtent: itemWidthMonth,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 85.h,
            child: Center(
              child: RotatedBox(
                quarterTurns: -1,
                child: ListWheelScrollView(
                  diameterRatio: 100,
                  useMagnifier: true,
                  onSelectedItemChanged: (d) {
                    setState(() {
                      selectedDay = d;
                    });
                    int year = startingYear + (selectedMonth + 1) ~/ 12;
                    int month = (selectedMonth + 1) % 12;
                    int day = selectedDay + 1;
                    DateTime newDate = DateTime(year, month, day);

                    if (widget.selectedDate != null) {
                      widget.selectedDate!.select(newDate);
                    }

                    if (widget.type == "sleep") {
                      timer.cancel();
                      timer = RestartableTimer(Duration(milliseconds: 700), () {
                        context.read<HealthSleepBloc>().add(HealthSleepCheckEvent(newDate));
                      });
                      timer.reset();
                    }

                    else if (widget.type == "workout") {
                      context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(newDate));
                    }
                  },
                  controller: _scrollControllerDay,
                  physics: const FixedExtentScrollPhysics(),
                  children: List.generate(
                      listOfMapMonth[selectedMonth]
                          .values
                          .toList()
                          .first
                          .length,
                      (d) => RotatedBox(
                            quarterTurns: 1,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                  onTap: d == selectedDay
                                      ? null
                                      : () {
                                          _scrollControllerDay.animateToItem(
                                            d,
                                            duration:
                                                Duration(milliseconds: 100),
                                            curve: Curves.ease,
                                          );
                                        },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: d == selectedDay
                                          ? AppColors
                                              .thirdbackgroundgradientColor
                                          : null,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.r)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.5),
                                      child: Container(
                                        width: 60.w,
                                        height: 85.h,
                                        decoration: d == selectedDay
                                            ? BoxDecoration(
                                                gradient: AppColors
                                                    .backgroundgradientColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              )
                                            : null,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${d + 1}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 24.sp,
                                                  fontFamily: 'Inter',
                                                  color:
                                                      AppColors.darkGreenColor,
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                [
                                                  '',
                                                  'вт',
                                                  'ср',
                                                  'чт',
                                                  'пт',
                                                  'cб',
                                                  'вс',
                                                  'пн',
                                                ][DateTime.parse(
                                                  '${listOfYear[selectedMonth ~/ 12]}-${(selectedMonth % 12 + 1).toString().length == 1 ? '0' : ''}${selectedMonth % 12 + 1}-${d <= 9 ? '0' : ''}$d',
                                                ).weekday],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                  fontFamily: 'Inter',
                                                  color:
                                                      AppColors.darkGreenColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          )),
                  itemExtent: itemWidthDay,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
