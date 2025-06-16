import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';


class AddFileDialog extends StatefulWidget {
  const AddFileDialog({super.key});

  @override
  State<AddFileDialog> createState() => _AddFileDialogState();
}

class _AddFileDialogState extends State<AddFileDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.backgroundgradientColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Text(
                  'Прикрепить\nдокументы',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.darkGreenColor,
                    fontFamily: 'Inter',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 24.h),
                WidgetButton(
                  onTap: () {
                    context.router.maybePop("doc");
                  },
                  color: AppColors.darkGreenColor,
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      SvgPicture.asset(
                        AppImeges.paperclip,
                        width: 24.w,
                        height: 24.h,
                        color: AppColors.basicwhiteColor,
                      ),
                      SizedBox(width: 32.w),
                      Text(
                        'Загрузить файл'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: AppColors.basicwhiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                WidgetButton(
                  onTap: () {
                    context.router.maybePop("photo");
                  },
                  boxShadow: true,
                  color: AppColors.darkGreenColor,
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      SvgPicture.asset(
                        'assets/images/camera.svg',
                        width: 24.w,
                        height: 24.h,
                        color: AppColors.basicwhiteColor,
                      ),
                      SizedBox(width: 32.w),
                      Text(
                        'Сфотографировать'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: AppColors.basicwhiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
