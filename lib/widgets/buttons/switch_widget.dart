import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

// ignore: must_be_immutable
class SwitchWidget extends StatefulWidget {
  bool isSwitched;
  Color activeColor;
  Color activeTrackColor;
  Color inactiveTrackColor;
  Color inactiveThumbColor;
  Function(bool)? onChanged;

  SwitchWidget({
    super.key,
    this.isSwitched = false,
    this.activeColor = AppColors.greenColor,
    this.activeTrackColor = AppColors.basicwhiteColor,
    this.inactiveTrackColor = AppColors.grey20Color,
    this.inactiveThumbColor = AppColors.grey40Color,
    this.onChanged,
  });

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: false),
      child: Switch(
        activeColor: widget.activeColor,
        activeTrackColor: widget.activeTrackColor,
        inactiveTrackColor: widget.inactiveThumbColor,
        inactiveThumbColor: widget.inactiveThumbColor,
        value: widget.isSwitched,
        onChanged: widget.onChanged ?? (value) => setState(() => widget.isSwitched = value),
      ),
    );
  }
}

class SwitchWidgetSecond extends StatefulWidget {
  const SwitchWidgetSecond({super.key});

  @override
  State<SwitchWidgetSecond> createState() => _SwitchWidgetSecondState();
}

class _SwitchWidgetSecondState extends State<SwitchWidgetSecond> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52.w,
      height: 24.h,
      child: Theme(
        data: ThemeData(useMaterial3: false),
        child: Switch(
            activeColor: AppColors.grey20Color,
            activeTrackColor: AppColors.grey40Color,
            inactiveTrackColor: AppColors.lightGreenColor,
            inactiveThumbColor: AppColors.greenColor,
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });
            }),
      ),
    );
  }
}

class SwitchWidgetThird extends StatefulWidget {
  const SwitchWidgetThird({super.key});

  @override
  State<SwitchWidgetThird> createState() => _SwitchWidgetThirdState();
}

class _SwitchWidgetThirdState extends State<SwitchWidgetThird> {
  bool isSwitched = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52.w,
      height: 24.h,
      child: Switch(
          activeColor: AppColors.grey20Color,
          activeTrackColor: AppColors.grey40Color,
          inactiveTrackColor: AppColors.lightGreenColor,
          inactiveThumbColor: AppColors.greenColor,
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
            });
          }),
    );
  }
}
