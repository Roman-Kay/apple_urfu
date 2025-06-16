import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';


class ClientFoodDiaryMlBottomSheet extends StatefulWidget {
  const ClientFoodDiaryMlBottomSheet({super.key, this.oldText});
  final String? oldText;

  @override
  State<ClientFoodDiaryMlBottomSheet> createState() => _ClientFoodDiaryMlBottomSheetState();
}

class _ClientFoodDiaryMlBottomSheetState extends State<ClientFoodDiaryMlBottomSheet> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if(widget.oldText != null) controller = TextEditingController(text: widget.oldText);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.limeColor,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              CustomTextFieldLabel(
                controller: controller,
                keyboardType: TextInputType.number,
                maxLines: 1,
                maxLength: 8,
                borderColor: AppColors.greenColor,
                hintText: '0',
                hintColor: AppColors.darkGreenColor,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: WidgetButton(
                      onTap: () {
                        if(widget.oldText != null){
                          context.router.maybePop(true);
                        }
                        else{
                          context.router.maybePop();
                        }
                      },
                      color: AppColors.lightGreenColor,
                      child: Text(
                        widget.oldText != null ? "удалить".toUpperCase() : 'отмена'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: AppColors.darkGreenColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: WidgetButton(
                      onTap: () {
                        if(controller.text.isNotEmpty){
                          context.router.maybePop(controller.text);
                        }
                        else{
                          context.router.maybePop();
                        }
                      },
                      boxShadow: true,
                      color: AppColors.darkGreenColor,
                      child: Text(
                        widget.oldText == null ? 'добавить'.toUpperCase() : "обновить".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: AppColors.basicwhiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }
}
