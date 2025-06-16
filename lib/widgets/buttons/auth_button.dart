import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final String imageName;
  final void Function()? onPressed;
  final Color colorText;
  final Color backColor;

  final dynamic border;

  const AuthButton({
    super.key,
    required this.text,
    required this.imageName,
    required this.onPressed,
    required this.colorText,
    required this.backColor,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: border.runtimeType == Color ? border : null,
        gradient: border.runtimeType != Color ? border : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.blueBasicColor,
          ),
          child: FormForButton(
            child: Row(
              children: [
                const Spacer(),
                SvgPicture.asset(
                  'assets/images/$imageName.svg',
                  width: 34.w,
                  height: 34.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  text.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: colorText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
              ],
            ),
            borderRadius: BorderRadius.circular(8.r),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
