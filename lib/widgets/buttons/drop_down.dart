import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/utils/colors.dart';

class DropDown extends StatelessWidget {
  final String dropdownvalue;
  final List<String> items;
  Color? colorText;
  Color? colorBack;

  final void Function(String?)? onChanged;

  DropDown({
    super.key,
    required this.dropdownvalue,
    required this.items,
    this.onChanged,
    this.colorText,
    this.colorBack,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          dropdownColor: colorBack ?? AppColors.grey10Color,
          borderRadius: BorderRadius.circular(10.r),
          elevation: 0,
          value: dropdownvalue,
          alignment: Alignment.centerRight,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, fontFamily: 'Inter', color: colorText ?? AppColors.tifannyColor),
          padding: EdgeInsets.zero,
          icon: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Transform.rotate(
              angle: pi / 2,
              child: SvgPicture.asset(
                'assets/images/arrow_black.svg',
                color: colorText ?? AppColors.tifannyColor,
                height: 24.h,
              ),
            ),
          ),
          items: items.map((String items) {
            return DropdownMenuItem(
                value: items,
                child: Text(
                  items,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ));
          }).toList(),
          onChanged: onChanged),
    );
  }
}
