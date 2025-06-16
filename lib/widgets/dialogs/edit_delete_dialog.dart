import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';

class EditDeleteDialog extends StatelessWidget {
  const EditDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.basicwhiteColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Text(
                  'Выберите действие',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.darkGreenColor,
                    fontFamily: 'Inter',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: WidgetButton(
                        onTap: () {
                          Navigator.pop(context, "delete");
                        },
                        color: AppColors.lightGreenColor,
                        child: Text(
                          'удалить'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 24.w),
                    Expanded(
                      child: WidgetButton(
                        onTap: () {
                          Navigator.pop(context, "edit");
                        },
                        boxShadow: true,
                        color: AppColors.darkGreenColor,
                        child: Text(
                          'изменить'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            color: AppColors.basicwhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
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
