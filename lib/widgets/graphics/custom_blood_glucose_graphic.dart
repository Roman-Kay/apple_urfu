import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/ui/client_category/sensors/blood_glucose/tab_bar/client_sensors_tab_bar_sugar_dynamic.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:intl/intl.dart';

class CustomBloodGlucoseGraphic extends StatefulWidget {
  final Map<DateTime, GlucoseItem> glucoseList;

  const CustomBloodGlucoseGraphic({
    super.key,
    required this.glucoseList,
  });

  @override
  State<CustomBloodGlucoseGraphic> createState() => _CustomBloodGlucoseGraphicState();
}

class _CustomBloodGlucoseGraphicState extends State<CustomBloodGlucoseGraphic> {
  List<GlucoseItem> glucoseListValue = [];
  List<DateTime> glucoseListDate = [];
  List<double> doubleList = [];
  bool animate = true;

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
                      for (var i = 0; i <= widget.glucoseList.length - 1; i++)
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
                                        DateFormat("HH:mm").format(glucoseListDate[i]),
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
                                  width: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: getValueColor(glucoseListValue[i].value),
                                  ),
                                  height: animate ? (180.h * glucoseListValue[i].value) / doubleList.reduce(max) : 0,
                                  child: SizedBox(
                                    height: 25.h,
                                    width: double.maxFinite,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Center(
                                        child: Text(
                                          removeDecimalZeroFormat(glucoseListValue[i].value),
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
              color: AppColors.darkGreenColor,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  check() {
    widget.glucoseList.forEach((key, val) {
      if (doubleList.length != 7) {
        doubleList.add(val.value);
      }

      if (glucoseListValue.length != 7) {
        glucoseListValue.add(val);
      }

      if (glucoseListDate.length != 7) {
        glucoseListDate.add(key);
      }
    });

    glucoseListDate = glucoseListDate.reversed.toList();
    glucoseListValue = glucoseListValue.reversed.toList();

    setState((){});
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  Color getValueColor(double mol) {
    if (mol < 3.9) {
      return AppColors.blueColor;
    } else if (mol <= 5.5 && mol >= 3.9) {
      return AppColors.ultralightgreenColor;
    } else if (mol > 5.6) {
      return AppColors.redColor;
    }
    return AppColors.blueColor;
  }
}
