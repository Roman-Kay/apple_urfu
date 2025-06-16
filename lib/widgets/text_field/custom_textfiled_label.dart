import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';

// ignore: must_be_immutable
class CustomTextFieldLabel extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  Function(String)? onChanged;
  String hintText;
  Color labelColor;
  Color textColor;
  bool? needIconNeerTheText;
  bool? enabled;
  Color backGroudColor;
  Color borderColor;
  Color? hintColor;
  double? fontSizeHint;
  bool showLabel;
  bool multiLines;
  bool labelAlwaysTop;
  bool? textUnderLine;
  bool isSmall;
  Widget icon;
  TextInputType? keyboardType;
  String? suffixText;
  Gradient? gradient;
  bool? textIsBold;
  List<TextInputFormatter>? listMaskTextInputFormatter;
  bool? isLast;
  bool? boxShadow;
  FormFieldValidator<String>? validator;
  AutovalidateMode? autovalidateMode;
  FocusNode? focusNode;
  int? maxLines;
  bool? textIsBig;
  Function()? onTap;
  int? maxLength;
  EdgeInsets? scrollPadding;
  bool? textIsCenter;
  bool? paddingNull;

  CustomTextFieldLabel({
    super.key,
    required this.controller,
    this.focusNode,
    this.validator,
    this.hintColor,
    this.boxShadow,
    this.needIconNeerTheText,
    this.fontSizeHint,
    this.autovalidateMode,
    this.isLast,
    this.textIsBig,
    this.maxLines,
    this.labelText,
    this.gradient,
    this.textUnderLine,
    this.onChanged,
    this.textIsBold,
    this.labelColor = AppColors.darkGreenColor,
    this.textColor = AppColors.darkGreenColor,
    this.multiLines = false,
    this.enabled = true,
    this.keyboardType,
    this.listMaskTextInputFormatter,
    this.hintText = '',
    this.isSmall = false,
    this.showLabel = true,
    this.labelAlwaysTop = false,
    this.suffixText,
    this.icon = const SizedBox(),
    this.backGroudColor = AppColors.basicwhiteColor,
    this.borderColor = AppColors.seaColor,
    this.onTap,
    this.maxLength,
    this.scrollPadding,
    this.textIsCenter,
    this.paddingNull,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8.r),
        color: gradient != null ? null : backGroudColor,
        boxShadow: boxShadow == true
            ? [
                BoxShadow(
                  color: AppColors.basicblackColor.withOpacity(0.1),
                  blurRadius: 10.r,
                )
              ]
            : null,
        gradient: gradient,
      ),
      child: FormForButton(
        borderRadius: BorderRadius.circular(8.r),
        onPressed: onTap,
        child: Padding(
          padding: paddingNull == true
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: labelText == null && !isSmall ? 16.h : 8.h,
                ),
          child: Center(
            child: Row(
              children: [
                needIconNeerTheText == true
                    ? IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 0,
                            maxWidth: 349.w - 16.w,
                          ),
                          child: customTextField(
                            onEditingComplete: (){
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.focusedChild?.unfocus();
                              }
                            },
                            maxLength: maxLength,
                            controller: controller,
                            labelText: labelText,
                            onChanged: onChanged,
                            hintText: hintText,
                            labelColor: labelColor,
                            textColor: textColor,
                            enabled: enabled,
                            hintColor: hintColor,
                            fontSizeHint: fontSizeHint,
                            showLabel: showLabel,
                            multiLines: multiLines,
                            labelAlwaysTop: labelAlwaysTop,
                            textUnderLine: textUnderLine,
                            keyboardType: keyboardType,
                            suffixText: suffixText,
                            textIsBold: textIsBold,
                            listMaskTextInputFormatter: listMaskTextInputFormatter,
                            isLast: isLast,
                            validator: validator,
                            autovalidateMode: autovalidateMode,
                            focusNode: focusNode,
                            maxLines: maxLines,
                            onTap: onTap,
                            textIsBig: textIsBig,
                            scrollPadding: scrollPadding,
                            textIsCenter: textIsCenter,
                          ),
                        ),
                      )
                    : Expanded(
                        child: customTextField(
                          onEditingComplete: (){
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.focusedChild?.unfocus();
                            }
                          },
                          textIsBig: textIsBig,
                          maxLength: maxLength,
                          controller: controller,
                          labelText: labelText,
                          onChanged: onChanged,
                          hintText: hintText,
                          labelColor: labelColor,
                          textColor: textColor,
                          enabled: enabled,
                          hintColor: hintColor,
                          fontSizeHint: fontSizeHint,
                          showLabel: showLabel,
                          multiLines: multiLines,
                          labelAlwaysTop: labelAlwaysTop,
                          textUnderLine: textUnderLine,
                          keyboardType: keyboardType,
                          suffixText: suffixText,
                          textIsBold: textIsBold,
                          listMaskTextInputFormatter: listMaskTextInputFormatter,
                          isLast: isLast,
                          validator: validator,
                          autovalidateMode: autovalidateMode,
                          focusNode: focusNode,
                          maxLines: maxLines,
                          onTap: onTap,
                          scrollPadding: scrollPadding,
                          textIsCenter: textIsCenter,
                        ),
                      ),
                icon,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextField(
      {required TextEditingController controller,
      required String? labelText,
      required Function()? onEditingComplete,
      required Function(String)? onChanged,
      required String hintText,
      required bool? textIsBig,
      required Color labelColor,
      required Color textColor,
      required bool? enabled,
      required Color? hintColor,
      required double? fontSizeHint,
      required bool showLabel,
      required bool multiLines,
      required bool labelAlwaysTop,
      required bool? textUnderLine,
      required TextInputType? keyboardType,
      required String? suffixText,
      required bool? textIsBold,
      required List<TextInputFormatter>? listMaskTextInputFormatter,
      required bool? isLast,
      required FormFieldValidator<String>? validator,
      required AutovalidateMode? autovalidateMode,
      required FocusNode? focusNode,
      required int? maxLines,
      required int? maxLength,
      required Function()? onTap,
      required EdgeInsets? scrollPadding,
      required bool? textIsCenter}) {
    return TextFormField(
      scrollPadding: scrollPadding ?? EdgeInsets.zero,
      onTap: onTap,
      textAlign: textIsCenter == true ? TextAlign.center : TextAlign.start,
      onEditingComplete: onEditingComplete,
      minLines: 1,
      maxLength: maxLength,
      maxLines: maxLines,
      focusNode: focusNode,
      controller: controller,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      cursorColor: AppColors.darkGreenColor,
      textInputAction: TextInputAction.done,
      keyboardType: keyboardType != null
          ? keyboardType
          : multiLines
              ? TextInputType.multiline
              : TextInputType.text,
      enabled: enabled,
      style: TextStyle(
        color: textColor,
        fontSize: textIsBig == true ? 18.sp : 16.sp,
        fontFamily: 'Inter',
        height: 1.3,
        decoration: textUnderLine == true ? TextDecoration.underline : null,
        fontWeight: textIsBold == true ? FontWeight.w600 : FontWeight.w400,
      ),
      inputFormatters: listMaskTextInputFormatter,
      decoration: InputDecoration(
        counterText: "",
        errorStyle: const TextStyle(
          color: AppColors.redColor,
        ),
        errorMaxLines: 2,
        suffixText: suffixText,
        isDense: true,
        floatingLabelBehavior: labelAlwaysTop ? FloatingLabelBehavior.always : null,
        hintMaxLines: 2,
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor ?? AppColors.grey50Color,
          fontSize: fontSizeHint ?? 16.sp,
          height: 1,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        suffixStyle: TextStyle(
          color: AppColors.darkGreenColor,
          fontSize: 16.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
          color: labelColor,
          decoration: TextDecoration.none,
          fontSize: 16.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.vivaMagentaColor, width: 4),
        ),
        border: InputBorder.none,
      ),
    );
  }
}
