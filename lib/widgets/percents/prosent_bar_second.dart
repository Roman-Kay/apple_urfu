// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

class PercentSecondBar extends StatelessWidget {
  PercentSecondBar({
    super.key,
    required this.percent,
    this.width = 240,
    this.widthPercentLine = 75,
    this.backgroundColor,
    this.percentLineColor = AppColors.greenColor,
  });

  final int percent;
  double width;
  double widthPercentLine;
  Color? backgroundColor;
  Color percentLineColor;

  @override
  Widget build(BuildContext context) {
    final double widthFull = width.w;
    final double widthPercent = widthPercentLine.w;

    return Stack(
      children: [
        Container(
          height: 32.h,
          width: widthFull,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.h),
            color: backgroundColor,
            gradient: backgroundColor == null ? AppColors.gradientTurquoise : null,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: widthPercent >= widthFull / 100 * (percent >= 100 ? 100 : percent)
                ? widthPercent
                : widthFull / 100 * (percent >= 100 ? 100 : percent),
            height: 32.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.h),
              color: percentLineColor,
            ),
            child: Center(
              child: Text(
                '${percent < 0 ? '0' : percent}%',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.basicwhiteColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
