import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/utils/colors.dart';

class PointChart extends StatelessWidget {
  final double heightChart;
  final double widthChart;
  final String text;
  final FlSpot flSpot;
  // final double x;
  // final double y;
  final int xMax;
  final int yMax;
  const PointChart({
    super.key,
    required this.heightChart,
    required this.widthChart,
    required this.text,
    required this.flSpot,
    // required this.y,
    required this.xMax,
    required this.yMax,
  });

  @override
  Widget build(BuildContext context) {
    final double widthPoint = 55.w;
    final double hiegthPoint = 28.w;

    return Padding(
      padding: EdgeInsets.only(
        bottom: (heightChart - hiegthPoint / 2) / yMax * (flSpot.y - 1) +
            (30 - hiegthPoint) +
            8.h +
            6,
        left: flSpot.x > (xMax + 1) / 2
            ? widthChart / (xMax - 1) * (flSpot.x - 1) - widthPoint
            : ((widthChart) / (xMax - 1) * (flSpot.x - 1)) + 1,
      ),
      child: Container(
        transform: Matrix4.translationValues(
          // 0,
          (flSpot.x > (xMax + 1) / 2 ? 1 : -1) * (widthPoint / 2),
          -hiegthPoint,
          0,
        ),
        width: widthPoint,
        height: hiegthPoint,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/union.svg',
              width: widthPoint,
              height: hiegthPoint,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: AppColors.basicwhiteColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'кг',
                    style: TextStyle(
                      color: AppColors.basicwhiteColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
