import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/utils/colors.dart';

// ignore: must_be_immutable
class TargetContainer extends StatefulWidget {
  final String text;
  bool haveOpacity;

  TargetContainer({
    super.key,
    required this.text,
    this.haveOpacity = false,
  });

  @override
  State<TargetContainer> createState() => _TargetContainerState();
}

class _TargetContainerState extends State<TargetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: widget.haveOpacity
            ? AppColors.basicwhiteColor.withOpacity(0.8)
            : AppColors.basicwhiteColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  color: AppColors.darkGreenColor,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/images/arrow_black.svg',
              width: 24.w,
              height: 24.h,
              color: AppColors.vivaMagentaColor,
            ),
          ],
        ),
      ),
    );
  }
}
