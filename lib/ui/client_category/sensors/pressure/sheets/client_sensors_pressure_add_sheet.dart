import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/health/pressure/pressure_bloc.dart';
import 'package:garnetbook/bloc/client/health/pulse/pulse_bloc.dart';
import 'package:garnetbook/bloc/client/my_expert/my_expert_cubit.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_model.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/notification/push_service.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:get_it/get_it.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientSensorsPressureAddSheet extends StatefulWidget {
  const ClientSensorsPressureAddSheet({required this.date, Key? key}) : super(key: key);
  final DateTime date;

  @override
  State<ClientSensorsPressureAddSheet> createState() => _ClientSensorsPressureAddSheetState();
}

class _ClientSensorsPressureAddSheetState extends State<ClientSensorsPressureAddSheet> {
  String date = '';
  String time = '';
  bool validation = false;
  DateTime? selectedDate;
  DateTime? lastMeasure;
  int? diastolicPressure;
  int? systolicPressure;
  int? lastPulse;

  final List<String> conditions = [
    'Сидя',
    'Лежа',
    'Стоя',
    'На левой руке',
    'На правой руке',
    'До еды',
    'После еды',
    'В спокойствии',
    'По графику',
    'После физических упражнений',
    'По необходимости (почувствовали плохо)',
  ];
  List<String> chossenCondition = [];

  String self = "Нормальное";

  TextEditingController controllerTime = TextEditingController();
  TextEditingController controllerDiastolic = TextEditingController();
  TextEditingController controllerSystolic = TextEditingController();
  TextEditingController controllerPulse = TextEditingController();
  TextEditingController controllerComment = TextEditingController();
  TextEditingController controllerConditions = TextEditingController();

  @override
  void initState() {
    controllerTime.text = DateFormat("dd.MM.yy HH:mm").format(DateTime(widget.date.year, widget.date.month, widget.date.day, DateTime.now().hour, DateTime.now().minute));
    selectedDate = DateTime(widget.date.year, widget.date.month, widget.date.day, DateTime.now().hour, DateTime.now().minute);
    super.initState();
  }

