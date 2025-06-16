import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

class ChooseQualityContainer extends StatelessWidget {
  final Color color;
  final String text;
  void Function() onPressed;
   ChooseQualityContainer({
    super.key,
    required this.color,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: 36.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: color,
      ),
      child: FormForButton(
        borderRadius: BorderRadius.circular(4.r),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                fontFamily: 'Inter',
                color: AppColors.basicwhiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
