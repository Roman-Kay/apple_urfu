import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/domain/controllers/image/image_picker_service.dart';
import 'package:garnetbook/utils/colors.dart';


class ImagePickerBottomSheet extends StatefulWidget {
  const ImagePickerBottomSheet({super.key});

  @override
  State<ImagePickerBottomSheet> createState() => _ImagePickerBottomSheetState();
}

class _ImagePickerBottomSheetState extends State<ImagePickerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  File? image = await ImagePickerService().chooseImageFileCamera();
                  Navigator.pop(context, image);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 25,
                      color: AppColors.darkGreenColor,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Камера",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  File? image = await ImagePickerService().chooseImageFileGallery();
                  Navigator.pop(context, image);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 25,
                      color: AppColors.darkGreenColor,
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Галерея",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

}


