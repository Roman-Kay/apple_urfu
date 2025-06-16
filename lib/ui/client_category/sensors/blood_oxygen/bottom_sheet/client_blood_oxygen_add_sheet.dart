import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/health/blood_oxygen/blood_oxygen_bloc.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:get_it/get_it.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientBloodOxygenAddSheet extends StatefulWidget {
  const ClientBloodOxygenAddSheet({super.key, required this.date});
  final DateTime date;

  @override
  State<ClientBloodOxygenAddSheet> createState() => _ClientBloodOxygenAddSheetState();
}

class _ClientBloodOxygenAddSheetState extends State<ClientBloodOxygenAddSheet> {
  String date = '';
  String time = '';
  bool validation = false;
  DateTime? selectedDate;
  DateTime? lastMeasure;
  int? lastOxygen;
  String chooseWellBeing = 'Нормальное';

  TextEditingController controllerTime = TextEditingController();
  TextEditingController controllerPercent = TextEditingController();

  @override
  void initState() {
    controllerTime.text = DateFormat("dd.MM.yy HH:mm")
        .format(DateTime(widget.date.year, widget.date.month, widget.date.day, DateTime.now().hour, DateTime.now().minute));
    selectedDate = DateTime(widget.date.year, widget.date.month, widget.date.day, DateTime.now().hour, DateTime.now().minute);
    super.initState();
  }

  @override
  void dispose() {
    controllerTime.dispose();
    controllerPercent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BloodOxygenBloc, BloodOxygenState>(builder: (context, state) {
      if (state is BloodOxygenLoadedState) {
        getLastMeasure(state.currentVal?.dateSensor, state.currentVal?.healthSensorVal);
      }
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
                    if (lastMeasure != null && lastOxygen != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 30.h, top: 4.h),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.grey10Color,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Предыдущее измерение:",
                                  style: TextStyle(
                                      fontFamily: "Inter", color: AppColors.darkGreenColor, fontSize: 16.sp, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      lastMeasure != null ? lastMeasure!.day.toString() : "",
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          color: AppColors.darkGreenColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      getMonthWithDayWeek(),
                                      style: TextStyle(
                                          fontFamily: "Inter",
                                          color: AppColors.darkGreenColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  lastOxygen.toString(),
                                  style: TextStyle(
                                      fontFamily: "Inter", color: AppColors.darkGreenColor, fontSize: 16.sp, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  "%",
                                  style: TextStyle(
                                      fontFamily: "Inter", color: AppColors.darkGreenColor, fontSize: 14.sp, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                              currentTime: selectedDate ??
                                  DateTime(
                                      widget.date.year, widget.date.month, widget.date.day, DateTime.now().hour, DateTime.now().minute),
                              locale: LocaleType.ru,
                            ),
                            child: CustomTextFieldLabel(
                              enabled: false,
                              backGroudColor: AppColors.basicwhiteColor,
                              controller: controllerTime,
                              labelColor: AppColors.vivaMagentaColor,
                              labelText: 'Дата и время',
                              borderColor:
                                  validation && controllerTime.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
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
                            keyboardType: TextInputType.number,
                            backGroudColor: AppColors.basicwhiteColor,
                            onChanged: (value) {
                              if (validation) {
                                setState(() {
                                  validation = false;
                                });
                              }
                            },
                            controller: controllerPercent,
                            listMaskTextInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))],
                            labelColor: AppColors.vivaMagentaColor,
                            labelText: 'Значение, %',
                            maxLength: 4,
                            borderColor:
                                validation && controllerPercent.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Оцените своё самочувствие:',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.darkGreenColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.h),
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
                              duration: Duration(milliseconds: 100),
                              alignment: chooseWellBeing == 'Плохое'
                                  ? Alignment.centerLeft
                                  : chooseWellBeing == 'Нормальное'
                                      ? Alignment.center
                                      : Alignment.centerRight,
                              child: Container(
                                height: 36.h,
                                width: (375.w - 28.w - 8.w) / 3,
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
                                  width: (375.w - 28.w - 8.w) / 3,
                                  height: 36.h,
                                  child: FormForButton(
                                    borderRadius: BorderRadius.circular(8.r),
                                    onPressed: () => setState(() {
                                      chooseWellBeing == 'Плохое' ? chooseWellBeing = '' : chooseWellBeing = 'Плохое';
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
                                  width: (375.w - 28.w - 8.w) / 3,
                                  height: 36.h,
                                  child: FormForButton(
                                    borderRadius: BorderRadius.circular(8.r),
                                    onPressed: () => setState(() {
                                      chooseWellBeing == 'Нормальное' ? chooseWellBeing = '' : chooseWellBeing = 'Нормальное';
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
                                  width: (375.w - 28.w - 8.w) / 3,
                                  height: 36.h,
                                  child: FormForButton(
                                    borderRadius: BorderRadius.circular(8.r),
                                    onPressed: () => setState(() {
                                      chooseWellBeing == 'Отличное' ? chooseWellBeing = '' : chooseWellBeing = 'Отличное';
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
                    SizedBox(height: 30.h),
                    WidgetButton(
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        if (controllerPercent.text.isNotEmpty && controllerTime.text.isNotEmpty) {
                          double value = double.parse(controllerPercent.text);

                          if (DateTime.now().difference(selectedDate ?? widget.date).isNegative) {
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
                          } else if (value < 85 || value > 100) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Введите корректное значение показателя кислорода',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            );
                          } else if (lastMeasure != null && lastMeasure!.difference(selectedDate ?? widget.date).inMinutes == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'За данный период показатели внесены. Поменяйте дату и время измерения',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            );
                            return;
                          } else {
                            context.loaderOverlay.show();

                            HealthServiceController healthController = HealthServiceController();
                            Health health = Health();

                            final requested = Platform.isIOS
                                ? await health
                                    .requestAuthorization([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE])
                                : await health.hasPermissions([HealthDataType.BLOOD_OXYGEN], permissions: [HealthDataAccess.READ_WRITE]);

                            if (requested == true) {
                              await healthController.addBloodOxygen(value / 100, selectedDate ?? widget.date, selectedDate ?? widget.date);
                            }

                            final service = await SensorsService().createSensorsMeasurement(CreateClientSensorsRequest(
                              healthSensorId: 4,
                              health: chooseWellBeing,
                              healthSensorVal: value.toInt(),
                              dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate ?? widget.date),
                            ));
                            if (service.result) {
                              GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.addBloodOxygenClient);

                              context.loaderOverlay.hide();
                              context.router.maybePop(true);
                            } else {
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
    });
  }

  String getMonthWithDayWeek() {
    if (lastMeasure != null) {
      String week = DateFormat('EE', 'ru_RU').format(lastMeasure!);
      String month = CalendarStorage.nameMonthByNumber[lastMeasure!.month].toString();
      String newWeek = week.characters.first.toLowerCase();
      String myWeek = week.substring(1);

      return '$month, $newWeek$myWeek';
    }
    return "";
  }

  getLastMeasure(String? date, num? measure) {
    if (date != null) {
      lastMeasure = DateTime.parse(date);
    }
    if (measure != null) {
      lastOxygen = measure.toInt();
    }
  }
}
