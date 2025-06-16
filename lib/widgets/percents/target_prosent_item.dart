import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

class TargetPercentItem extends StatelessWidget {
  const TargetPercentItem(
      {super.key,
      required this.colorCircleAvatar,
      required this.percent,
      required this.text});

  final Color colorCircleAvatar;
  final int percent;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 8.r,
                backgroundColor: colorCircleAvatar,
              ),
              SizedBox(width: 10.w),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  color: AppColors.darkGreenColor,
                ),
              ),
              Spacer(),
              Text(
                '$percent',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  fontFamily: 'Inter',
                  color: AppColors.darkGreenColor,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '%',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  color: AppColors.darkGreenColor,
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
