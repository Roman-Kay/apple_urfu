import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

// ignore: must_be_immutable
class PortionButton extends StatefulWidget {
  PortionButton({
    super.key,
    this.isBig,
    required this.text,
    required this.borderColor,
    this.backgroundColor,
    this.backgroundColorChoose,
    this.textColorChoose,
    required this.textColor,
    this.onChanged,
    this.haveNullSize,
    this.textEditingController,
    this.isChoose,
    this.gradient,
    this.nullPadding,
    this.isShadow = true
  });
  final bool? isBig;
  final Color? backgroundColorChoose;
  final Color? textColorChoose;
  final bool? nullPadding;
  final bool? haveNullSize;
  bool? isChoose;
  TextEditingController? textEditingController;
  final String text;
  void Function(String)? onChanged;
  final Color borderColor;
  Color? backgroundColor;
  final Color textColor;
  Gradient? gradient;
  bool isShadow;

  @override
  State<PortionButton> createState() => _PortionButtonState();
}

class _PortionButtonState extends State<PortionButton> {
  String text = '';
  bool isChoose = false;

  @override
  Widget build(BuildContext context) {
    return widget.haveNullSize == true
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: widget.isChoose == null
                  ? isChoose
                      ? widget.backgroundColorChoose ?? widget.borderColor
                      : widget.backgroundColor
                  : widget.isChoose!
                      ? widget.backgroundColorChoose ?? widget.borderColor
                      : widget.backgroundColor,
              gradient: widget.gradient,
              border: Border.all(
                color: widget.borderColor,
                width: 1,
              ),
              boxShadow: widget.isShadow ? [
                BoxShadow(
                  color: AppColors.basicblackColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  // offset: Offset(0, 10),
                ),
              ] : [],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.nullPadding == true ? 8.w : 16.w, vertical: 8.h),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: widget.isChoose == null
                      ? isChoose
                          ? widget.textColorChoose ?? widget.textColor
                          : widget.textColor
                      : widget.isChoose!
                          ? widget.textColorChoose ?? widget.textColor
                          : widget.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        : widget.isBig == null || widget.isBig == false
            ? Container(
                height: 36.h,
                width: (MediaQuery.of(context).size.width - 26.w - 25.w * 2) / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: widget.isChoose == null
                      ? isChoose
                          ? widget.backgroundColorChoose ?? widget.borderColor
                          : widget.backgroundColor
                      : widget.isChoose!
                          ? widget.backgroundColorChoose ?? widget.borderColor
                          : widget.backgroundColor,
                  border: Border.all(
                    color: widget.isChoose == null
                        ? isChoose
                            ? widget.backgroundColorChoose ?? widget.borderColor
                            : widget.borderColor
                        : widget.isChoose!
                            ? widget.backgroundColorChoose ?? widget.borderColor
                            : widget.borderColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.basicblackColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      // offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: widget.isChoose == null
                          ? isChoose
                              ? widget.textColorChoose ?? widget.textColor
                              : widget.textColor
                          : widget.isChoose!
                              ? widget.textColorChoose ?? widget.textColor
                              : widget.textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : Container(
                height: 36.h,
                width: (MediaQuery.of(context).size.width - 26.w - 25.w * 2) / 3 * 2 + 25.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: widget.backgroundColor,
                  border: Border.all(
                    color: widget.borderColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.basicblackColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 0,
                            maxWidth: 180.w,
                          ),
                          child: Center(
                            child: TextFormField(
                              onChanged: widget.onChanged,
                              controller: widget.textEditingController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: (){
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.focusedChild?.unfocus();
                                }
                              },
                              maxLength: 12,
                              style: TextStyle(
                                color: widget.isChoose == null
                                    ? isChoose
                                        ? widget.textColorChoose ?? widget.textColor
                                        : widget.textColor
                                    : widget.isChoose!
                                        ? widget.textColorChoose ?? widget.textColor
                                        : widget.textColor,
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                isDense: true,
                                hintText: text == '' ? 'Свой вариант' : '',
                                hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  color: widget.textColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      text == ''
                          ? const SizedBox()
                          : Text(
                              ' ${widget.text}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: widget.isChoose == null
                                    ? isChoose
                                        ? widget.textColorChoose ?? widget.textColor
                                        : widget.textColor
                                    : widget.isChoose!
                                        ? widget.textColorChoose ?? widget.textColor
                                        : widget.textColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                    ],
                  ),
                ),
              );
  }
}
