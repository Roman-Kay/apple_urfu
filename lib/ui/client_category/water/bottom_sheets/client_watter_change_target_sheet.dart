import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/models/client/water_diary/water_update_model.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/client/water_diary/water_diary_service.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';


class ClientWatterChangeTargetSheet extends StatefulWidget {
  const ClientWatterChangeTargetSheet({super.key, this.dayTarget});
  final int? dayTarget;

  @override
  State<ClientWatterChangeTargetSheet> createState() => _ClientWatterChangeTargetSheetState();
}

class _ClientWatterChangeTargetSheetState extends State<ClientWatterChangeTargetSheet> {
  TextEditingController targetController = TextEditingController(text: "0");
  int dayTarget = 2000;

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  void dispose() {
    targetController.dispose();
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
              SizedBox(height: 13.h),
              Container(
                width: double.infinity,
                height: 64.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.basicwhiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey50Color.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Текущий показатель:',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          fontFamily: 'Inter',
                          color: AppColors.darkGreenColor,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dayTarget.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'мл',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 64.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.basicwhiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey50Color.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: TextField(
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.numberWithOptions(),
                        textInputAction: TextInputAction.done,
                        onEditingComplete: (){
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.focusedChild?.unfocus();
                          }
                        },
                        controller: targetController,
                        maxLength: 5,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          fontFamily: 'Inter',
                          color: AppColors.darkGreenColor,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          isDense: true,
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: Text(
                              'Новая цель дня:',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                                color: AppColors.darkGreenColor,
                              ),
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(maxHeight: 100),
                          suffixIconConstraints: BoxConstraints(maxHeight: 100),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 16.w, left: 6.w),
                            child: Text(
                              'мл',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                color: AppColors.darkGreenColor,
                              ),
                            ),
                          ),
                          hintStyle: TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.darkGreenColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(
                    child: WidgetButton(
                      onTap: () => context.router.maybePop(),
                      color: AppColors.lightGreenColor,
                      child: Text(
                        'ОТМЕНА',
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
                      text: 'УСТАНОВИТЬ',
                      boxShadow: true,
                      onTap: () async{
                        if(targetController.text.isNotEmpty){
                          int target = int.parse(targetController.text);
                          if(target == dayTarget){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Введите новое значение',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            );
                          }
                          else if(target == 0){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Введите корректное значение',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            );
                          }
                          else{
                            FocusScope.of(context).unfocus();
                            context.loaderOverlay.show();
                            final service = WaterDiaryService();

                            final response = await service.addWaterDiary(ClientWaterUpdateRequest(
                              val: 0,
                              dayNorm: target
                            ));

                            if(response.result){
                              GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.changeWaterGoalClient);

                              context.loaderOverlay.hide();
                              context.router.maybePop(true);
                            }
                            else{
                              context.loaderOverlay.hide();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(
                                    'Произошла ошибка. Попробуйте повторить позже',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text(
                                'Введите значение',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      color: AppColors.darkGreenColor,
                      textColor: AppColors.basicwhiteColor,
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

  check(){
    if(widget.dayTarget != null){
      setState(() {
        dayTarget = widget.dayTarget!;
      });
    }
  }
}
