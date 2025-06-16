import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/workout/health_workout_bloc.dart';
import 'package:garnetbook/bloc/client/health/workout/workout_chart/workout_chart_bloc.dart';
import 'package:garnetbook/data/models/client/activity/activity_response.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/calendar/calendar_row.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ClientSensorsActivityTabBarCheck extends StatefulWidget {
  final SelectedDate selectedDate;
  const ClientSensorsActivityTabBarCheck({super.key, required this.selectedDate});

  @override
  State<ClientSensorsActivityTabBarCheck> createState() => _ClientSensorsActivityTabBarCheckState();
}

class _ClientSensorsActivityTabBarCheckState extends State<ClientSensorsActivityTabBarCheck> with AutomaticKeepAliveClientMixin {
  int dayQuantity = 7;
  Map<String, double> workoutList = {};

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        BlocBuilder<HealthWorkoutBloc, HealthWorkoutState>(builder: (context, state) {
          if (state is HealthWorkoutLoadedState) {
            getList(state.view);

            if (workoutList.isNotEmpty) {
              return RefreshIndicator(
                color: AppColors.darkGreenColor,
                onRefresh: () {
                  context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
                  context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: ListView(
                  children: [
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: CalendarRow(
                        selectedDate: widget.selectedDate.date,
                        color: AppColors.basicwhiteColor,
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
                            onConfirm: (date) {
                              setState(() {
                                widget.selectedDate.select(date);
                              });

                              context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
                              context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
                            },
                            currentTime: widget.selectedDate.date,
                            locale: LocaleType.ru,
                          );
                        },
                        onPressedLeft: () {
                          setState(() {
                            widget.selectedDate.select(widget.selectedDate.date.subtract(Duration(days: 1)));
                          });

                          context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
                          context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
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
                            setState(() {
                              widget.selectedDate.select(widget.selectedDate.date.add(Duration(days: 1)));
                            });
                            context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
                            context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 9),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                          child: SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              runAlignment: WrapAlignment.spaceBetween,
                              children: [
                                for (var item in workoutList.keys.toList())
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: AppColors.darkGreenColor.withOpacity(0.6),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  item,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: AppColors.basicwhiteColor,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    workoutList.values.toList()[workoutList.keys.toList().indexOf(item)].toInt().toString(),
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: AppColors.basicwhiteColor,
                                                      fontSize: 20.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    'ккал',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: AppColors.basicwhiteColor,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 6.h,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.r),
                                                  color: AppColors.grey20Color,
                                                ),
                                              ),
                                              Container(
                                                height: 6.h,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8.r),
                                                    color: workoutList.keys.toList().indexOf(item) % 3 == 0
                                                        ? Color(0xFFBE7204)
                                                        : workoutList.keys.toList().indexOf(item) % 3 == 1
                                                            ? Color(0xFFC73A19)
                                                            : workoutList.keys.toList().indexOf(item) % 3 == 2
                                                                ? Color(0xFFBEAF00)
                                                                : Color(0xFFBE7204)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(300),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: 300.w,
                                  height: 300.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(300),
                                    color: AppColors.basicwhiteColor.withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 62.w,
                              backgroundColor: AppColors.darkGreenColor.withOpacity(0.6),
                            ),
                            Image.asset(
                              'assets/images/Subtract.webp',
                              width: 270.w,
                              fit: BoxFit.fill,
                            ),
                            SfCircularChart(
                              legend: Legend(
                                isVisible: false,
                                overflowMode: LegendItemOverflowMode.wrap,
                              ),
                              series: <CircularSeries>[
                                DoughnutSeries<GDPData, String>(
                                  strokeWidth: 10.w,
                                  radius: (120.w).toString(),
                                  innerRadius: (72.w).toString(),
                                  dataSource: getChartData(workoutList),
                                  xValueMapper: (GDPData data, _) => data.continent,
                                  yValueMapper: (GDPData data, _) => data.gdp,
                                  pointColorMapper: (datum, index) {
                                    if (index % 3 == 0) {
                                      return Color(0xFFBE7204);
                                    } else if (index % 5 == 1) {
                                      return Color(0xFFC73A19);
                                    } else if (index % 5 == 2) {
                                      return Color(0xFFBEAF00);
                                    } else {
                                      return Color(0xFFBE7204);
                                    }
                                  },
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: getChartData(workoutList).length == 1 ? false : true,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                    ),
                                  ),
                                  enableTooltip: true,
                                )
                              ],
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Всего',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.basicwhiteColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    getCaloriesSum().toString(),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.basicwhiteColor,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'ккал',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.basicwhiteColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return RefreshIndicator(
                color: AppColors.darkGreenColor,
                onRefresh: () {
                  context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
                  context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
                  return Future.delayed(const Duration(seconds: 1));
                },
                child: ListView(
                  children: [
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: CalendarRow(
                        selectedDate: widget.selectedDate.date,
                        color: AppColors.basicwhiteColor,
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
                            onConfirm: (date) {
                              setState(() {
                                widget.selectedDate.select(date);
                              });

                              context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
                              context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
                            },
                            currentTime: widget.selectedDate.date,
                            locale: LocaleType.ru,
                          );
                        },
                        onPressedLeft: () {
                          setState(() {
                            widget.selectedDate.select(widget.selectedDate.date.subtract(Duration(days: 1)));
                          });

                          context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
                          context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
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
                            setState(() {
                              widget.selectedDate.select(widget.selectedDate.date.add(Duration(days: 1)));
                            });
                            context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
                            context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: Text(
                          "Данные отсутствуют",
                          style: TextStyle(
                            color: AppColors.basicwhiteColor,
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          else if (state is HealthWorkoutErrorState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.6,
              child: Center(
                child: ErrorWithReload(
                  isWhite: true,
                  callback: () {
                    context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
                    context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
                  },
                ),
              ),
            );
          }
          else if (state is HealthWorkoutLoadingState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.6,
              child: Center(
                child: ProgressIndicatorWidget(isWhite: true),
              ),
            );
          }
          return Container();
        }),
        BlocBuilder<HealthWorkoutBloc, HealthWorkoutState>(builder: (context, state) {
          if (state is HealthWorkoutLoadedState) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w).copyWith(bottom: 16.h),
                child: WidgetButton(
                  boxShadow: true,
                  onTap: () {
                    context.router.push(ClientAddActivityRoute(date: widget.selectedDate.date)).then((value) {
                      if (value == true) {
                        context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
                        context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
                      }
                    });
                  },
                  text: 'ДОБАВИТЬ',
                  color: AppColors.darkGreenColor,
                ),
              ),
            );
          }
          return Container();
        }),
      ],
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

  getList(List<ClientActivityView>? view) {
    workoutList.clear();

    if (view != null && view.isNotEmpty) {
      view.forEach((element) {
        if (element.activity?.name != null && element.calories != null) {
          String name = element.activity!.name!;
          double calories = element.calories!.toDouble();

          if (workoutList.containsKey(name)) {
            double currentVale = workoutList[name] ?? 0;
            workoutList.update(name, (value) => currentVale + calories, ifAbsent: () => currentVale + calories);
          } else {
            workoutList.putIfAbsent(name, () => calories);
          }
        }
      });
    }
  }

  int getCaloriesSum() {
    int fullCalories = 0;

    if (workoutList.isNotEmpty) {
      workoutList.forEach((key, value) {
        fullCalories = fullCalories + value.toInt();
      });
    }
    return fullCalories;
  }

  List<GDPData> getChartData(Map<String, double> list) {
    List<GDPData> testList = [];
    list.forEach((key, value) {
      testList.add(GDPData(key, value.toInt()));
    });
    return testList;
  }
}

class GDPData {
  GDPData(this.continent, this.gdp);
  final String continent;
  final int gdp;
}