  @override
  void dispose() {
    controllerTime.dispose();
    controllerDiastolic.dispose();
    controllerSystolic.dispose();
    controllerPulse.dispose();
    controllerComment.dispose();
    controllerConditions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyExpertCubit, MyExpertState>(
      builder: (context, state) {
        return BlocBuilder<PressureBloc, PressureState>(builder: (context, pressureState) {
          if(pressureState is PressureLoadedState){
            getLastMeasure(pressureState.currentVal?.dateSensor, pressureState.currentVal?.healthSensorVal);
          }

            return BlocBuilder<PulseBloc, PulseState>(builder: (context, pulseState) {
              if(pulseState is PulseLoadedState){
                getPulse(pulseState.list);
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
                        child: SizedBox(
                          height: 600.h,
                          child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            children: [
                              SizedBox(height: 15.h),
                              Text(
                                'Во время измерения постарайтесь \nне говорить и не двигаться',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.w,
                                  fontFamily: 'Inter',
                                  color: Color(0xFF00817D).withOpacity(0.8),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FormForButton(
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
                                      boxShadow: true,
                                      backGroudColor: AppColors.basicwhiteColor,
                                      controller: controllerTime,
                                      labelColor: AppColors.vivaMagentaColor,
                                      labelText: 'Дата и время',
                                      icon: SvgPicture.asset(
                                        'assets/images/clock.svg',
                                        color: AppColors.vivaMagentaColor,
                                        height: 24.h,
                                      ),
                                      borderColor: validation && controllerTime.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Container(
                                        width: 160.w,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.basicblackColor.withOpacity(0.1),
                                              blurRadius: 10.r,
                                            )
                                          ],
                                          color: AppColors.basicwhiteColor,
                                          border: Border.all(
                                            width: 1,
                                            color: validation && controllerSystolic.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
                                          ),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 8.h),
                                            Padding(
                                              padding: EdgeInsets.only(left: 18.w),
                                              child: Text(
                                                'Систолическое\nдавление',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Inter',
                                                  color: AppColors.vivaMagentaColor,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                                              child: CustomTextFieldLabel(
                                                labelAlwaysTop: true,
                                                textIsBig: true,
                                                textIsBold: true,
                                                paddingNull: true,
                                                hintText: '0',
                                                fontSizeHint: 20.sp,
                                                maxLength: 4,
                                                keyboardType: TextInputType.number,
                                                backGroudColor: AppColors.basicwhiteColor,
                                                onChanged: (value) {
                                                  if (validation) {
                                                    setState(() {
                                                      validation = false;
                                                    });
                                                  }
                                                },
                                                controller: controllerSystolic,
                                                labelColor: AppColors.vivaMagentaColor,
                                                borderColor: Color(0xF00000000),
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        width: 160.w,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.basicblackColor.withOpacity(0.1),
                                              blurRadius: 10.r,
                                            )
                                          ],
                                          color: AppColors.basicwhiteColor,
                                          border: Border.all(
                                            width: 1,
                                            color: validation && controllerDiastolic.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
                                          ),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 8.h),
                                            Padding(
                                              padding: EdgeInsets.only(left: 18.w),
                                              child: Text(
                                                'Диастолическое\nдавление',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Inter',
                                                  color: AppColors.vivaMagentaColor,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                                              child: CustomTextFieldLabel(
                                                labelAlwaysTop: true,
                                                textIsBig: true,
                                                textIsBold: true,
                                                paddingNull: true,
                                                hintText: '0',
                                                fontSizeHint: 20.sp,
                                                maxLength: 4,
                                                keyboardType: TextInputType.number,
                                                backGroudColor: AppColors.basicwhiteColor,
                                                onChanged: (value) {
                                                  if (validation) {
                                                    setState(() {
                                                      validation = false;
                                                    });
                                                  }
                                                },
                                                controller: controllerDiastolic,
                                                labelColor: AppColors.vivaMagentaColor,
                                                borderColor: Color(0xF00000000),
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    width: 160.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.basicwhiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.basicblackColor.withOpacity(0.1),
                                          blurRadius: 10.r,
                                        )
                                      ],
                                      border: Border.all(
                                        width: 1,
                                        color: validation && controllerDiastolic.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8.h),
                                        Padding(
                                          padding: EdgeInsets.only(left: 18.w),
                                          child: Text(
                                            'Пульс\n ',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Inter',
                                              color: AppColors.vivaMagentaColor,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                                          child: CustomTextFieldLabel(
                                            labelAlwaysTop: true,
                                            textIsBig: true,
                                            textIsBold: true,
                                            paddingNull: true,
                                            hintText: '0',
                                            maxLength: 4,
                                            fontSizeHint: 20.sp,
                                            keyboardType: TextInputType.number,
                                            backGroudColor: AppColors.basicwhiteColor,
                                            onChanged: (value) {
                                              if (validation) {
                                                setState(() {
                                                  validation = false;
                                                });
                                              }
                                            },
                                            controller: controllerPulse,
                                            labelColor: AppColors.vivaMagentaColor,
                                            borderColor: Color(0xF00000000),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                ],
                              ),

                              if(lastMeasure != null && systolicPressure != null && diastolicPressure != null)
                                Container(
                                  margin: EdgeInsets.only(bottom: 4.h, top: 24.h),
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.grey10Color,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Предыдущее измерение:",
                                        style: TextStyle(
                                            fontFamily: "Inter",
                                            color: AppColors.darkGreenColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
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
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                getMonthWithDayWeek(),
                                                style: TextStyle(
                                                    fontFamily: "Inter",
                                                    color: AppColors.darkGreenColor,
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "$systolicPressure/$diastolicPressure",
                                                style: TextStyle(
                                                    fontFamily: "Inter",
                                                    color: AppColors.darkGreenColor,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),

                                              if(lastPulse != null)
                                                Text(
                                                  "  пульс - ",
                                                  style: TextStyle(
                                                      fontFamily: "Inter",
                                                      color: AppColors.darkGreenColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              Text(
                                                lastPulse != null ? lastPulse.toString() : "",
                                                style: TextStyle(
                                                    fontFamily: "Inter",
                                                    color: AppColors.darkGreenColor,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              SizedBox(height: 24.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Опишите условия измерения',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp,
                                    fontFamily: 'Inter',
                                    color: AppColors.darkGreenColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 10.h,
                                children: [
                                  for (var text in conditions)
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.r),
                                        border: Border.all(
                                          width: 1,
                                          color: AppColors.limeColor,
                                        ),
                                        color: chossenCondition.any((element) => text == element) ? AppColors.lightGreenColor : AppColors.basicwhiteColor,
                                      ),
                                      child: FormForButton(
                                        borderRadius: BorderRadius.circular(8.r),
                                        onPressed: () => setState(() {
                                          chossenCondition.any((element) => text == element) ? chossenCondition.remove(text) : chossenCondition.add(text);
                                        }),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(maxWidth: chossenCondition.any((element) => text == element) ? 290.w : 320.w),
                                                child: Text(
                                                  text,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp,
                                                    fontFamily: 'Inter',
                                                    color: AppColors.darkGreenColor,
                                                  ),
                                                ),
                                              ),
                                              if (chossenCondition.any((element) => text == element))
                                                Row(
                                                  children: [
                                                    SizedBox(width: 8.w),
                                                    SvgPicture.asset(
                                                      'assets/images/double_check_green.svg',
                                                      color: AppColors.darkGreenColor,
                                                    ),
                                                  ],
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Укажите свой вариант:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    fontFamily: 'Inter',
                                    color: AppColors.darkGreenColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              CustomTextFieldLabel(
                                controller: controllerConditions,
                                textColor: AppColors.vivaMagentaColor,
                                hintText: 'Введите текст',
                                hintColor: AppColors.vivaMagentaColor,
                                keyboardType: TextInputType.multiline,
                                multiLines: true,
                                maxLines: 3,
                                maxLength: 60,
                              ),
                              SizedBox(height: 24.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Самочувствие',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp,
                                    fontFamily: 'Inter',
                                    color: AppColors.darkGreenColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
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
                                        alignment: self == "Нормальное"
                                            ? Alignment.center
                                            : self == "Плохое"
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
                                                self = 'Плохое';
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
                                                self = 'Нормальное';
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
                                                self = 'Отличное';
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
                              SizedBox(height: 20.h),
                              CustomTextFieldLabel(
                                controller: controllerComment,
                                textColor: AppColors.vivaMagentaColor,
                                hintText: 'Как вы себя чувствуете?',
                                hintColor: AppColors.vivaMagentaColor,
                                keyboardType: TextInputType.multiline,
                                multiLines: true,
                                maxLines: 3,
                                maxLength: 80,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Как вы себя чувствуете? Опишите в нескольких словах. Это поможет специалисту проанализировать ваш отчет',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  height: 1.2,
                                  fontFamily: 'Inter',
                                  color: AppColors.darkGreenColor.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(height: 30.h),
                              WidgetButton(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();

                                  if (controllerDiastolic.text.isNotEmpty && controllerSystolic.text.isNotEmpty && controllerTime.text.isNotEmpty && controllerTime.text.isNotEmpty) {
                                    double diastolic = double.parse(controllerDiastolic.text);
                                    double systolic = double.parse(controllerSystolic.text);
                                    double pulse = double.parse(controllerPulse.text);

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
                                      return;
                                    }
                                    else if(lastMeasure != null && lastMeasure!.difference(selectedDate ?? widget.date).inMinutes == 0){
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
                                    }

                                    if (systolic == 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                            'Введите корректный показатель систолического давления',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (diastolic == 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                            'Введите корректный показатель диастолического давления',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (pulse == 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                            'Введите корректный показатель пульса',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.sp,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      context.loaderOverlay.show();

                                      HealthServiceController healthController = HealthServiceController();
                                      Health health = Health();
                                      final service = SensorsService();

                                      List<HealthDataType> healthDataType = [HealthDataType.BLOOD_PRESSURE_DIASTOLIC, HealthDataType.BLOOD_PRESSURE_SYSTOLIC, HealthDataType.HEART_RATE];

                                      List<HealthDataAccess> permissions = [HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE, HealthDataAccess.READ_WRITE];

                                      final requested = Platform.isIOS
                                          ? await health.requestAuthorization(healthDataType, permissions: permissions)
                                          : await health.hasPermissions(healthDataType, permissions: permissions);

                                      if (requested == true) {
                                        await healthController.addPressure(systolic.toInt(), diastolic.toInt(), selectedDate ?? widget.date, selectedDate ?? widget.date);
                                        await healthController.addPulse(pulse, selectedDate ?? widget.date, selectedDate ?? widget.date);
                                      }

                                      String newPressure = "${controllerDiastolic.text}.${controllerSystolic.text}";

                                      String? conditions;

                                      if(controllerConditions.text.isNotEmpty){
                                        chossenCondition.add(controllerConditions.text);
                                      }

                                      if(chossenCondition.isNotEmpty){
                                        conditions = chossenCondition.join(";");
                                      }

                                      final servicePressure = await service.createSensorsMeasurement(
                                        CreateClientSensorsRequest(
                                            healthSensorId: 7,
                                            healthSensorVal: double.parse(newPressure),
                                            dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate ?? widget.date),
                                            comment: controllerComment.text.isNotEmpty ? controllerComment.text : null,
                                            conditions: conditions,
                                            health: self
                                        ),
                                      );

                                      int diastolicPressure = int.parse(controllerDiastolic.text);
                                      int systolicPressure = int.parse(controllerSystolic.text);

                                      final servicePulse = await service.createSensorsMeasurement(
                                        CreateClientSensorsRequest(
                                          healthSensorId: 3,
                                          healthSensorVal: int.parse(controllerPulse.text),
                                          dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate ?? widget.date),
                                        ),
                                      );

                                      if (servicePulse.result && servicePressure.result) {

                                        GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.addPressureClient);
                                        context.loaderOverlay.hide();

                                        if (diastolicPressure > 109 || systolicPressure > 179) {
                                          if(state is MyExpertLoadedState){
                                            if(state.view != null && state.view!.isNotEmpty){

                                              final pushService = PushService();
                                              final storage = SharedPreferenceData.getInstance();

                                              final clientName = await storage.getItem(SharedPreferenceData.userNameKey);

                                              if(clientName != ""){
                                                state.view?.forEach((element) async{
                                                  if(element.expertId != null){
                                                    await pushService.sendPush("У Клиента $clientName критические показатели АД", element.expertId.toString());
                                                  }
                                                });
                                              }
                                            }
                                          }
                                        }


                                        context.router.maybePop(true);
                                      } else {
                                        context.loaderOverlay.hide();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 1),
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
                                        duration: Duration(seconds: 1),
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
                                text: 'добавить'.toUpperCase(),
                              ),
                              SizedBox(height: 50.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            );
          }
        );
      }
    );
  }

  getLastMeasure(String? date, num? measure){
    if(date != null){
      lastMeasure = DateTime.parse(date);
    }
    if(measure != null){
      var pressure = measure.toDouble();

      String newTest = pressure.toString();

      List values = newTest.split(".");

      diastolicPressure = int.parse(setDecimalDigits(values.first));
      systolicPressure = int.parse(setDecimalDigits(values.last));
    }
  }

  getPulse(List<ClientSensorsView>? view) {
    if (view != null && view.isNotEmpty && lastMeasure != null) {
      for (var element in view) {
        if(element.dateSensor != null && element.healthSensorVal != null){
          DateTime newDate = DateTime.parse(element.dateSensor!);

          if(newDate.year == lastMeasure!.year && newDate.month == lastMeasure!.month && newDate.day == lastMeasure!.day &&
          newDate.hour == lastMeasure!.hour && newDate.minute == lastMeasure!.minute){
            lastPulse = element.healthSensorVal!.toInt();
            break;
          }
        }
      }
    }
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

  String setDecimalDigits(String number) {
    String firstChar = number[0];

    if (number.length == 1) {
      if (firstChar == "1" || firstChar == "2") {
        return number + "00";
      }
      return number + "0";
    }

    if ((firstChar == "1" || firstChar == "2") && number.length == 2) {
      return number + "0";
    }
    return number;
  }
}
