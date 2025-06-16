import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/health/blood_glucose/blood_glucose_bloc.dart';
import 'package:garnetbook/bloc/client/my_expert/my_expert_cubit.dart';
import 'package:garnetbook/data/models/client/sensors/sensors_request.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/notification/push_service.dart';
import 'package:garnetbook/domain/services/sensors/sensors_sevice.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/portion_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:get_it/get_it.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientSensorsBloodGlucoseSheet extends StatefulWidget {
  const ClientSensorsBloodGlucoseSheet({required this.date, super.key});
  final DateTime date;

  @override
  State<ClientSensorsBloodGlucoseSheet> createState() => _ClientSensorsBloodGlucoseSheetState();
}

class _ClientSensorsBloodGlucoseSheetState extends State<ClientSensorsBloodGlucoseSheet> {
  String date = '';
  String time = '';
  DateTime? selectedDate;
  int selectedValue = 50;
  bool validation = false;
  String self = "Нормальное";
  DateTime? lastMeasure;
  double? lastGlucose;

  TextEditingController controllerTime = TextEditingController();
  TextEditingController controllerMol = TextEditingController();
  TextEditingController controllerComment = TextEditingController();

  final RegExp doubleRegExp = RegExp(r'[0-9]+[.,]?[0-9]*');
  FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: 50);
  List<String> chooseItem = [];
  bool isInsulin = false;

  List<String> itemsPortionList = [
    'До еды',
    'После еды',
    'До физической активности',
    'После физической активности',
    'Перед сном',
  ];

  @override
  void initState() {
    controllerTime.text = DateFormat("dd.MM.yy HH:mm").format(DateTime(widget.date.year, widget.date.month, widget.date.day, DateTime.now().hour, DateTime.now().minute));
    selectedDate = DateTime(widget.date.year, widget.date.month, widget.date.day, DateTime.now().hour, DateTime.now().minute);
    super.initState();
  }

  @override
  void dispose() {
    controllerTime.dispose();
    controllerMol.dispose();
    controllerComment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyExpertCubit, MyExpertState>(
      builder: (context, state) {
        return BlocBuilder<BloodGlucoseBloc, BloodGlucoseState>(builder: (context, glucoseState) {
          if(glucoseState is BloodGlucoseLoadedState){
            getLastMeasure(glucoseState.currentVal?.dateSensor, glucoseState.currentVal?.healthSensorVal);
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
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Column(
                              children: [
                                SizedBox(height: 15.h),
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
                                //SizedBox(height: 16.h),
                                // Row(
                                //   children: [
                                //     Text(
                                //       'Единицы\nизмерения:',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.w400,
                                //         fontSize: 16.sp,
                                //         height: 1,
                                //         fontFamily: 'Inter',
                                //         color: AppColors.darkGreenColor,
                                //       ),
                                //     ),
                                //     Spacer(),
                                //     Container(
                                //       height: 44.h,
                                //       width: 226.w,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(8.r),
                                //         gradient: AppColors.gradientSecond,
                                //       ),
                                //       child: Stack(
                                //         children: [
                                //           Padding(
                                //             padding: EdgeInsets.symmetric(horizontal: 4.w),
                                //             child: AnimatedAlign(
                                //               duration: Duration(milliseconds: 100),
                                //               alignment: isMol ? Alignment.centerLeft : Alignment.centerRight,
                                //               child: Container(
                                //                 height: 36.h,
                                //                 width: 109.w,
                                //                 decoration: BoxDecoration(
                                //                   borderRadius: BorderRadius.circular(9.r),
                                //                   color: AppColors.basicwhiteColor,
                                //                   boxShadow: [
                                //                     BoxShadow(
                                //                       blurRadius: 10,
                                //                       color: AppColors.basicblackColor.withOpacity(0.1),
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //           Padding(
                                //             padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                                //             child: Row(
                                //               children: [
                                //                 SizedBox(
                                //                   width: 109.w,
                                //                   height: 36.h,
                                //                   child: FormForButton(
                                //                     borderRadius: BorderRadius.circular(8.r),
                                //                     onPressed: () {
                                //                       setState(() {
                                //                         isMol = true;
                                //                         selectedValue = (selectedValue / 18.018).toInt() < 0 ? 0 : (selectedValue / 18.018).toInt();
                                //                         scrollController.animateToItem(
                                //                           selectedValue,
                                //                           duration: Duration(milliseconds: 200),
                                //                           curve: Curves.ease,
                                //                         );
                                //                       });
                                //                     },
                                //                     child: Center(
                                //                       child: Text(
                                //                         'Ммоль/л',
                                //                         style: TextStyle(
                                //                           fontWeight: FontWeight.w400,
                                //                           fontSize: 14.sp,
                                //                           height: 1,
                                //                           fontFamily: 'Inter',
                                //                           color: AppColors.darkGreenColor,
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 SizedBox(
                                //                   width: 109.w,
                                //                   height: 36.h,
                                //                   child: FormForButton(
                                //                     borderRadius: BorderRadius.circular(8.r),
                                //                     onPressed: () {
                                //                       setState(() {
                                //                         isMol = false;
                                //                         selectedValue = (selectedValue * 18.018).toInt();
                                //                         scrollController.animateToItem(
                                //                           selectedValue,
                                //                           duration: Duration(milliseconds: 200),
                                //                           curve: Curves.ease,
                                //                         );
                                //                       });
                                //                     },
                                //                     child: Center(
                                //                       child: Text(
                                //                         'Мг/дл',
                                //                         style: TextStyle(
                                //                           fontWeight: FontWeight.w400,
                                //                           fontSize: 14.sp,
                                //                           height: 1,
                                //                           fontFamily: 'Inter',
                                //                           color: AppColors.darkGreenColor,
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(height: 24.h),
                                Column(
                                  children: [
                                    SizedBox(height: 5.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        FormForButton(
                                          borderRadius: BorderRadius.circular(50),
                                          onPressed: () {
                                            scrollController.animateToItem(
                                              selectedValue - 1,
                                              duration: Duration(milliseconds: 100),
                                              curve: Curves.ease,
                                            );
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/minus_icon.svg',
                                            // ignore: deprecated_member_use
                                            color: AppColors.greenColor,
                                            height: 48.h,
                                          ),
                                        ),
                                        Text(
                                          getText(selectedValue),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 48.sp,
                                            height: 1,
                                            fontFamily: 'Inter',
                                            color: AppColors.darkGreenColor,
                                          ),
                                        ),
                                        FormForButton(
                                          borderRadius: BorderRadius.circular(50),
                                          onPressed: () {
                                            scrollController.animateToItem(
                                              selectedValue + 1,
                                              duration: Duration(milliseconds: 100),
                                              curve: Curves.ease,
                                            );
                                          },
                                          child: SizedBox(
                                            height: 48.h,
                                            width: 48.h,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/images/plus.svg',
                                                color: AppColors.greenColor,
                                                height: 36.h,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      //isMol ?
                                      'ммоль/л',
                                      //: 'Мг/дл',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp,
                                        fontFamily: 'Inter',
                                        color: AppColors.darkGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50.h,
                            child: Center(
                              child: Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      width: 46.w,
                                      height: 38.h,
                                      color: const Color(0xFFDFF9F8),
                                    ),
                                  ),
                                  RotatedBox(
                                    quarterTurns: -1,
                                    child: ListWheelScrollView(
                                      diameterRatio: 100,
                                      useMagnifier: true,
                                      onSelectedItemChanged: (index) {
                                        selectedValue = index;
                                        setState(() {});
                                      },
                                      controller: scrollController,
                                      physics: const FixedExtentScrollPhysics(),
                                      children: List.generate(
                                        //isMol ?
                                        301, // : 301 * 19,
                                        (index) {
                                          String text = getText(index);
                                          // (index * 0.1).floor().toString() +
                                          //     ',' +
                                          //     (((index * 0.1) - (index * 0.1).floor()).toString().length > 3
                                          //         ? (Decimal.parse('${index * 0.1}') - Decimal.fromInt((index * 0.1).floor())).toString()[2]
                                          //         : ((index * 0.1) - (index * 0.1).floor()).toString()[2]);
                                          return RotatedBox(
                                            quarterTurns: 1,
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Container(
                                                  width: 48.w,
                                                  height: 38.h,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 1, color: AppColors.limeColor),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: index == selectedValue
                                                        ? null
                                                        : () {
                                                            scrollController.animateToItem(
                                                              index,
                                                              duration: Duration(milliseconds: 100),
                                                              curve: Curves.ease,
                                                            );
                                                          },
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                                                      child: FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Center(
                                                          child: Text(
                                                            '$text',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16.sp,
                                                              fontFamily: 'Inter',
                                                              color: AppColors.darkGreenColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    // ignore: unused_local_variable
                                                    for (var i in List.generate(7, (int index) => index))
                                                      Container(
                                                        width: 2,
                                                        height: 4,
                                                        color: AppColors.seaColor,
                                                      ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      itemExtent: 46.w,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: SvgPicture.asset(
                                      'assets/images/cursor_second.svg',
                                      color: AppColors.darkGreenColor,
                                      height: 12.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if(lastMeasure != null && lastGlucose != null)
                            Container(
                              margin: EdgeInsets.only(top: 18.h, bottom: 5.h),
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                color: AppColors.grey10Color
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
                                          fontFamily: "Inter",
                                          color: AppColors.darkGreenColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600
                                        ),
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
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        lastGlucose != null ? removeDecimalZeroFormat(lastGlucose!) : "0",
                                        style: TextStyle(
                                            fontFamily: "Inter",
                                            color: AppColors.darkGreenColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "ммоль/л",
                                        style: TextStyle(
                                            fontFamily: "Inter",
                                            color: AppColors.darkGreenColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 24.h),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Когда вы проводили измерение?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.darkGreenColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientTurquoise,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Wrap(
                                  spacing: 4.w,
                                  runSpacing: 8.h,
                                  children: [
                                    for (var text in itemsPortionList)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (chooseItem.contains(text)) {
                                              chooseItem.remove(text);
                                            } else {
                                              chooseItem.add(text);
                                            }
                                          });
                                        },
                                        child: PortionButton(
                                          haveNullSize: true,
                                          isShadow: false,
                                          textColor: AppColors.darkGreenColor,
                                          backgroundColor: chooseItem.contains(text) ? null : AppColors.basicwhiteColor,
                                          gradient: chooseItem.contains(text) ? AppColors.gradientTurquoise : null,
                                          borderColor: AppColors.limeColor,
                                          text: text,
                                        ),
                                      )
                                  ],
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
                                                  self = "Плохое";
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
                                  keyboardType: TextInputType.multiline,
                                  hintColor: AppColors.vivaMagentaColor,
                                  multiLines: true,
                                  maxLines: 3,
                                  maxLength: 80,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'Опишите в нескольких словах. Это поможет специалисту проанализировать ваш отчет',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    height: 1.2,
                                    fontFamily: 'Inter',
                                    color: AppColors.darkGreenColor.withOpacity(0.6),
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      isInsulin = !isInsulin;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/syringe.svg',
                                        height: 32.h,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Инсулин',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.sp,
                                          fontFamily: 'Inter',
                                          color: AppColors.darkGreenColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 26.h,
                                        width: 26.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(99),
                                          border: Border.all(color: AppColors.darkGreenColor),
                                          color: isInsulin ? AppColors.darkGreenColor : AppColors.basicwhiteColor,
                                        ),
                                        child: Center(
                                            child: SvgPicture.asset(
                                              'assets/images/checkmark.svg',
                                              color: AppColors.basicwhiteColor,
                                              height: 18.h,
                                            ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                WidgetButton(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();

                                    if (controllerTime.text.isNotEmpty) {
                                      if (!doubleRegExp.hasMatch(
                                        '${'${selectedValue * 0.1}'[0]}${selectedValue >= 100 ? '${selectedValue * 0.1}'[1] : ''},${'${selectedValue * 0.1}'[selectedValue >= 100 ? 3 : 2]}',
                                      )) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 3),
                                            content: Text(
                                              'Введите корректное значение показателя сахара',
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
                                      else {
                                        context.loaderOverlay.show();

                                        HealthServiceController healthController = HealthServiceController();
                                        Health health = Health();
                                        double value = selectedValue * 0.1; //isMol ? selectedValue * 0.1 : selectedValue * 0.1 / 18.018;

                                        final requested = Platform.isIOS
                                            ? await health.requestAuthorization([HealthDataType.BLOOD_GLUCOSE], permissions: [HealthDataAccess.READ_WRITE])
                                            : await health.hasPermissions([HealthDataType.BLOOD_GLUCOSE], permissions: [HealthDataAccess.READ_WRITE]);

                                        if (requested == true) {
                                          await healthController.addBloodGlucose(value, selectedDate ?? widget.date, selectedDate ?? widget.date);
                                        }

                                        String? conditions;

                                        if (chooseItem.isNotEmpty) {
                                          conditions = chooseItem.join(";");
                                        }

                                        final service = await SensorsService().createSensorsMeasurement(
                                          CreateClientSensorsRequest(
                                              healthSensorId: 6,
                                              healthSensorVal: value.toDouble(),
                                              dateSensor: DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate ?? widget.date),
                                              comment: controllerComment.text.isNotEmpty ? controllerComment.text : null,
                                              insulin: isInsulin,
                                              conditions: conditions,
                                              health: self),
                                        );

                                        if (service.result) {
                                          if (value.toDouble() > 5.6) {
                                            if(state is MyExpertLoadedState){
                                              if(state.view != null && state.view!.isNotEmpty){

                                                final pushService = PushService();
                                                final storage = SharedPreferenceData.getInstance();

                                                final clientName = await storage.getItem(SharedPreferenceData.userNameKey);

                                                if(clientName != ""){
                                                  state.view?.forEach((element) async{
                                                    if(element.expertId != null){
                                                      await pushService.sendPush("У Клиента $clientName критические показатели САХАРА", element.expertId.toString());
                                                    }
                                                  });
                                                }
                                              }
                                            }
                                          }

                                          GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.addBloodSugarClient);
                                          context.loaderOverlay.hide();

                                          context.router.maybePop(true);
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
                                  text: 'добавить'.toUpperCase(),
                                ),
                                SizedBox(height: 24.h),
                              ],
                            ),
                          ),
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

  String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
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

  getLastMeasure(String? date, num? measure){
    if(date != null){
      lastMeasure = DateTime.parse(date);
    }
    if(measure != null){
      lastGlucose = measure.toDouble();
    }
  }

  String getText(int index) {
    return (index * 0.1).floor().toString() +
        ',' +
        (((index * 0.1) - (index * 0.1).floor()).toString().length > 3
            ? (Decimal.parse('${index * 0.1}') - Decimal.fromInt((index * 0.1).floor())).toString()[2]
            : ((index * 0.1) - (index * 0.1).floor()).toString()[2]);
  }
}


