import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

// ignore: must_be_immutable
class PaidItemWrap extends StatelessWidget {
  PaidItemWrap({
    super.key,
    required this.text_1,
    this.text_2,
    this.onPressed,
    this.width_now_with_w = 160,
    this.height_now_with_h = 100,
    required this.isSet,
  });
  final String text_1;
  String? text_2;
  double width_now_with_w;
  double height_now_with_h;
  final bool isSet;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: AppColors.gradientThird,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: width_now_with_w.w,
          height: height_now_with_h.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: isSet ? AppColors.limeColor : AppColors.basicwhiteColor,
            boxShadow: [
              BoxShadow(
                color: isSet
                    ? AppColors.darkGreenColor.withOpacity(0.1)
                    : AppColors.grey50Color.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: FormForButton(
            borderRadius: BorderRadius.circular(15.r),
            onPressed: onPressed,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text_1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                  SizedBox(height: text_2 != null ? 8.h : 0),
                  text_2 != null
                      ? Text(
                          text_2!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            color: AppColors.greenColor,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
