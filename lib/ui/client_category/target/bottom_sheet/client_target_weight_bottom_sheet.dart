import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';

class ClientTargetWeightBottomSheet extends StatelessWidget {
  const ClientTargetWeightBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.limeColor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(
                  text: "Ваш текущий вес превышает",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGreenColor,
                    fontFamily: 'Inter',
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: " 80 кг,",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGreenColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                    TextSpan(
                      text: " пожалуйста обратитесь к нашим специалистам за дополнительной консультацией",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGreenColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(
                    child: WidgetButton(
                      onTap: () {
                        context.router.maybePop(true);
                      },
                      color: AppColors.lightGreenColor,
                      child: Text(
                        'продолжить'.toUpperCase(),
                        textAlign: TextAlign.center,
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
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }
}
