import 'dart:collection';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/water_diary/water_diary_chart/water_diary_chart_bloc.dart';
import 'package:garnetbook/data/models/client/water_diary/water_diary_model.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/calendar/calendar_week_item.dart';
import 'package:garnetbook/widgets/graphics/custom_radial_lite_percent_widget.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:intl/intl.dart';


class ClientWaterTabBarDynamic extends StatefulWidget {
  const ClientWaterTabBarDynamic({super.key});

  @override
  State<ClientWaterTabBarDynamic> createState() => _ClientWaterTabBarDynamicState();
}

class _ClientWaterTabBarDynamicState extends State<ClientWaterTabBarDynamic> with AutomaticKeepAliveClientMixin {
  Map<DateTime, int> waterList = {};
  int dayNorm = 2000;

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

    return BlocBuilder<WaterDiaryChartBloc, WaterDiaryChartState>(builder: (context, state) {
      if(state is WaterDiaryChartLoadedState){
        getList(state.list);
      }

      return RefreshIndicator(
        color: AppColors.darkGreenColor,
        onRefresh: () {
          context.read<WaterDiaryChartBloc>().add(WaterDiaryChartGetEvent(DateTime.now().month, DateTime.now().year));
          return Future.delayed(const Duration(seconds: 1));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: ListView(
            children: [
              SizedBox(height: 20.h),
              Center(
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(10.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.basicwhiteColor.withOpacity(0.7),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 28.w,
                              decoration: BoxDecoration(
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

                                            context.read<WaterDiaryChartBloc>().add(WaterDiaryChartGetEvent(
                                                ((selectedMonth + 1) % 12) == 0 ? 12 : ((selectedMonth + 1) % 12), listOfYear[m ~/ 12]));
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
                                                        color: m == selectedMonth
                                                            ? AppColors.darkGreenColor
                                                            : AppColors.darkWithOpacitygreenColor,
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
                                                      color: AppColors.darkWithOpacitygreenColor,
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
                                            colorBg: Color(0x0000000),
                                            colorText: AppColors.darkGreenColor,
                                          ),
                                          CalendarWeekItem(
                                            text: 'Вт',
                                            colorBg: Color(0x0000000),
                                            colorText: AppColors.darkGreenColor,
                                          ),
                                          CalendarWeekItem(
                                            text: 'Ср',
                                            colorBg: Color(0x0000000),
                                            colorText: AppColors.darkGreenColor,
                                          ),
                                          CalendarWeekItem(
                                            text: 'Чт',
                                            colorBg: Color(0x0000000),
                                            colorText: AppColors.darkGreenColor,
                                          ),
                                          CalendarWeekItem(
                                            text: 'Пт',
                                            colorBg: Color(0x0000000),
                                            colorText: AppColors.darkGreenColor,
                                          ),
                                          CalendarWeekItem(
                                            text: 'Сб',
                                            colorBg: Color(0x0000000),
                                            colorText: AppColors.darkGreenColor,
                                          ),
                                          CalendarWeekItem(
                                            text: 'Вс',
                                            colorBg: Color(0x0000000),
                                            colorText: AppColors.darkGreenColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: AppColors.lightGreenColor,
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

                                        if (waterList.keys.any((data) =>
                                        data.year == dateTimeItem.year && data.month == dateTimeItem.month && data.day == dateTimeItem.day)) {
                                          DateTime? newDate = waterList.keys.firstWhere((data) =>
                                          data.year == dateTimeItem.year && data.month == dateTimeItem.month && data.day == dateTimeItem.day);

                                          value = waterList[newDate] ?? 0;
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

                          Center(
                            child: state is WaterDiaryChartLoadingState
                                ? SizedBox(
                              height: 90.h,
                              child: Center(
                                child: ProgressIndicatorWidget(isSmall: true),
                              ),
                            )
                                : waterList.isEmpty
                                ? SizedBox(
                              height: 100.h,
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
                            )
                                : ListView.builder(
                              itemCount: waterList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                int ml = waterList.values.toList()[index];
                                DateTime date = waterList.keys.toList()[index];

                                return Padding(
                                  padding: EdgeInsets.only(left: 14.w, right: 14.w, top: index == 0 ? 16.h : 0),
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
                                                    color: AppColors.darkGreenColor,
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
                                                    color: AppColors.darkGreenColor,
                                                    fontSize: 14.sp,
                                                    height: 1.h,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Text(
                                              ml.toString().length == 4
                                                  ? '${ml.toString()[0]} ${ml.toString()[1]}${ml.toString()[2]}${ml.toString()[3]}'
                                                  : ml.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.sp,
                                                fontFamily: 'Inter',
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              'мл',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                                fontFamily: 'Inter',
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            CircleAvatar(
                                              radius: 5.r,
                                              backgroundColor: ml > 1500
                                                  ? AppColors.greenLightColor
                                                  : ml > 1000
                                                  ? AppColors.orangeColor
                                                  : AppColors.redColor,
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
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      );
    }
    );
  }

  DateTime findFirstDateOfTheWeek() {
    return DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
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

  getList(List<ClientWaterView>? list) {
    waterList.clear();

    if (list != null && list.isNotEmpty) {
      list.forEach((element) {
        if (element.update != null && element.dayVal != null && element.dayVal != 0) {
          DateTime date = DateTime.parse(element.update!);
          DateTime newDate = DateTime(date.year, date.month, date.day);

          if(element.dayNorm != null){
            dayNorm = element.dayNorm!;
          }

          waterList.putIfAbsent(newDate, () => element.dayVal!.toInt());
        }
      });
    }
    if (waterList.isNotEmpty) {
      waterList = SplayTreeMap<DateTime, int>.from(waterList, (a, b) => b.compareTo(a));
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
              backgroundColor: AppColors.basicwhiteColor,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreenColor,
                ),
              ),
            ),
            CustomRadialLitePersentWidget(
              percent: persent >= dayNorm ? 100 : (persent / dayNorm),
              lineWidth: 3,
              lineColor: AppColors.grey20Color,
              linePercentColor: AppColors.blueSecondaryColor,
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
              backgroundColor: AppColors.basicwhiteColor,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreenColor,
                ),
              ),
            ),
            CustomRadialLitePersentWidget(
              percent: persent >= dayNorm ? 100 : (persent / dayNorm),
              lineWidth: 3,
              lineColor: AppColors.grey20Color,
              linePercentColor: AppColors.blueSecondaryColor,
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
              backgroundColor: AppColors.basicwhiteColor,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreenColor,
                ),
              ),
            ),
            CustomRadialLitePersentWidget(
              percent: persent,
              lineWidth: 3,
              linePercentColor: AppColors.seaColor,
              lineColor: AppColors.grey20Color,
              size: 42.r,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
