// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

class WidgetButton extends StatelessWidget {
  WidgetButton({
    super.key,
    this.text,
    required this.onTap,
    this.color,
    this.colorBorder,
    this.child,
    this.boxShadow,
    this.gradient,
    this.textColor,
    this.radius,
    this.height,
  });
  final String? text;
  Color? colorBorder;

  final Widget? child;
  final Color? textColor;

  final Function() onTap;
  bool? boxShadow;
  Color? color;
  Gradient? gradient;
  double? radius;
  double? height;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: height ?? 65.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 8.r),
        color: color,
        gradient: gradient,
        boxShadow: boxShadow == true
            ? [
                BoxShadow(
                  color: AppColors.basicblackColor.withOpacity(0.1),
                  blurRadius: 10.r,
                  offset: Offset(0, 2),
                )
              ]
            : null,
        border: colorBorder == null ? null : Border.all(width: 2, color: colorBorder!),
      ),
      child: FormForButton(
        borderRadius: BorderRadius.circular(8.r),
        onPressed: onTap,
        child: text == null
            ? child ?? SizedBox()
            : Center(
                child: Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: textColor ?? AppColors.basicwhiteColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
      ),
    );
  }
}
