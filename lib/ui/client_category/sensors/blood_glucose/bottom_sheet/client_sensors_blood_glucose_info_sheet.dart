import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';

class BloodGlucoseInfoSheet extends StatelessWidget {
  const BloodGlucoseInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.basicwhiteColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.limeColor,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    "Гипогликемией называют состояние, при котором в крови человека снижается уровень сахара (глюкозы). Глюкоза -  углевод, являющийся главным источником энергии в человеческом организме. Крайне важно, чтобы сахар в крови держался на определенном уровне для того, чтобы человек функционировал нормально.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),

                  SizedBox(height: 30.h),
                  WidgetButton(
                    onTap: () => context.router.maybePop(),
                    boxShadow: true,
                    color: AppColors.darkGreenColor,
                    child: Text(
                      'вернуться'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        color: AppColors.basicwhiteColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
