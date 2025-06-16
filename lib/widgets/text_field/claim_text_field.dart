
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

class ClaimTextField extends StatelessWidget {
  const ClaimTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.maxLines
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      //constraints: BoxConstraints(maxWidth: 64.h),
      width: double.infinity,
      margin: EdgeInsetsDirectional.only(bottom: 18.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.seaColor),
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.basicwhiteColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        child: Center(
          child: TextFormField(
            keyboardType: keyboardType ?? TextInputType.text,
            controller: controller,
            maxLines: maxLines ?? 1,
            textInputAction: TextInputAction.done,
            onEditingComplete: (){
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            minLines: 1,
            style: TextStyle(
              color: AppColors.darkGreenColor,
              fontSize: 16.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              isDense: true,
              labelText: label,
              labelStyle: TextStyle(
                color: AppColors.grey50Color,
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
