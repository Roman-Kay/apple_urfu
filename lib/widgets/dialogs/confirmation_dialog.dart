
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/utils/colors.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({Key? key, this.text}) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pop(true);
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.basicwhiteColor,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey50Color.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Row(
                    children: [
                      SizedBox(width: 14.w),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientTurquoiseReverse,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/checkmark.svg',
                          width: 20.w,
                          height: 20.h,
                          color: AppColors.darkGreenColor,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Text(
                        text ?? "Данные сохранены",
                        style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: AppColors.darkGreenSecondaryColor
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
