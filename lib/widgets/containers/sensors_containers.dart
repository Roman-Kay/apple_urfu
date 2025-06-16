import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/version/version_cubit.dart';
import 'package:garnetbook/main.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

class SensorsDataContainer extends StatelessWidget {
  SensorsDataContainer({
    Key? key,
    required this.name,
    required this.onTap,
    this.image,
    required this.title,
    this.isNotForFreeVersion,
    required this.needContainer,
    required this.textWidget,
  }) : super(key: key);

  final Function() onTap;
  final String? image;
  final String name;
  final Widget textWidget;
  final String title;
  final bool needContainer;
  final bool? isNotForFreeVersion;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VersionCubit, bool>(
      builder: (context, isFreeVersion) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            height: 99.w,
            width: 164.w,
            decoration: BoxDecoration(
              color: AppColors.grey20Color,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.basicblackColor.withOpacity(0.1),
                  blurRadius: 10.r,
                ),
              ],
            ),
            child: Stack(
              children: [
                image != null
                    ? Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: isNotForFreeVersion == true && isFreeVersion == true ? 4 : 0,
                            sigmaY: isNotForFreeVersion == true && isFreeVersion == true ? 4 : 0,
                          ),
                          child: Image.asset(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox(),
                Container(
                  height: 99.w,
                  width: 164.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.basicblackColor.withOpacity(0.6),
                        AppColors.basicblackColor.withOpacity(0),
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: isNotForFreeVersion == true && isFreeVersion == true ? 0.5 : 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.w, bottom: 12.h, top: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            textDirection: TextDirection.ltr,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: name.split(" ").length == 1 ? name : name.split(" ")[0],
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Inter',
                                    color: AppColors.basicwhiteColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: name.substring(
                                    name.split(" ")[0].length,
                                    name.length,
                                  ),
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Inter',
                                    color: AppColors.basicwhiteColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )),
                        const Spacer(),
                        textWidget,
                        SizedBox(height: 4.h),
                        Container(
                          decoration: needContainer
                              ? BoxDecoration(borderRadius: BorderRadius.circular(3.r), color: AppColors.basicblackColor.withOpacity(0.5))
                              : null,
                          child: Padding(
                            padding: needContainer ? EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h) : EdgeInsets.all(0),
                            child: SizedBox(
                              width: title.length >= 23 ? 164.w - 16.w - 8.w - 10.w : null,
                              child: FittedBox(
                                child: Text(
                                  title.isEmpty ? ' ' : title,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.grey20Color,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FormForButton(
                  borderRadius: BorderRadius.circular(8.r),
                  onPressed: isNotForFreeVersion == true && isFreeVersion == true ? null : onTap,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
