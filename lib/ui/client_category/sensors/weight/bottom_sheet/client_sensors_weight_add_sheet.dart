import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/profile/client_profile_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/auth/profile_data.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:get_it/get_it.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientSensorsWeightAddScreen extends StatefulWidget {
  const ClientSensorsWeightAddScreen({super.key, required this.date, this.view});
  final DateTime date;
  final ClientSensorsView? view;

  @override
  State<ClientSensorsWeightAddScreen> createState() => _ClientSensorsWeightAddScreenState();
}

class _ClientSensorsWeightAddScreenState extends State<ClientSensorsWeightAddScreen> {
  String date = '';
  String time = '';
  bool validation = false;
  TextEditingController controllerTime = TextEditingController();
  TextEditingController controllerKg = TextEditingController();
  DateTime? selectedDate;
  int? sensorId;

  final RegExp doubleRegExp = RegExp(r'[0-9]+[.,]?[0-9]*');

  @override
  void initState() {
    controllerTime.text = DateFormat("dd.MM.yy HH:mm").format(DateTime(widget.date.year, widget.date.month, widget.date.day, DateTime.now().hour, DateTime.now().minute));
    check();
    super.initState();
  }

  @override
  void dispose() {
    controllerTime.dispose();
    controllerKg.dispose();
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
                  SizedBox(height: 20.h),
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
                            maxTime: DateTime.now().add(Duration(days: 360)),
                            minTime: DateTime.now().subtract(Duration(days: 360)),
                            onConfirm: (dateVal) {
                              setState(() {
                                selectedDate = dateVal;
                                date = DateFormat("dd.MM.yy").format(dateVal);
                                time = DateFormat("HH:mm").format(dateVal);
                                controllerTime.text = '$date $time';
                                if (validation) {
                                  validation = false;
                                }
                              });
                            },
                            currentTime: selectedDate ?? DateTime(widget.date.year, widget.date.month, widget.date.day, DateTime.now().hour, DateTime.now().minute),
                            locale: LocaleType.ru,
                          ),
                          child: CustomTextFieldLabel(
                            enabled: false,
                            backGroudColor: AppColors.basicwhiteColor,
                            controller: controllerTime,
                            labelColor: AppColors.vivaMagentaColor,
                            labelText: 'Дата',
                            borderColor: validation && controllerTime.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
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
                        child: CustomTextFieldLabel(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          backGroudColor: AppColors.basicwhiteColor,
                          controller: controllerKg,
                          labelColor: AppColors.vivaMagentaColor,
                          labelText: 'Значение, кг',
                          maxLength: 4,
                          onChanged: (v){
                            setState(() {
                              if (validation) {
                                validation = false;
                              }
                            });
                          },
                          listMaskTextInputFormatter: [FilteringTextInputFormatter.allow(doubleRegExp)],
                          borderColor: validation && controllerKg.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  WidgetButton(
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      if (controllerKg.text.isNotEmpty && controllerTime.text.isNotEmpty) {
                        double value = double.parse(controllerKg.text.replaceAll(',', '.'));
                        if (value < 39 || value > 500) {
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
                        else if (DateTime.now().difference(selectedDate ?? widget.date).isNegative) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text(
                                'Нельзя ввести значение за будущую дату',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          );
                        }
                        else {

                          context.loaderOverlay.show();

                          HealthServiceController healthController = HealthServiceController();
                          Health health = Health();

                          final requested = Platform.isIOS
                              ? await health.requestAuthorization([HealthDataType.WEIGHT], permissions: [HealthDataAccess.READ_WRITE])
                              : await health.hasPermissions([HealthDataType.WEIGHT], permissions: [HealthDataAccess.READ_WRITE]);

                          if (requested == true) {
                            await healthController.addWeight(value, selectedDate ?? widget.date, selectedDate ?? widget.date);
                          }

                          final serviceResponse = await SensorsService().createSensorsMeasurement(
                            CreateClientSensorsRequest(
                              healthSensorId: 9,
                              healthSensorVal: value,
                              clientSensorId: sensorId,
                              dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate ?? widget.date),
                            ),
                          );

                          final profileService = ProfileDataService();
                          final storage = SharedPreferenceData.getInstance();
                          final storageHeight = await storage.getItem(SharedPreferenceData.userHeightKey);


                          if (storageHeight != "") {
                            double newValue = value;

                            await profileService.updateClientProfile(newValue.toString(), storageHeight).then((value) {
                              if (value.result) {
                                context.read<ClientProfileCubit>().check();
                              }
                            });
                          }

                          if (serviceResponse.result) {
                            GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.addWeightClient);

                            context.loaderOverlay.hide();
                            context.router.maybePop(value);
                          }
                          else {
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
                      } else {
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

  check(){
    if(widget.view != null && widget.view?.healthSensorVal != null && widget.view?.clientSensorId != null && widget.view?.dateSensor != null){
      DateTime newDate = DateTime.parse(widget.view!.dateSensor!);
      DateTime today = DateTime.now();

      if(newDate.year == today.year && newDate.month == today.month && newDate.day == today.day){
        setState(() {
          sensorId = widget.view?.clientSensorId;
          controllerKg.text = widget.view!.healthSensorVal.toString();
          controllerTime.text = DateFormat("dd.MM.yy HH:mm").format(DateTime(newDate.year, newDate.month, newDate.day, newDate.hour, newDate.minute));
        });
      }

    }
  }
}
