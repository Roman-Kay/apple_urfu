import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';

class ModalSheet extends StatelessWidget {
  ModalSheet({
    super.key,
    required this.title,
    required this.content,
    this.color,
    this.tabBarColor,
    this.tabBarGradient,
    this.image,
    this.icon
  });
  final dynamic title;
  final Widget content;
  final Color? color;
  final Color? tabBarColor;
  final Gradient? tabBarGradient;
  final String? image;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: tabBarGradient,
                  color: tabBarGradient == null || image != null
                      ? tabBarColor ?? AppColors.basicwhiteColor
                      : null,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    if (image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.asset(
                          image!,
                          fit: BoxFit.cover,
                          height: 66.h,
                          width: 375.w,
                        ),
                      ),
                    Column(
                      children: [
                        SizedBox(height: 4.h),
                        Center(
                          child: Container(
                            height: 4,
                            width: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColors.grey20Color,
                            ),
                          ),
                        ),
                        title == null
                            ? SizedBox()
                            : Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.router.maybePop();
                              },
                              icon: Image.asset(
                                AppImeges.arrow_back_png,
                                color: color ?? AppColors.darkGreenColor,
                                height: 25.h,
                                width: 25.w,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: title.runtimeType == String
                                  ? SizedBox(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp,
                                    fontFamily: 'Inter',
                                    color: color ??
                                        AppColors.darkGreenColor,
                                  ),
                                ),
                              )
                                  : title,
                            ),
                            SizedBox(width: 8.w),

                            if(icon != null)
                              icon!,
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ColoredBox(
                color: AppColors.basicwhiteColor,
                child: content,
              ),
            ],
          ),
        )
    );
  }
}
