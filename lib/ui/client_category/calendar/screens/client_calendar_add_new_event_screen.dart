import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_request_model.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/controllers/client/calendar/calendar_controller.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/bottom_align.dart/bottom_align.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:garnetbook/widgets/buttons/switch_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientCalendarAddNewEventScreen extends StatefulWidget {
  ClientCalendarAddNewEventScreen({super.key, this.selectedDate});
  final DateTime? selectedDate;

  @override
  State<ClientCalendarAddNewEventScreen> createState() => _ClientCalendarAddNewEventScreenState();
}

class _ClientCalendarAddNewEventScreenState extends State<ClientCalendarAddNewEventScreen> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerStartTime = TextEditingController();
  TextEditingController controllerEndTime = TextEditingController();

  List<String> eventTypeList = ["Консультация", "Встреча", "Прием", "Напоминание", "Событие"];

  String startDate = '';
  String endDate = '';
  String startTime = '';
  String endTime = '';
  bool allDay = false;
  DateTime? selectedDate;
  DateTime? selectedEndDate;
  bool validation = false;
  bool isEventTypeOpen = false;
  double heightSafeArea = 0;

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerTitle.dispose();
    controllerStartTime.dispose();
    controllerEndTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.basicwhiteColor,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.gradientTurquoiseReverse,
          ),
          child: SafeArea(
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              if (heightSafeArea < constraints.maxHeight) {
                heightSafeArea = constraints.maxHeight;
              }
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 56.h + 20.h),
                              CustomTextFieldLabel(
                                onTap: () {
                                  setState(() {
                                    isEventTypeOpen = !isEventTypeOpen;
                                    if (validation) {
                                      validation = false;
                                    }
                                  });
                                },
                                multiLines: true,
                                enabled: false,
                                backGroudColor: AppColors.basicwhiteColor,
                                controller: controllerName,
                                labelText: 'Тип события',
                                labelColor: AppColors.vivaMagentaColor,
                                borderColor:
                                    validation && controllerName.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
                              ),
                              Visibility(
                                visible: isEventTypeOpen,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 1,
                                            color: AppColors.seaColor,
                                          ),
                                          color: AppColors.basicwhiteColor,
                                        ),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(maxHeight: 250, minHeight: 50),
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: eventTypeList.length,
                                            itemBuilder: (context, index) {
                                              return FormForButton(
                                                borderRadius: BorderRadius.only(
                                                  topRight: index == 0 ? Radius.circular(10) : Radius.zero,
                                                  topLeft: index == 0 ? Radius.circular(10) : Radius.zero,
                                                  bottomRight: index + 1 == eventTypeList.length ? Radius.circular(10) : Radius.zero,
                                                  bottomLeft: index + 1 == eventTypeList.length ? Radius.circular(10) : Radius.zero,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    controllerName.text = eventTypeList[index];
                                                    isEventTypeOpen = false;
                                                    if (validation) {
                                                      validation = false;
                                                    }
                                                  });

                                                  if (validation) {
                                                    setState(() {
                                                      validation = false;
                                                    });
                                                  }
                                                },
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 12.h),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            eventTypeList[index],
                                                            style: TextStyle(
                                                              fontFamily: 'Inter',
                                                              color: controllerName.text == eventTypeList[index]
                                                                  ? AppColors.vivaMagentaColor
                                                                  : AppColors.darkGreenColor,
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          if (controllerName.text == eventTypeList[index])
                                                            CircleAvatar(
                                                              radius: 10.r,
                                                              backgroundColor: AppColors.vivaMagentaColor,
                                                              child: Center(
                                                                child: SvgPicture.asset(
                                                                  'assets/images/checkmark.svg',
                                                                  color: AppColors.basicwhiteColor,
                                                                  height: 14.h,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 12.h),
                                                    if(index + 1 != eventTypeList.length)
                                                      Container(
                                                        color: AppColors.seaColor,
                                                        height: 1,
                                                      ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),
                              CustomTextFieldLabel(
                                onChanged: (v) {
                                  if (validation) {
                                    setState(() {
                                      validation = false;
                                    });
                                  }
                                },
                                backGroudColor: AppColors.basicwhiteColor,
                                controller: controllerTitle,
                                labelText: "Описание",
                                labelColor: AppColors.vivaMagentaColor,
                                keyboardType: TextInputType.multiline,
                                multiLines: true,
                                maxLines: 10,
                                maxLength: 150,
                                borderColor: AppColors.lightGreenColor,
                              ),
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
                                      onPressed: firstDateFun,
                                      child: CustomTextFieldLabel(
                                        enabled: false,
                                        backGroudColor: AppColors.basicwhiteColor,
                                        controller: controllerStartTime,
                                        labelColor: AppColors.vivaMagentaColor,
                                        labelText: 'Начало',
                                        borderColor: validation && controllerStartTime.text.isEmpty
                                            ? AppColors.vivaMagentaColor
                                            : AppColors.lightGreenColor,
                                      ),
                                    ),
                                  ),
                                  allDay
                                      ? const SizedBox()
                                      : Container(
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
                                            onPressed: endDateFun,
                                            child: CustomTextFieldLabel(
                                              backGroudColor: AppColors.basicwhiteColor,
                                              controller: controllerEndTime,
                                              enabled: false,
                                              labelText: 'Окончание',
                                              borderColor: !allDay && validation && controllerEndTime.text.isEmpty
                                                  ? AppColors.vivaMagentaColor
                                                  : AppColors.lightGreenColor,
                                              labelColor: AppColors.vivaMagentaColor,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/clock.svg',
                                    color: AppColors.darkGreenColor,
                                    height: 32.h,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Целый день',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                      fontFamily: 'Inter',
                                      color: AppColors.darkGreenColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  SwitchWidget(
                                    activeColor: AppColors.vivaMagentaColor,
                                    activeTrackColor: AppColors.basicwhiteColor,
                                    inactiveTrackColor: AppColors.basicwhiteColor,
                                    inactiveThumbColor: AppColors.grey40Color,
                                    isSwitched: allDay,
                                    onChanged: (value) {
                                      setState(() {
                                        allDay = !allDay;
                                        controllerStartTime.text = "";
                                        controllerEndTime.text = "";
                                        selectedDate = null;
                                        selectedEndDate = null;

                                        if (validation) {
                                          validation = false;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BottomAlign(
                    heightOfChild: 80.h,
                    heightSafeArea: heightSafeArea,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 14.w),
                      padding: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.r),
                            topRight: Radius.circular(8.r)
                        ),
                        gradient: AppColors.gradientTurquoiseReverse,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: WidgetButton(
                              onTap: () {
                                context.router.maybePop();
                              },
                              color: AppColors.lightGreenColor,
                              child: Text(
                                'отмена'.toUpperCase(),
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
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                if (selectedDate != null && controllerName.text.isNotEmpty && (selectedEndDate != null || allDay)) {
                                  if (!allDay && selectedEndDate != null) {
                                    Duration difference = selectedEndDate!.difference(selectedDate!);

                                    if (difference.isNegative) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            'Дата окончания должна быть позже даты начало события',
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
                                  }

                                  context.loaderOverlay.show();

                                  String newStartDate = "";
                                  String newEndDate = "";

                                  if (allDay) {
                                    newStartDate = DateFormatting().dateISOFormatWithTime.format(selectedDate!);
                                  } else {
                                    newStartDate = DateFormatting().dateISOFormatWithTime.format(selectedDate!);
                                  }

                                  if (controllerEndTime.text.isNotEmpty && !allDay) {
                                    newEndDate = DateFormatting().dateISOFormatWithTime.format(selectedEndDate!);
                                  }

                                  DateTime tempDate = DateTime.parse(newStartDate);

                                  final request = await CalendarController().addEventToCalendar(EventRequest(
                                    eventStatusId: 1,
                                    eventName: controllerName.text,
                                    description: controllerTitle.text.isNotEmpty ? controllerTitle.text : null,
                                    eventDate: newStartDate,
                                    eventFinish: !allDay
                                        ? newEndDate
                                        : DateFormat("yyyy-MM-dd HH:mm:ss")
                                            .format(DateTime(tempDate.year, tempDate.month, tempDate.day, 23, 59, 59)),
                                    fullDay: allDay,
                                  ));

                                  if (request) {
                                    GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.addNewEventClient);

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
                                'создать'.toUpperCase(),
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
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientTurquoise,
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => context.router.maybePop(),
                            icon: Image.asset(
                              AppImeges.arrow_back_png,
                              color: AppColors.darkGreenColor,
                              height: 25.h,
                              width: 25.w,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Новое событие',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                              fontFamily: 'Inter',
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  check() {
    if (widget.selectedDate != null) {
      String date = DateFormat("dd.MM.yy").format(widget.selectedDate!);
      setState(() {
        selectedDate = widget.selectedDate!;
        controllerStartTime = TextEditingController(text: "$date ${DateFormat("HH:mm").format(DateTime.now())}");
      });
    }
  }

  firstDateFun() {
    if (allDay) {
      DatePickerBdaya.showDatePicker(
        context,
        showTitleActions: true,
        onConfirm: (date) {
          setState(() {
            selectedDate = date;
            startDate = DateFormat("dd.MM.yy").format(date);
            controllerStartTime.text = startDate;

            if (validation) {
              validation = false;
            }
          });
        },
        currentTime: widget.selectedDate ?? DateTime.now(),
        locale: LocaleType.ru,
      );
    } else {
      DatePickerBdaya.showDateTimePicker(
        context,
        showTitleActions: true,
        onConfirm: (date) {
          setState(() {
            selectedDate = date;
            startDate = DateFormat("dd.MM.yy").format(date);
            startTime = DateFormat("HH:mm").format(date);
            controllerStartTime.text = '$startDate $startTime';

            if (validation) {
              validation = false;
            }
          });
        },
        currentTime: widget.selectedDate ?? DateTime.now(),
        locale: LocaleType.ru,
      );
    }
  }

  endDateFun() {
    DatePickerBdaya.showDateTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        setState(() {
          selectedEndDate = date;
          endDate = DateFormat("dd.MM.yy").format(date);
          endTime = DateFormat("HH:mm").format(date);
          controllerEndTime.text = '$endDate $endTime';

          if (validation) {
            validation = false;
          }
        });
      },
      currentTime: widget.selectedDate ?? DateTime.now(),
      locale: LocaleType.ru,
    );
  }
}
