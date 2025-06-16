import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

// ignore: must_be_immutable
class CalendarRow extends StatefulWidget {
  CalendarRow({
    super.key,
    this.color,
    this.needPeriud,
    required this.selectedDate,
    this.onPressedDateCon,
    this.onPressedLeft,
    this.onPressedRight,
  });
  final Color? color;

  final bool? needPeriud;
  final DateTime selectedDate;
  void Function()? onPressedLeft;
  void Function()? onPressedRight;
  void Function()? onPressedDateCon;

  @override
  State<CalendarRow> createState() => _CalendarRowState();
}

class _CalendarRowState extends State<CalendarRow> {
  @override
  Widget build(BuildContext context) {
    DateTime nowOnlyDate = DateUtils.dateOnly(DateTime.now());
    DateTime selectedOnlyDate = DateUtils.dateOnly(widget.selectedDate);
    return Row(
      children: [
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              child: FormForButton(
                borderRadius: BorderRadius.circular(32.r),
                onPressed: widget.onPressedLeft,
                child: Transform.rotate(
                  angle: pi,
                  child: SvgPicture.asset(
                    'assets/images/arrow_black.svg',
                    color: widget.color ?? AppColors.darkGreenColor,
                    height: 32.r,
                  ),
                ),
              ),
            ),
            Text(
              nowOnlyDate == selectedOnlyDate
                  ? 'Сегодня'
                  : nowOnlyDate.subtract(Duration(days: 1)) == selectedOnlyDate
                      ? 'Вчера'
                      : '${widget.needPeriud == null ? CalendarStorage.dayOfWeekSmall[selectedOnlyDate.weekday]!.toLowerCase() : CalendarStorage.dayOfWeek[selectedOnlyDate.weekday]}, ${selectedOnlyDate.day} ${CalendarStorage.nameMonthByNumber[selectedOnlyDate.month]}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                decorationColor: widget.color ?? AppColors.darkGreenColor,
                fontFamily: 'Inter',
                color: widget.color ?? AppColors.darkGreenColor,
              ),
            ),
            Container(
              width: 32.r,
              height: 32.r,
              child: FormForButton(
                borderRadius: BorderRadius.circular(32.r),
                onPressed: widget.onPressedRight,
                child: SvgPicture.asset(
                  'assets/images/arrow_black.svg',
                  color: widget.color ?? AppColors.darkGreenColor,
                  height: 32.r,
                ),
              ),
            ),
          ],
        )),
        SizedBox(width: 12.w),
        Container(
          height: 36.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.basicwhiteColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.basicblackColor.withOpacity(0.1),
                blurRadius: 10.r,
              ),
            ],
          ),
          child: FormForButton(
            borderRadius: BorderRadius.circular(8.r),
            onPressed: widget.onPressedDateCon,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Text(
                    'День',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SvgPicture.asset(
                    AppImeges.calendar_black_svg,
                    color: AppColors.darkGreenColor,
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
