// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/domain/controllers/image/image_picker_service.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';

class ClientFoodDiaryPickImageSheet extends StatelessWidget {
  ClientFoodDiaryPickImageSheet({super.key});

  File? image;

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
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: WidgetButton(
                        onTap: () async{
                          image = await ImagePickerService().chooseImageFileCamera();
                          Navigator.pop(context, image);
                        },
                        color: AppColors.lightGreenColor,
                        child: Text(
                          'сфотографировать'.toUpperCase(),
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
                    Expanded(
                      child: WidgetButton(
                        onTap: () async{
                          image = await ImagePickerService().chooseImageFileGallery();
                          Navigator.pop(context, image);
                        },
                        boxShadow: true,
                        color: AppColors.darkGreenColor,
                        child: Text(
                          'выбрать из галереи'.toUpperCase(),
                          textAlign: TextAlign.center,
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
      ],
    );
  }
}
