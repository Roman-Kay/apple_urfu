import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/health/workout/health_workout_bloc.dart';
import 'package:garnetbook/bloc/client/health/workout/workout_chart/workout_chart_bloc.dart';
import 'package:garnetbook/data/models/client/activity/activity_response.dart';
import 'package:garnetbook/data/repository/health_repository.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/drop_down.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/graphics/custom_workout_graphic.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:intl/intl.dart';

class ClientSensorsActivityTabBarDynamic extends StatefulWidget {
  final SelectedDate selectedDate;

  const ClientSensorsActivityTabBarDynamic({super.key, required this.selectedDate});

  @override
  State<ClientSensorsActivityTabBarDynamic> createState() => _ClientSensorsActivityTabBarDynamicState();
}

class _ClientSensorsActivityTabBarDynamicState extends State<ClientSensorsActivityTabBarDynamic> with AutomaticKeepAliveClientMixin {
  Map<DateTime, List<ClientActivityView>> workoutChartList = {};
  Map<DateTime, int> activityList = {};
  int dayQuantity = 7;
  List<String> items = ['Неделя', '10 дней', '30 дней', '60 дней'];
  String dropDownValue = 'Неделя';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<WorkoutChartBloc, WorkoutChartState>(builder: (context, state) {
      if (state is WorkoutChartLoadedState) {
        getChartList(state.view);

        return RefreshIndicator(
          color: AppColors.darkGreenColor,
          onRefresh: () {
            context.read<HealthWorkoutBloc>().add(HealthWorkoutCheckEvent(widget.selectedDate.date));
            context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
            return Future.delayed(const Duration(seconds: 1));
          },
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            children: [
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.basicwhiteColor.withOpacity(0.23),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
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
                                context.read<WorkoutChartBloc>().add(WorkoutChartGetEvent(dayQuantity, widget.selectedDate.date));
                              },
                              dropdownvalue: dropDownValue,
                              items: items,
                            ),
                          ),
                        ],
                      ),

                      if (workoutChartList.isNotEmpty)
                        Column(
                          children: [
                            SizedBox(height: 12.h),
                            CustomWorkoutGraphic(workoutList: activityList),
                            SizedBox(height: 8.h),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: workoutChartList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final date = workoutChartList.keys.toList()[index];
                                final value = workoutChartList.values.toList()[index];

                                return ClientSensorsActivityItem(
                                  date: date,
                                  calorie: getAllCalorie(value),
                                  list: value,
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
              SizedBox(height: 24.h),
            ],
          ),
        );
      }
      else if (state is WorkoutChartErrorState) {
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
      else if (state is WorkoutChartLoadingState) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.6,
          child: Center(
            child: ProgressIndicatorWidget(isWhite: true),
          ),
        );
      }

      return Container();
    });
  }

  int getAllCalorie(List<ClientActivityView> list){
    int calorie = 0;

    list.forEach((element) => calorie = calorie + (element.calories ?? 0));
    return calorie;
  }

  getChartList(List<ClientActivityView>? list) {
    workoutChartList.clear();
    activityList.clear();
    Map<DateTime, int> shortedList = {};

    if (list != null && list.isNotEmpty) {
      list.forEach((element) {
        if (element.calories != null && element.activityDate != null && element.create != null) {
          DateTime date = DateTime.parse(element.activityDate!);
          DateTime newDate = DateTime(date.year, date.month, date.day);
          int calories = element.calories!.toInt();

          ClientActivityView view = ClientActivityView(
              health: element.health,
              calories: calories,
              create: element.create,
              activity: element.activity,
              activityDate: element.activityDate);

          workoutChartList.update(
              newDate,
              (value) => value..add(view),
              ifAbsent: () => [element]);

          shortedList.update(
              newDate,
              (value) => value + calories,
              ifAbsent: () => calories);
        }
      });

      if (workoutChartList.isNotEmpty) {
        workoutChartList = SplayTreeMap<DateTime, List<ClientActivityView>>.from(workoutChartList, (a, b) => b.compareTo(a));
      }

      if(shortedList.isNotEmpty){
        shortedList = SplayTreeMap<DateTime, int>.from(shortedList, (a, b) => b.compareTo(a));

        shortedList.forEach((key, val){
          if(activityList.length != 7){
            activityList.putIfAbsent(key, ()=> val);
          }
        });
      }
    }
  }

}

class ClientSensorsActivityItem extends StatefulWidget {
  const ClientSensorsActivityItem({
    required this.date,
    required this.list,
    required this.calorie,
    super.key});

  final DateTime date;
  final int calorie;
  final List<ClientActivityView> list;

  @override
  State<ClientSensorsActivityItem> createState() => _ClientSensorsActivityItemState();
}

class _ClientSensorsActivityItemState extends State<ClientSensorsActivityItem> with TickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isOpen = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      value: 0,
      lowerBound: 0,
      upperBound: 1,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.basicwhiteColor.withOpacity(0.7),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8.r),
                bottom: !isOpen ? Radius.zero : Radius.circular(8.r),
              ),
            ),
            child: FormForButton(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8.r),
                bottom: !isOpen ? Radius.zero : Radius.circular(8.r),
              ),
              onPressed: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(width: 4.w),
                        Text(
                          getDay(widget.date),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.h,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          getMonthWithDayWeek(widget.date).toLowerCase(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                            fontSize: 14.sp,
                            height: 1.h,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      widget.calorie.toString(),
                      style: TextStyle(
                        color: AppColors.darkGreenColor,
                        fontFamily: 'Inter',
                        fontSize: 18.sp,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 18.sp,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          ' ккал',
                          style: TextStyle(
                            color: AppColors.darkGreenColor,
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            height: 1.2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Transform.flip(
                      flipY: isOpen,
                      child: Transform.rotate(
                        angle: pi / 2,
                        child: SvgPicture.asset(
                          'assets/images/arrow_black.svg',
                          color: AppColors.darkGreenColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 150),
            curve: Curves.fastOutSlowIn,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.zero,
                  bottom: !isOpen ? Radius.circular(8.r) : Radius.zero,
                ),
                border: Border.all(color: !isOpen ? AppColors.basicwhiteColor : Colors.transparent)
              ),
              child: isOpen
                  ? null
                  : FadeTransition(
                opacity: _animation,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final item = widget.list[i];

                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              item.activity?.name ?? "",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                                color: AppColors.basicwhiteColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                item.create != null ? DateFormat("HH:mm").format(DateTime.parse(item.create!)) : "",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: AppColors.basicwhiteColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Spacer(),
                              Text(
                                item.calories.toString(),
                                style: TextStyle(
                                  color: AppColors.basicwhiteColor,
                                  fontFamily: 'Inter',
                                  fontSize: 18.sp,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 18.sp,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    ' ккал',
                                    style: TextStyle(
                                      color: AppColors.basicwhiteColor,
                                      fontFamily: 'Inter',
                                      fontSize: 10.sp,
                                      height: 1.2,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              if (item.health != null)
                                Row(
                                  children: [
                                    SizedBox(width: 24.w),
                                    Container(
                                      width: 10.w,
                                      height: 10.h,
                                      decoration: BoxDecoration(
                                          color: getHealthColor(item.health), borderRadius: BorderRadius.circular(99)),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      item.health ?? "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                          fontFamily: "Inter",
                                          color: AppColors.basicwhiteColor),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            height: 1,
                            color: AppColors.basicwhiteColor,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
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
}

