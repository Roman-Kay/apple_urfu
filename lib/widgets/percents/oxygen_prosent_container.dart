import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/utils/colors.dart';

class OxygenPercentContainer extends StatelessWidget {
  const OxygenPercentContainer({
    super.key,
    required this.percent,
  });

  final int percent;

  @override
  Widget build(BuildContext context) {
    double position = getPossition(percent);

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final double width = constraints.maxWidth;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.basicwhiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey50Color.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8.r),
                ),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            height: 10.h,
                            color: AppColors.vivaMagentaColor,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 10.h,
                            color: AppColors.orangeColor,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 10.h,
                            color: AppColors.greenLightColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: ((width / 15) - ((38 / 2).w)) + (width / 15) * position < 0
                              ? 0
                              : ((width / 15) - ((38 / 2).w)) + (width / 15) * position),
                      child: SizedBox(
                        width: 38.w,
                        height: 44.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/union_2.svg',
                              width: 38.w,
                              height: 44.h,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: Text(
                                  '$percent',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    fontFamily: 'Inter',
                                    color: AppColors.basicwhiteColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Divider(true),
                _Divider(false),
                _Divider(false),
                _Divider(false),
                _Divider(false),
                _Divider(true),
                _Divider(false),
                _Divider(false),
                _Divider(false),
                _Divider(false),
                _Divider(true),
                _Divider(false),
                _Divider(false),
                _Divider(false),
                _Divider(false),
                _Divider(true),
              ],
            ),
          ),
          SizedBox(
            width: width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: text('90'),
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      text('95'),
                      SizedBox(width: width / 4 + 4.w),
                      text('98'),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: text('100'),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Container _Divider(big) {
    return Container(
      width: 1,
      height: big ? 20 : 10,
      color: AppColors.grey50Color,
    );
  }

  Text text(text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16.sp,
        fontFamily: 'Inter',
        color: AppColors.grey50Color,
      ),
    );
  }
}

double getPossition(int prossent) {
  if (prossent <= 91) {
    return 0;
  } else if (prossent >= 99.6) {
    return 13;
  } else if (prossent < 99.6 && prossent >= 98) {
    return 9 + (prossent - 98) / (2 / 5);
  } else if (prossent < 98 && prossent >= 95) {
    return 4 + (prossent - 95) / (3 / 5);
  } else if (prossent < 95 && prossent >= 90) {
    return 4 + (prossent - 90) / (5 / 5);
  }
  return 0;
}
