import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

class CalendarWeekItem extends StatelessWidget {
  final String text;
  final Color colorText;
  final Color colorBg;

  CalendarWeekItem({
    super.key,
    required this.text,
    this.colorText = AppColors.grey50Color,
    this.colorBg = AppColors.basicwhiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Container(
        width: 46.w,
        height: 42.h,
        decoration: BoxDecoration(
          color: colorBg,
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
                color: colorText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
