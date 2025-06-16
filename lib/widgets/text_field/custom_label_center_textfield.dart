import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';

// ignore: must_be_immutable
class CustomLabelCenterTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  Color labelColor;
  Function(String)? onChanged;
  List<TextInputFormatter>? listMaskTextInputFormatter;
  Color? borderColor;
  int? maxLength;

  CustomLabelCenterTextField({
    super.key,
    required this.controller,
    required this.label,
    this.listMaskTextInputFormatter,
    this.onChanged,
    this.labelColor = AppColors.darkGreenColor,
    this.borderColor,
    this.maxLength
  });

  @override
  State<CustomLabelCenterTextField> createState() => _CustomLabelCenterTextFieldState();
}

class _CustomLabelCenterTextFieldState extends State<CustomLabelCenterTextField> {
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 157.w,
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor ?? AppColors.seaColor),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.basicwhiteColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Center(
          child: TextFormField(
            minLines: 1,
            maxLength: widget.maxLength,
            cursorColor: AppColors.darkGreenColor,
            onChanged: widget.onChanged,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            focusNode: focusNode,
            controller: widget.controller,
            textInputAction: TextInputAction.done,
            onEditingComplete: (){
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            inputFormatters: widget.listMaskTextInputFormatter,
            style: TextStyle(
              color: AppColors.darkGreenColor,
              fontSize: 20.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              counterText: "",
              floatingLabelAlignment: FloatingLabelAlignment.center,
              label: !focusNode.hasFocus && widget.controller.text.isEmpty
                  ? Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Center(
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            style: TextStyle(
                              color: widget.labelColor,
                              fontSize: 16.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
              labelText: focusNode.hasFocus || widget.controller.text.isNotEmpty
                  ? widget.label
                  : null,
              labelStyle: TextStyle(
                color: widget.labelColor,
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none
            ),
          ),
        ),
      ),
    );
  }
}
