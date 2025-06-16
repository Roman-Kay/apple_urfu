import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

class AddFitButton extends StatelessWidget {
  final Function()? onPressed;
  final bool? isErrorRequest;

  const AddFitButton({
    super.key,
    required this.onPressed,
    this.isErrorRequest = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isErrorRequest == true ? 160.w : 109.w,
      height: 36.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: isErrorRequest == true ? AppColors.darkGreenColor : AppColors.vivaMagentaColor,
      ),
      child: FormForButton(
        borderRadius: BorderRadius.circular(4.r),
        onPressed: onPressed,
        child: Center(
            child: Text(
              isErrorRequest == true
                  ? "Ввести вручную".toUpperCase()
                  :Platform.isIOS ? '+ apple fit'.toUpperCase() : '+ google fit'.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.basicwhiteColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ),
    );
  }
}
