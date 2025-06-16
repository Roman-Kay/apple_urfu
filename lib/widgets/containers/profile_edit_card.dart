// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProfileCard extends StatelessWidget {
  ProfileCard(
      {Key? key,
      required this.controller,
      required this.text,
      required this.title,
      required this.type,
      this.onTap,
      this.enabled,
      this.onChanged,
      this.onEditingComplete,
      this.maxLines,
      this.date,
      this.validationBorderColor,
      required this.mask})
      : super(key: key);

  String text;
  String title;
  MaskTextInputFormatter mask;
  TextEditingController controller;
  TextInputType type;
  bool? enabled;
  Function()? onTap;
  Function()? onEditingComplete;
  Function(String)? onChanged;
  int? maxLines;
  bool? date;
  Color? validationBorderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            fontFamily: 'Inter',
            color: AppColors.darkGreenColor,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: TextField(
            onEditingComplete: onEditingComplete,
            onChanged: onChanged,
            enabled: enabled ?? true,
            controller: controller,
            style: TextStyle(
              fontFamily: 'Inter',
              color: AppColors.darkGreenColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
            minLines: 1,
            maxLines: maxLines,
            keyboardType: type,
            inputFormatters: [
              mask ?? MaskTextInputFormatter(),
            ],
            decoration: InputDecoration(
              suffixIconConstraints: BoxConstraints(
                minHeight: 17.w + 14.h * 2,
                minWidth: 19.h + 14.w * 2,
              ),
              suffixIcon: date == true
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: SvgPicture.asset(
                        AppImeges.calendar_black_svg,
                        color: AppColors.vivaMagentaColor,
                        width: 18.w,
                        height: 19.h,
                      ),
                    )
                  : null,
              fillColor: AppColors.basicwhiteColor,
              filled: true,
              hintText: title,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 24.h,
              ),
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: validationBorderColor ?? AppColors.seaColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: validationBorderColor ?? AppColors.darkGreenColor,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: validationBorderColor ?? AppColors.seaColor,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: validationBorderColor ?? AppColors.seaColor,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
