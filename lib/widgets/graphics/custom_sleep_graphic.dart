import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:intl/intl.dart';

class SensorsItem{
  double value;
  DateTime date;
  SensorsItem({
    required this.value,
    required this.date,
});
}

class CustomSleepGraphic extends StatefulWidget {
  final bool? isSpec;
  final Map<DateTime, ClientSensorsView> sleepList;

  const CustomSleepGraphic({
    super.key,
    required this.sleepList,
    this.isSpec,
  });

  @override
  State<CustomSleepGraphic> createState() => _CustomSleepGraphicState();
}

class _CustomSleepGraphicState extends State<CustomSleepGraphic> {
  bool animate = true;
  List<SensorsItem> list = [];
  List<double> doubleList = [];

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
                      for (var i = 0; i <= list.length - 1; i++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientThird,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Center(
                                      child: Text(
                                        DateFormat("dd.MM").format(list[i].date),
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
                                  constraints: BoxConstraints(minHeight: 40.h, maxHeight: 180.h),
                                  width: list.length > 5 ? 44 : 46,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: widget.isSpec == true ? AppColors.greenColor : AppColors.basicwhiteColor,
                                  ),
                                  height: animate
                                      ? (180.h * list[i].value) / doubleList.reduce(max)
                                  //((list[i].value - doubleList.reduce(min)) / (doubleList.reduce(max) - doubleList.reduce(min)))
                                      : 0,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Center(
                                      child: Text(
                                        getTimeString((list[i].value.toInt())),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: list.length > 5 ? 12.h : 14.h,
                                          height: 1,
                                          fontFamily: 'Inter',
                                          color: widget.isSpec == true ? AppColors.basicwhiteColor : AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Image.asset(
              'assets/images/glucose_bottom_div.webp',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }


  check(){
    widget.sleepList.forEach((key, value){
      if(value.healthSensorVal != null){
        if(list.length != 7){
          setState(() {
            list.add(SensorsItem(value: value.healthSensorVal!.toDouble(), date: key));
            doubleList.add(value.healthSensorVal!.toDouble());
          });
        }
      }
    });

    setState(() {
      list = list.reversed.toList();
    });

  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;

    if (hour == 0 && minutes == 0) {
      return "0";
    }

    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

}
