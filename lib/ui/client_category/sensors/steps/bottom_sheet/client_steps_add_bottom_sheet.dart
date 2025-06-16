import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientStepsAddBottomSheet extends StatefulWidget {
  const ClientStepsAddBottomSheet({super.key});

  @override
  State<ClientStepsAddBottomSheet> createState() => _ClientStepsAddBottomSheetState();
}

class _ClientStepsAddBottomSheetState extends State<ClientStepsAddBottomSheet> {
  bool validation = false;
  TextEditingController controllerSteps = TextEditingController();
  TextEditingController controllerDuration = TextEditingController();
  TextEditingController controllerTime = TextEditingController();

  @override
  void dispose() {
    controllerTime.dispose();
    controllerDuration.dispose();
    controllerSteps.dispose();
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
                  CustomTextFieldLabel(
                    controller: controllerSteps,
                    labelText: 'Количество шагов',
                    keyboardType: TextInputType.number,
                    labelColor: AppColors.vivaMagentaColor,
                    backGroudColor: Color(0xFFF2F4F8),
                    borderColor: validation && controllerSteps.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.grey20Color,
                    listMaskTextInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                    onChanged: (val) {
                      if (validation) {
                        setState(() {
                          validation = false;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFieldLabel(
                    controller: controllerDuration,
                    labelText: 'Расстояние',
                    keyboardType: TextInputType.number,
                    labelColor: AppColors.vivaMagentaColor,
                    backGroudColor: Color(0xFFF2F4F8),
                    borderColor: validation && controllerDuration.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.grey20Color,
                    listMaskTextInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                    onChanged: (val) {
                      if (validation) {
                        setState(() {
                          validation = false;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFieldLabel(
                    controller: controllerTime,
                    labelText: 'Время, мин',
                    keyboardType: TextInputType.number,
                    labelColor: AppColors.vivaMagentaColor,
                    backGroudColor: Color(0xFFF2F4F8),
                    borderColor: validation && controllerTime.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.grey20Color,
                    listMaskTextInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                    onChanged: (val) {
                      if (validation) {
                        setState(() {
                          validation = false;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 30.h),

                  WidgetButton(
                    onTap: () async{
                      FocusScope.of(context).unfocus();

                      if (controllerTime.text.isNotEmpty && controllerSteps.text.isNotEmpty && controllerDuration.text.isNotEmpty) {
                        final service = SensorsService();

                        context.loaderOverlay.show();

                        final response = await service.createSensorsMeasurement(CreateClientSensorsRequest(
                          healthSensorId: 1,
                          healthSensorVal: int.parse(controllerSteps.text),
                          health: controllerDuration.text,
                          comment: controllerTime.text,
                          dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                        ));

                        if(response.result){
                          GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.addStepClient);

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
                      'сохранить'.toUpperCase(),
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
