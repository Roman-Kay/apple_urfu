import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'dart:io' show Platform;


class ErrorHandler extends StatelessWidget {
  const ErrorHandler({Key? key, required this.addValueFunction}) : super(key: key);

  final Function() addValueFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.w).copyWith(top: 70.h),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.darkGreenColor.withOpacity(0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Platform.isAndroid
                ? 'Не удалось установить соединение с Google Fit'
                : 'Не удалось установить соединение с Apple Health',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              color: AppColors.basicwhiteColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Попробуйте повторить или',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              color: AppColors.basicwhiteColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: FormForButton(
                borderRadius: BorderRadius.circular(8.r),
                onPressed: addValueFunction,
                child: Container(
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: AppColors.basicwhiteColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      "Ввести данные вручную".toUpperCase(),
                      style: TextStyle(
                          fontFamily: "Inter",
                          color: AppColors.darkGreenColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}
