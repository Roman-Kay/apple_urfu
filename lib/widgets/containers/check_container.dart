import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CheckContainer extends StatelessWidget {
  final Widget child;
  Color? color;
  bool isBig;

  CheckContainer({
    super.key,
    required this.child,
    this.color = AppColors.darkGreenColor,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.basicwhiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.basicblackColor.withOpacity(0.1),
            blurRadius: 10.r,
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: isBig
                ? EdgeInsets.only(
                    top: 2,
                    bottom: 2,
                    left: 2,
                  )
                : EdgeInsets.zero,
            child: Container(
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: color,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: isBig ? 24.h : 11.h),
                  Text(
                    DateTime.now().day.toString(),
                    style: TextStyle(
                      height: 1.1,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                    ),
                  ),
                  SizedBox(height: isBig ? 4.h : 2.h),
                  Text(
                    DateFormat('MMMM', 'ru_RU').format(DateTime.now()),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                    ),
                  ),
                  SizedBox(
                    height: isBig ? 8.h : 2.h,
                  ),
                  Container(
                    width: 56.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.r),
                      color: AppColors.basicwhiteColor,
                    ),
                  ),
                  SizedBox(height: isBig ? 8.h : 2.h),
                  Text(
                    DateFormat('EE', 'ru_RU').format(DateTime.now()),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      height: 1.1,
                      fontFamily: 'Inter',
                      color: AppColors.basicwhiteColor,
                    ),
                  ),
                  SizedBox(height: isBig ? 24.h : 11.h),
                ],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
