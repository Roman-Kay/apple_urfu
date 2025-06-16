import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/utils/colors.dart';

// ignore: must_be_immutable
class InfoRow extends StatelessWidget {
  final String image;
  bool? whiteBackground;
  final String name;
  final String? text;
  final Widget? widget;
  bool? removePadding;
  InfoRow({
    super.key,
    required this.image,
    this.whiteBackground,
    required this.name,
    this.text,
    this.widget,
    this.removePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: removePadding == true ? 0 : 15.w),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  whiteBackground == true
                      ? Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: AppColors.basicwhiteColor,
                          ),
                        )
                      : const SizedBox(),
                  SvgPicture.asset(
                    image,
                    width: 24.w,
                    height: 24.h,
                    color: AppColors.vivaMagentaColor,
                  ),
                ],
              ),
              SizedBox(width: whiteBackground == true ? 17.w : 28.w),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  color: AppColors.darkGreenColor,
                ),
              ),
              const Spacer(),
              text != null
                  ? Text(
                      text!,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        color: AppColors.darkGreenColor,
                      ),
                    )
                  : widget != null
                      ? widget!
                      : const SizedBox()
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            height: 1,
            decoration: BoxDecoration(
              gradient: AppColors.gradientTurquoise,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

// Padding infoRow(
//   String image,
//   bool? whiteBackground,
//   String name,
//   String? text,
//   Widget? widget,
//   bool? removePadding,
// ) {
//   return
// }
