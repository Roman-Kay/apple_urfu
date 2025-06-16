import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';


class ClientSensorsSleepChangeSheet extends StatefulWidget {
  const ClientSensorsSleepChangeSheet({super.key, required this.date, required this.clientSensorId});

  final DateTime date;
  final int? clientSensorId;

  @override
  State<ClientSensorsSleepChangeSheet> createState() => _ClientSensorsSleepChangeSheetState();
}

class _ClientSensorsSleepChangeSheetState extends State<ClientSensorsSleepChangeSheet> {
  bool validation = false;

  TextEditingController controllerStartTime = TextEditingController();
  TextEditingController controllerEndTime = TextEditingController();

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String chooseWellBeing = 'Нормальное';

  @override
  void dispose() {
    controllerStartTime.dispose();
    controllerEndTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.basicwhiteColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.limeColor,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 160.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.basicblackColor.withOpacity(0.1),
                              blurRadius: 8.r,
                            ),
                          ],
                        ),
                        child: FormForButton(
                          borderRadius: BorderRadius.circular(8.r),
                          onPressed: () => DatePickerBdaya.showDateTimePicker(
                            context,
                            showTitleActions: true,
                            onConfirm: (date) {
                              setState(() {
                                selectedStartDate = date;

                                controllerStartTime.text = DateFormat("dd.MM.yy HH:mm").format(selectedStartDate!);

                                if(validation){
                                  validation = false;
                                }
                              });
                            },
                            currentTime: selectedStartDate ?? widget.date,
                            locale: LocaleType.ru,
                          ),
                          child: CustomTextFieldLabel(
                            enabled: false,
                            backGroudColor: AppColors.basicwhiteColor,
                            controller: controllerStartTime,
                            labelColor: AppColors.vivaMagentaColor,
                            labelText: 'Начало',
                            borderColor: validation && controllerStartTime.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
                          ),
                        ),
                      ),
                      Container(
                        width: 160.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.basicblackColor.withOpacity(0.1),
                              blurRadius: 8.r,
                            ),
                          ],
                        ),
                        child: FormForButton(
                          borderRadius: BorderRadius.circular(8.r),
                          onPressed: () => DatePickerBdaya.showDateTimePicker(
                            context,
                            showTitleActions: true,
                            onConfirm: (date) {
                              setState(() {
                                selectedEndDate = date;
                                controllerEndTime.text = DateFormat("dd.MM.yy HH:mm").format(date);

                                if(validation){
                                  validation = false;
                                }
                              },
                              );
                            },
                            currentTime: selectedEndDate ?? widget.date,
                            locale: LocaleType.ru,
                          ),
                          child: CustomTextFieldLabel(
                            enabled: false,
                            backGroudColor: AppColors.basicwhiteColor,
                            controller: controllerEndTime,
                            labelColor: AppColors.vivaMagentaColor,
                            labelText: 'Конец',
                            borderColor: validation && controllerEndTime.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Оцените своё самочувствие:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        fontFamily: 'Inter',
                        color: AppColors.darkGreenColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 44.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      gradient: AppColors.gradientSecond,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: AnimatedAlign(
                            duration: Duration(milliseconds: 200),
                            alignment: chooseWellBeing == "Нормальное"
                                ? Alignment.center
                                : chooseWellBeing == "Плохое"
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              height: 36.h,
                              width: (375 - 24 - 4).w / 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9.r),
                                color: AppColors.basicwhiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: AppColors.basicblackColor.withOpacity(0.1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                          child: Row(
                            children: [
                              SizedBox(
                                width: (375 - 28 - 8).w / 3,
                                height: 36.h,
                                child: FormForButton(
                                  borderRadius: BorderRadius.circular(8.r),
                                  onPressed: () => setState(() {
                                    chooseWellBeing = "Плохое";
                                  }),
                                  child: Center(
                                    child: Text(
                                      'Плохое',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        height: 1,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (375 - 28 - 8).w / 3,
                                height: 36.h,
                                child: FormForButton(
                                  borderRadius: BorderRadius.circular(8.r),
                                  onPressed: () => setState(() {
                                    chooseWellBeing = 'Нормальное';
                                  }),
                                  child: Center(
                                    child: Text(
                                      'Нормальное',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        height: 1,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (375 - 28 - 8).w / 3,
                                height: 36.h,
                                child: FormForButton(
                                  borderRadius: BorderRadius.circular(8.r),
                                  onPressed: () => setState(() {
                                    chooseWellBeing = 'Отличное';
                                  }),
                                  child: Center(
                                    child: Text(
                                      'Отличное',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        height: 1,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35.h),
                  WidgetButton(
                    onTap: () async{
                      FocusScope.of(context).unfocus();

                      if (controllerEndTime.text.isNotEmpty &&
                          controllerStartTime.text.isNotEmpty && selectedStartDate != null && selectedEndDate != null) {

                        final service = SensorsService();
                        Duration difference = selectedEndDate!.difference(selectedStartDate!);

                        if(difference.inMinutes > 1200 || difference.isNegative){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text(
                                'Введите правильное значение',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          );
                          return;
                        }
                        context.loaderOverlay.show();

                        final response = await service.createSensorsMeasurement(CreateClientSensorsRequest(
                          healthSensorId: 5,
                          healthSensorVal: difference.inMinutes,
                          health: chooseWellBeing,
                          //clientSensorId: widget.clientSensorId,
                          dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedEndDate!),
                        ));

                        if(response.result){
                          GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.addSleepClient);

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
                      else {
                        setState(() {
                          validation = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              'Введите значения',
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
                    boxShadow: true,
                    color: AppColors.darkGreenColor,
                    child: Text(
                      'добавить'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                        color: AppColors.basicwhiteColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
