import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';


class PhysicalSurveyBottomSheet extends StatelessWidget {
  PhysicalSurveyBottomSheet({
    required this.text,
    required this.image,
    super.key});

  final String text;
  final List<String> image;

  String getImage(String image) {
    String temp = 'data:image/jpeg;base64,';
    String newImage = image.replaceAll(temp, '').trim();
    return newImage;
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Container(
                  height: 200.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: ClampingScrollPhysics(),
                    itemCount: image.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            image.length > 1 ? EdgeInsets.only(right: 13.w) : null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.r),
                          border: Border.all(
                              width: 2, color: AppColors.vivaMagentaColor),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.r),
                          child: Image.memory(
                            base64Decode(getImage(image[index])),
                            height: 175.h,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGreenColor,
                ),
              ),
              SizedBox(height: 30.h),
              WidgetButton(
                onTap: () => context.router.maybePop(),
                boxShadow: true,
                color: AppColors.darkGreenColor,
                child: Text(
                  'закрыть'.toUpperCase(),
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
      ],
    );
  }
}
