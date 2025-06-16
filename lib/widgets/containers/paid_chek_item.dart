import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

class PaidCheckItem extends StatelessWidget {
  const PaidCheckItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            children: [
              Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientTurquoiseReverse,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: AppColors.basicwhiteColor,
                    size: 16.r,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Замечательная возможность 1',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 1.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFE3FFF2),
                Color(0xFFAEE5E2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
