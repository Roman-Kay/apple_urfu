import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/steps/health_step_bloc.dart';
import 'package:garnetbook/bloc/client/health/steps/step_list/step_list_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/calendar/calendar_week_item.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/custom_radial_lite_percent_widget.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class ClientSensorsStepsTabbarDynamic extends StatefulWidget {
  const ClientSensorsStepsTabbarDynamic({super.key, required this.isRequested});

  final RequestedValue isRequested;

  @override
  State<ClientSensorsStepsTabbarDynamic> createState() => _ClientSensorsStepsTabbarDynamicState();
}

class _ClientSensorsStepsTabbarDynamicState extends State<ClientSensorsStepsTabbarDynamic> with AutomaticKeepAliveClientMixin {
  Health health = Health();
  Map<DateTime, int> stepsList = {};
  DateTime selectedDate = DateTime.now();

  int currentYear = DateTime.now().year + 1;
  int startingYear = DateTime.now().year - 1;
  Map yearMapWithMonth = {};

  int selectedMonth = (DateTime.now().year - (DateTime.now().year - 1)) * 12 + DateTime.now().month - 1;
  List<Map<int, List>> listOfMapMonth = [];
  List listOfYear = [];

  FixedExtentScrollController _scrollControllerMonth = FixedExtentScrollController(
    initialItem: (DateTime.now().year - (DateTime.now().year - 1)) * 12 + DateTime.now().month - 1,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    double itemWidthMonth = MediaQuery.of(context).size.width / 3;

    List yearList = List.generate((currentYear - startingYear) + 1, (index) {
      setState(() {
        yearMapWithMonth[startingYear + index] = List.generate(12, (month) {
          return {
            DateTime(startingYear + index).month + month: List.generate(
              DateTime(startingYear + index, DateTime(startingYear + index).month + month + 1, 0).day,
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
    super.build(context);

    return BlocBuilder<StepListBloc, StepListState>(builder: (context, state) {
      if (state is StepListLoadedState) {
        getRequested();
        getList(state.stepsList);
      }
      else if (state is StepListErrorState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.8,
          child: Center(
            child: ErrorWithReload(
              isWhite: true,
              callback: () {
                int newMonth = ((selectedMonth + 1) % 12) == 0 ? 12 : ((selectedMonth + 1) % 12);
                int newYear = listOfYear[selectedMonth ~/ 12];

                context.read<HealthStepBloc>().add(HealthStepGetEvent());
                context.read<StepListBloc>().add(StepListGetEvent(newMonth, newYear, null));
              },
            ),
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.darkGreenColor,
        onRefresh: () {
          int newMonth = ((selectedMonth + 1) % 12) == 0 ? 12 : ((selectedMonth + 1) % 12);
          int newYear = listOfYear[selectedMonth ~/ 12];

          context.read<HealthStepBloc>().add(HealthStepGetEvent());
          context.read<StepListBloc>().add(StepListGetEvent(newMonth, newYear, null));
          return Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          children: [
            SizedBox(height: 24.h),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey60Color.withOpacity(0.7),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.r),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 28.w,
                    decoration: BoxDecoration(
                      color: AppColors.grey60Color,
                      border: Border.all(
                        color: AppColors.lightGreenColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 65.h - (24.h + 14.h) + (24.h + 14.h) * MediaQuery.of(context).textScaleFactor,
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

                                  context.read<StepListBloc>().add(StepListGetEvent(
                                      ((selectedMonth + 1) % 12) == 0 ? 12 : ((selectedMonth + 1) % 12), listOfYear[m ~/ 12], null));
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
                                          child: AnimatedDefaultTextStyle(
                                            duration: Duration(milliseconds: 150),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                // берем если выбранный месяц полное название из index == 0 иначе не полное 1
                                                CalendarStorage.nameMonth[listOfMapMonth[m].keys.toList().first]
                                                    ?[m == selectedMonth ? 0 : 1],
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: m == selectedMonth ? 24.h : 20.h,
                                              fontFamily: 'Inter',
                                              color: m == selectedMonth ? AppColors.basicwhiteColor : AppColors.grey30Color,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          // выбраный месяц мы делем на 12 без остатка тем самам получаем нужный индекс года
                                          m == selectedMonth ? listOfYear[m ~/ 12].toString() : '',
                                          style: TextStyle(
                                            height: 1.1,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.h,
                                            fontFamily: 'Inter',
                                            color: AppColors.grey30Color,
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
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Wrap(
                              spacing: 4.w,
                              children: [
                                CalendarWeekItem(
                                  text: 'Пн',
                                  colorText: AppColors.orangeColor,
                                  colorBg: AppColors.grey60Color,
                                ),
                                CalendarWeekItem(
                                  text: 'Вт',
                                  colorText: AppColors.orangeColor,
                                  colorBg: AppColors.grey60Color,
                                ),
                                CalendarWeekItem(
                                  text: 'Ср',
                                  colorText: AppColors.orangeColor,
                                  colorBg: AppColors.grey60Color,
                                ),
                                CalendarWeekItem(
                                  text: 'Чт',
                                  colorText: AppColors.orangeColor,
                                  colorBg: AppColors.grey60Color,
                                ),
                                CalendarWeekItem(
                                  text: 'Пт',
                                  colorText: AppColors.orangeColor,
                                  colorBg: AppColors.grey60Color,
                                ),
                                CalendarWeekItem(
                                  text: 'Сб',
                                  colorText: AppColors.orangeColor,
                                  colorBg: AppColors.grey60Color,
                                ),
                                CalendarWeekItem(
                                  text: 'Вс',
                                  colorText: AppColors.orangeColor,
                                  colorBg: AppColors.grey60Color,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: AppColors.grey50Color,
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Wrap(
                            spacing: 4.w,
                            runSpacing: 2.h,
                            children: listOfMapMonth[selectedMonth].values.toList().first.map((day) {
                              DateTime dateTimeItem = DateTime.parse(
                                '${listOfYear[selectedMonth ~/ 12]}-${(selectedMonth % 12 + 1).toString().length == 1 ? '0' : ''}${selectedMonth % 12 + 1}-${day <= 9 ? '0' : ''}$day',
                              );

                              int value = 0;

                              if (stepsList.keys.any((data) =>
                                  data.year == dateTimeItem.year && data.month == dateTimeItem.month && data.day == dateTimeItem.day)) {
                                DateTime? newDate = stepsList.keys.firstWhere((data) =>
                                    data.year == dateTimeItem.year && data.month == dateTimeItem.month && data.day == dateTimeItem.day);

                                value = stepsList[newDate] ?? 0;
                              }

                              return Padding(
                                padding: EdgeInsets.only(
                                  left: day == 1
                                      // если день первый смотрим какой по счету это день недели и у множаем на отступ слева
                                      ? (dateTimeItem.weekday - 1) * 48.w
                                      : 0,
                                ),
                                child: DateTime.now().year == dateTimeItem.year &&
                                        DateTime.now().month == dateTimeItem.month &&
                                        DateTime.now().day == dateTimeItem.day
                                    ? TodayItem('$day', value)
                                    : StandartItem('$day', value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey60Color.withOpacity(0.7),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10.r),
                  ),
                ),
                child: state is StepListLoadingState
                    ? SizedBox(
                        height: 100.h,
                        child: Center(
                          child: ProgressIndicatorWidget(isWhite: true),
                        ),
                      )
                    : stepsList.isEmpty
                        ? SizedBox(
                            height: 100.h,
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
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: stepsList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final date = stepsList.keys.toList()[index];
                              final value = stepsList.values.toList()[index];

                              return Padding(
                                padding: EdgeInsets.only(top: index == 0 ? 16.h : 0),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Column(
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
                                            Spacer(),
                                            Text(
                                              value.toString(),
                                              style: TextStyle(
                                                color: AppColors.basicwhiteColor,
                                                fontFamily: 'Inter',
                                                fontSize: 18.sp,
                                                height: 1.2,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 14.w),
                                            CircleAvatar(
                                              radius: 5.r,
                                              backgroundColor: getValueColor(value),
                                            ),
                                            SizedBox(width: 4.w),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.gradientTurquoise,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      );
    });
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

  Color getValueColor(int value) {
    if (value > 10000) {
      return AppColors.greenLightColor;
    }
    if (value <= 10000 && value > 6000) {
      return AppColors.greenLightColor;
    } else if (value <= 6000 && value > 2000) {
      return AppColors.orangeColor;
    }
    return AppColors.redColor;
  }

  String getDay(DateTime? date) {
    if (date != null) {
      return DateFormat('dd.MM.yy').format(date).substring(0, 2);
    }
    return "";
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

  getList(List<ClientSensorsView>? list) {
    stepsList.clear();

    if (list != null && list.isNotEmpty) {
      List newList = [];

      list.forEach((element) {
        if (element.dateSensor != null) {
          newList.add(element);
        }
      });

      newList.sort((a, b) {
        DateTime aDate = DateTime.parse(a.dateSensor!);
        DateTime bDate = DateTime.parse(b.dateSensor!);

        return aDate.compareTo(bDate);
      });

      newList.forEach((element) {
        if (element.healthSensorVal != null && element.dateSensor != null && element.healthSensorVal != 0) {
          DateTime date = DateTime.parse(element.dateSensor!);

          if (stepsList.isNotEmpty) {
            if (stepsList.keys.any((data) => data.year == date.year && data.month == date.month && data.day == date.day)) {
              List<DateTime> deletedDates = [];

              stepsList.forEach((data, val) {
                if (data.year == date.year && data.month == date.month && data.day == date.day) {
                  if (data.difference(date).isNegative) {
                    if (!deletedDates.contains(data)) {
                      deletedDates.add(data);
                    }
                  }
                }
              });

              if (deletedDates.isNotEmpty) {
                deletedDates.forEach((existedDate) {
                  stepsList.removeWhere((data, value) => data == existedDate);
                });
              }
            }
          }

          stepsList.update(
            date,
            (value) => element.healthSensorVal!.toInt(),
            ifAbsent: () => element.healthSensorVal!.toInt(),
          );
        }
      });

      if (stepsList.isNotEmpty) {
        stepsList = SplayTreeMap<DateTime, int>.from(stepsList, (a, b) => b.compareTo(a));
      }
    }
  }

  Widget StandartItem(text, int persent) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.w),
      child: SizedBox(
        width: 44.w,
        height: 42.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.grey50Color,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: AppColors.basicwhiteColor,
                ),
              ),
            ),
            CustomRadialLitePersentWidget(
              percent: persent >= 10000 ? 100 : (persent / 10000),
              lineWidth: 3,
              lineColor: Color(0x00000000),
              linePercentColor: AppColors.orangeColor,
              size: 42.r,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget TodayItem(text, int persent) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.w),
      child: Container(
        width: 44.w,
        height: 42.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.seaColor,
            width: 0.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.grey50Color,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: AppColors.basicwhiteColor,
                ),
              ),
            ),
            CustomRadialLitePersentWidget(
              percent: persent >= 10000 ? 100 : (persent / 10000),
              lineWidth: 3,
              lineColor: Color(0x00000000),
              linePercentColor: AppColors.orangeColor,
              size: 42.r,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget ChosenItem(text, double persent) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.w),
      child: SizedBox(
        width: 44.w,
        height: 42.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.grey50Color,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: AppColors.basicwhiteColor,
                ),
              ),
            ),
            CustomRadialLitePersentWidget(
              percent: persent,
              lineWidth: 3,
              lineColor: Color(0x00000000),
              linePercentColor: AppColors.seaColor,
              size: 42.r,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
