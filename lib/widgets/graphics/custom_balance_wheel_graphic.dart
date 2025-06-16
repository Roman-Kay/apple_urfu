
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/repository/balance_wheel.dart';
import 'package:garnetbook/utils/colors.dart';


class CustomBalanceWheelGraphic extends StatefulWidget {
  const CustomBalanceWheelGraphic({super.key, required this.list});
  final List<CategoryItem> list;

  @override
  State<CustomBalanceWheelGraphic> createState() => _CustomBalanceWheelGraphicState();
}

class _CustomBalanceWheelGraphicState extends State<CustomBalanceWheelGraphic> {
  BalanceWheelClass balanceWheel = BalanceWheelClass();
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
      color: AppColors.basicwhiteColor,
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
                      for (var i = 0; i <= widget.list.length - 1; i++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
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
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: AnimatedContainer(
                                    curve: Curves.easeInOut,
                                    duration: Duration(milliseconds: 600),
                                    constraints: BoxConstraints(minHeight: 25.h, maxHeight: 180.h),
                                    width: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: widget.list[i].color,
                                    ),
                                    height: animate ? (180.h * widget.list[i].value) / doubleList.reduce(max) : 0,
                                    child: SizedBox(
                                      height: 25.h,
                                      width: double.maxFinite,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Center(
                                          child: Text(
                                            widget.list[i].value.toString(),
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
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  check() {
    widget.list.forEach((val) {
      doubleList.add(val.value.toDouble());
    });

    setState((){});
  }
}
