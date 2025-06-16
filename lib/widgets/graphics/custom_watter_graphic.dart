import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:intl/intl.dart';

class CustomWatterGraphic extends StatefulWidget {
  final Map<DateTime, int> watterList;

  const CustomWatterGraphic({
    super.key,
    required this.watterList,
  });

  @override
  State<CustomWatterGraphic> createState() => _CustomWatterGraphicState();
}

class _CustomWatterGraphicState extends State<CustomWatterGraphic> {
  late List<int> watterListValue;
  late List<DateTime> watterListDate;
  bool animate = true;

  @override
  void initState() {
    watterListValue = widget.watterList.values.toList();
    watterListDate = widget.watterList.keys.toList();
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
                      for (var i = 0; i <= widget.watterList.length - 1; i++)
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
                                        DateFormat("MM/dd").format(watterListDate[i]),
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
                                  constraints: BoxConstraints(maxWidth: 40, minHeight: 25.h, maxHeight: 180.h),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: getValueColor(watterListValue[i]),
                                  ),
                                  height: animate ? 180.h * watterListValue[i] / 2600 : 0,
                                  child: SizedBox(
                                    height: 25.h,
                                    width: double.maxFinite,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Center(
                                        child: Text(
                                          watterListValue[i].toString(),
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
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  Color getValueColor(int watter) {
    if (watter >= 2000) {
      return AppColors.ultralightgreenColor;
    } else if (watter >= 1000) {
      return AppColors.orangeColor;
    } else {
      return AppColors.redColor;
    }
  }
}
