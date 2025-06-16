import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

class ShowDeleteDialog extends StatelessWidget {
  const ShowDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4.h),
          Container(
            height: 4,
            width: 36.w,
            decoration: BoxDecoration(
              color: AppColors.grey20Color,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: FormForButton(
                  borderRadius: BorderRadius.circular(16.r),
                  onPressed: () => Navigator.pop(context, "show"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 8.h),
                      SvgPicture.asset(
                        'assets/images/open.svg',
                        height: 25.h,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Открыть',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.darkGreenColor,
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: FormForButton(
                  borderRadius: BorderRadius.circular(16.r),
                  onPressed: () => Navigator.pop(context, "edit_name"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 8.h),
                      SvgPicture.asset(
                        'assets/images/edit.svg',
                        color: AppColors.darkGreenColor,
                        height: 25.h,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Изменить',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.darkGreenColor,
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: FormForButton(
                  borderRadius: BorderRadius.circular(16.r),
                  onPressed: () => Navigator.pop(context, "delete"),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 8.h),
                      SvgPicture.asset(
                        'assets/images/trash.svg',
                        color: AppColors.darkGreenColor,
                        height: 25.h,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Удалить',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.darkGreenColor,
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
