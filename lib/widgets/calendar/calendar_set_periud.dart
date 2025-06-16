import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/utils/colors.dart';

class CalendarSetPeriod extends StatefulWidget {
  const CalendarSetPeriod({super.key});

  @override
  State<CalendarSetPeriod> createState() => _CalendarSetPeriodState();
}

class _CalendarSetPeriodState extends State<CalendarSetPeriod> {
  List month = CalendarStorage.month;
  int selectedMonth = 5;
  FixedExtentScrollController _scrollControllerMonth =
      FixedExtentScrollController(initialItem: 5);
  int selectedDay = 1;
  int nowAmountChoose = 0;
  int firstItemChoose = -1;
  int secondItemChoose = -1;

  @override
  Widget build(BuildContext context) {
    double itemWidthMonth = MediaQuery.of(context).size.width / 3;

    return Center(
      child: Container(
        width: 350.w,
        decoration: BoxDecoration(
          color: AppColors.basicwhiteColor,
          border: Border.all(
            color: AppColors.lightGreenColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey50Color.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 9,
            ),
          ],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
              child: Center(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: ListWheelScrollView(
                    diameterRatio: 100,
                    useMagnifier: true,
                    onSelectedItemChanged: (m) {
                      setState(() {
                        selectedMonth = m;
                        firstItemChoose = -1;
                        secondItemChoose = -1;
                      });
                    },
                    controller: _scrollControllerMonth,
                    physics: const FixedExtentScrollPhysics(),
                    children: List.generate(
                      month.length,
                      (m) => RotatedBox(
                        quarterTurns: 1,
                        child: Column(
                          children: [
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
                              child: Text(
                                m == selectedMonth
                                    ? month[m][0]
                                    : month[m][0][0] +
                                        month[m][0][1] +
                                        month[m][0][2],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            m == selectedMonth
                                ? Text(
                                    '2023',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    itemExtent: itemWidthMonth,
                  ),
                ),
              ),
            ),
            Wrap(
              spacing: 4.w,
              children: [
                _SizedBox('Пн'),
                _SizedBox('Вт'),
                _SizedBox('Ср'),
                _SizedBox('Чт'),
                _SizedBox('Пт'),
                _SizedBox('Сб'),
                _SizedBox('Вс'),
              ],
            ),
            Wrap(
              spacing: 4.w,
              runSpacing: 2.h,
              children: List.generate(
                month[selectedMonth][1],
                (day) {
                  String firstDay = month[selectedMonth][2][1];
                  int removeStartWidget = 0;

                  if (firstDay == 'Понедельник') {
                    removeStartWidget = 0;
                  }
                  if (firstDay == 'Вторник') {
                    removeStartWidget = 1;
                  }
                  if (firstDay == 'Среда') {
                    removeStartWidget = 2;
                  }
                  if (firstDay == 'Четверг') {
                    removeStartWidget = 3;
                  }
                  if (firstDay == 'Пятница') {
                    removeStartWidget = 4;
                  }
                  if (firstDay == 'Суббота') {
                    removeStartWidget = 5;
                  }
                  if (firstDay == 'Воскресенье') {
                    removeStartWidget = 6;
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                      left: day == 0 ? (removeStartWidget * 50).w : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            if (firstItemChoose == day + 1) {
                              firstItemChoose = -1;
                            } else if (secondItemChoose == day + 1) {
                              secondItemChoose = -1;
                            } else if (firstItemChoose == -1) {
                              firstItemChoose = day + 1;
                            } else if (secondItemChoose == -1) {
                              secondItemChoose = day + 1;
                            } else {
                              firstItemChoose = -1;
                              secondItemChoose = -1;
                            }
                          },
                        );
                      },
                      child: firstItemChoose == day + 1 ||
                              secondItemChoose == day + 1
                          ? _ChooseContainer(
                              (day + 1).toString(),
                            )
                          : (firstItemChoose - secondItemChoose) == 0 ||
                                  firstItemChoose == -1 ||
                                  secondItemChoose == -1
                              ? _SizedBox(
                                  (day + 1).toString(),
                                )
                              : firstItemChoose < secondItemChoose
                                  ? firstItemChoose < day + 1 &&
                                          secondItemChoose > day + 1
                                      ? _ChooseLineContainer(
                                          (day + 1).toString())
                                      : _SizedBox((day + 1).toString())
                                  : secondItemChoose < day + 1 &&
                                          firstItemChoose > day + 1
                                      ? _ChooseLineContainer(
                                          (day + 1).toString())
                                      : _SizedBox((day + 1).toString()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _SizedBox(text) {
    return Container(
      width: 46.w,
      height: 42.h,
      decoration: BoxDecoration(color: AppColors.basicwhiteColor),
      child: Padding(
        padding: EdgeInsets.only(top: 7.h),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: AppColors.grey50Color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _ChooseContainer(text) {
    return Container(
      width: 46.w,
      height: 42.h,
      decoration: BoxDecoration(
        gradient: AppColors.thirdbackgroundgradientColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.backgroundgradientColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 7.h - 1),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreenColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ChooseLineContainer(text) {
    return Container(
      width: 46.w,
      height: 42.h,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey10Color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 7.h),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                color: AppColors.darkGreenColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
