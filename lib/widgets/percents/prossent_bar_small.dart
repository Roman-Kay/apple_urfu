import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

class ProssentBarSmall extends StatelessWidget {
  final double prossentWidth;
  final double? width;
  final double? hiegth;
  final Color? backColor;
  final Gradient? prossentGradeint;

  const ProssentBarSmall({
    super.key,
    required this.prossentWidth,
    this.width,
    this.hiegth,
    this.backColor,
    this.prossentGradeint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hiegth ?? 10,
      width: width ?? 120.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: backColor ?? AppColors.basicwhiteColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: (hiegth ?? 10) - 4,
            width: prossentWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: prossentGradeint != null ? null : Color(0xFFD25C78),
              gradient: prossentGradeint,
            ),
          ),
        ),
      ),
    );
  }
}
