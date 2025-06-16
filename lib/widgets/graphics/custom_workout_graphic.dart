import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:intl/intl.dart';

class CustomWorkoutGraphic extends StatefulWidget {
  final Map<DateTime, int> workoutList;

  const CustomWorkoutGraphic({
    super.key,
    required this.workoutList,
  });

  @override
  State<CustomWorkoutGraphic> createState() => _CustomWorkoutGraphicState();
}

class _CustomWorkoutGraphicState extends State<CustomWorkoutGraphic> {
  bool animate = true;
  List<int> workoutChartListValue = [];
  List<DateTime> workoutChartListDate = [];

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 238.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: Stack(
                children: [
                  Row(
                    children: [
                      for (var i = 0; i <= workoutChartListValue.length - 1; i++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
                            child: Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientThird,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Center(
                                      child: Text(
                                        DateFormat("dd.MM").format(workoutChartListDate[i]),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.h,
                                          height: 1,
                                          fontFamily: 'Inter',
                                          color: AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 1,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFFDFF9F8),
                                          Color(0xFFD5F4E5),
                                          Color(0xFFAEE5E2),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 600),
                                  constraints: BoxConstraints(minHeight: 25.h, maxHeight: 180.h),
                                  width: 44.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: AppColors.darkGreenColor,
                                  ),
                                  height: animate
                                      ? (180.h * workoutChartListValue[i]) / workoutChartListValue.reduce(max)
                                      : 0,
                                  child: SizedBox(
                                    height: 25.h,
                                    width: double.maxFinite,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Center(
                                        child: Text(
                                          workoutChartListValue[i].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.h,
                                            height: 1,
                                            fontFamily: 'Inter',
                                            color: AppColors.basicwhiteColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Image.asset(
              'assets/images/glucose_bottom_div.webp',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  check(){
    widget.workoutList.forEach((key, val){
      if(workoutChartListDate.length != 7){
        workoutChartListDate.add(key);
      }

      if(workoutChartListValue.length != 7){
        workoutChartListValue.add(val);
      }
    });

    workoutChartListDate = workoutChartListDate.reversed.toList();
    workoutChartListValue = workoutChartListValue.reversed.toList();

    setState(() {});
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  Color getColorColumn(double val) {
    if (val >= 98) {
      return AppColors.greenLightColor;
    } else if (val >= 95) {
      return AppColors.orangeColor;
    } else if (val >= 90) {
      return AppColors.vivaMagentaColor;
    }
    return AppColors.greenLightColor;
  }
}
