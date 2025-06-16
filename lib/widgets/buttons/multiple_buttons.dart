
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/utils/colors.dart';

class MultipleButtonsContainer extends StatelessWidget {
  final String imageName;
  final String text;
  final bool isChoose;

  const MultipleButtonsContainer({
    super.key,
    required this.imageName,
    required this.text,
    required this.isChoose
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(isChoose ? 1 : 0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          gradient: isChoose ? AppColors.gradientTurquoise : null,
          border: isChoose == false
              ? Border.all(
            width: 1,
            color: AppColors.seaColor,
          )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 4.h,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                imageName,
                height: 36.h,
              ),
              // Image.asset(
              //   imageName,
              //   height: 36.h,
              // ),
              SizedBox(width: 8.w),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  color: AppColors.darkGreenColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}