import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/utils/colors.dart';

// ignore: must_be_immutable
class SearchContainer extends StatelessWidget {
  String? text;
  Function(String)? onChanged;
  SearchContainer({super.key, this.text, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        cursorColor: AppColors.darkGreenColor,
        onChanged: onChanged,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: AppColors.basicblackColor),
        decoration: InputDecoration(
          fillColor: AppColors.grey10Color,
          filled: true,
          isDense: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
            ),
            child: SvgPicture.asset(
              'assets/images/search.svg',
              color: AppColors.grey50Color,
              height: 20.h,
            ),
          ),
          hintText: text ?? 'Поиск',
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          hintStyle: TextStyle(
            height: 1,
            fontFamily: 'Inter',
            color: AppColors.grey50Color,
            decoration: TextDecoration.none,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.grey10Color, width: 2.w),
            borderRadius: BorderRadius.all(
              Radius.circular(8.r),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.grey10Color),
            borderRadius: BorderRadius.all(
              Radius.circular(8.r),
            ),
          ),
        ),
      ),
    );
  }
}
