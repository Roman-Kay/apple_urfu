import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_request_model.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/analytics/service_analytics.dart';
import 'package:garnetbook/domain/controllers/client/calendar/calendar_controller.dart';
import 'package:garnetbook/domain/services/client/calendar/calendar_service.dart';
import 'package:garnetbook/domain/services/notification/push_service.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/bottom_align.dart/bottom_align.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:garnetbook/widgets/dialogs/delete_dialog.dart';
import 'package:garnetbook/widgets/text_field/custom_textfiled_label.dart';
import 'package:garnetbook/widgets/buttons/switch_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

@RoutePage()
class ClientCalendarCheckEventScreen extends StatefulWidget {
  ClientCalendarCheckEventScreen(
      {super.key,
      this.fullDay,
      this.description,
      this.title,
      this.endTime,
      this.startTime,
      required this.id,
      this.expertName,
      this.expertId});

  final String? title;
  final String? description;
  final String? startTime;
  final String? endTime;
  final bool? fullDay;
  final int id;
  final String? expertName;
  final int? expertId;

  @override
  State<ClientCalendarCheckEventScreen> createState() => _ClientCalendarAddNewEventScreenState();
}

class _ClientCalendarAddNewEventScreenState extends State<ClientCalendarCheckEventScreen> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerStartTime = TextEditingController();
  TextEditingController controllerEndTime = TextEditingController();

  bool fullDay = false;
  String startDate = '';
  String endDate = '';
  String startTime = '';
  String endTime = '';
  bool validation = false;
  bool isEventTypeOpen = false;

  List<String> eventTypeList = ["Консультация", "Встреча", "Прием", "Напоминание", "Событие"];

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  DateTime? selectedDate;
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
        body: SafeArea(
          child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            if (heightSafeArea < constraints.maxHeight) {
              heightSafeArea = constraints.maxHeight;
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 56.h + 20.h),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.basicblackColor.withOpacity(0.1),
                                blurRadius: 6.r,
                              ),
                            ],
                          ),
                          child: CustomTextFieldLabel(
                            backGroudColor: AppColors.basicwhiteColor,
                            controller: controllerName,
                            labelText: 'Заголовок события',
                            enabled: false,
                            labelColor: AppColors.vivaMagentaColor,
                            borderColor: validation && controllerName.text.isEmpty ? AppColors.vivaMagentaColor : AppColors.lightGreenColor,
                            onTap: () {
                              if (widget.expertName == null && widget.id != -1) {
                                setState(() {
                                  isEventTypeOpen = !isEventTypeOpen;
                                  if (validation) {
                                    validation = false;
                                  }
                                });
                              }
                            },
                          ),
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
                        if (widget.expertName != null)
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.basicblackColor.withOpacity(0.1),
                                      blurRadius: 6.r,
                                    ),
                                  ],
                                ),
                                child: CustomTextFieldLabel(
                                  backGroudColor: AppColors.basicwhiteColor,
                                  controller: TextEditingController(text: widget.expertName),
                                  multiLines: true,
                                  enabled: false,
                                  labelText: 'Специалист',
                                  labelColor: AppColors.vivaMagentaColor,
                                  borderColor: AppColors.lightGreenColor,
                                ),
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.basicblackColor.withOpacity(0.1),
                                blurRadius: 6.r,
                              ),
                            ],
                          ),
                          child: CustomTextFieldLabel(
                            backGroudColor: AppColors.basicwhiteColor,
                            controller: controllerTitle,
                            multiLines: true,
                            maxLines: 10,
                            maxLength: 150,
                            labelText: 'Описание',
                            enabled: widget.expertName != null || widget.id == -1 ? false : true,
                            labelColor: AppColors.vivaMagentaColor,
                            borderColor: AppColors.lightGreenColor,
                            onChanged: (v) {
                              if (validation) {
                                setState(() {
                                  validation = false;
                                });
                              }
                            },
                          ),
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
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  side: BorderSide(
                                    width: 0,
                                    color: Color(0x000000),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                onPressed: () {
                                  if (widget.expertName == null && widget.id != -1) {
                                    if (fullDay) {
                                      DatePickerBdaya.showDatePicker(
                                        context,
                                        showTitleActions: true,
                                        onConfirm: (date) {
                                          setState(() {
                                            selectedDate = date;
                                            selectedStartDate = date;
                                            startDate = DateFormat("dd.MM.yy").format(date);
                                            controllerStartTime.text = startDate;

                                            if (validation) {
                                              validation = false;
                                            }
                                          });
                                        },
                                        currentTime: selectedDate ?? DateTime.now(),
                                        locale: LocaleType.ru,
                                      );
                                    } else {
                                      DatePickerBdaya.showDateTimePicker(
                                        context,
                                        showTitleActions: true,
                                        onConfirm: (date) {
                                          setState(() {
                                            selectedDate = date;
                                            selectedStartDate = date;
                                            startDate = DateFormat("dd.MM.yy").format(date);
                                            startTime = DateFormat("HH:mm").format(date);
                                            controllerStartTime.text = '$startDate $startTime';

                                            if (validation) {
                                              validation = false;
                                            }
                                          });
                                        },
                                        currentTime: selectedDate ?? DateTime.now(),
                                        locale: LocaleType.ru,
                                      );
                                    }
                                  }
                                },
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
                            if (!fullDay)
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
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    side: BorderSide(
                                      width: 0,
                                      color: Color(0x000000),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (widget.expertName == null && widget.id != -1) {
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
                                        currentTime: selectedDate ?? DateTime.now(),
                                        locale: LocaleType.ru,
                                      );
                                    }
                                  },
                                  child: CustomTextFieldLabel(
                                    backGroudColor: AppColors.basicwhiteColor,
                                    controller: controllerEndTime,
                                    labelText: 'Окончание',
                                    enabled: false,
                                    borderColor: !fullDay && validation && controllerEndTime.text.isEmpty
                                        ? AppColors.vivaMagentaColor
                                        : AppColors.lightGreenColor,
                                    labelColor: AppColors.vivaMagentaColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          height: 64.h,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/clock.svg',
                                color: AppColors.vivaMagentaColor,
                                height: 32.h,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Целый день',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                  fontFamily: 'Inter',
                                  color: AppColors.vivaMagentaColor,
                                ),
                              ),
                              const Spacer(),
                              SwitchWidget(
                                activeColor: AppColors.vivaMagentaColor,
                                activeTrackColor: AppColors.grey10Color,
                                inactiveTrackColor: AppColors.grey10Color,
                                inactiveThumbColor: AppColors.grey40Color,
                                isSwitched: fullDay,
                                onChanged: (value) {
                                  if (widget.expertName == null && widget.id != -1) {
                                    setState(() {
                                      fullDay = !fullDay;
                                      controllerStartTime.text = "";
                                      controllerEndTime.text = "";
                                      selectedDate = null;
                                      selectedEndDate = null;

                                      if (validation) {
                                        validation = false;
                                      }
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.id != -1)
                  BottomAlign(
                    heightOfChild: 80.h,
                    heightSafeArea: heightSafeArea,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.r),
                              topRight: Radius.circular(8.r)
                          ),
                          color: AppColors.basicwhiteColor
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 14.w),
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: WidgetButton(
                              onTap: () async {
                                showDialog(context: context, builder: (BuildContext context) => DeleteDialog()).then((value) async {
                                  if (value == true) {
                                    FocusScope.of(context).unfocus();
                                    context.loaderOverlay.show();
                                    final service = CalendarNetworkService();

                                    final response = await service.deleteCalendarEvent(widget.id);
                                    if (response.result) {
                                      if (widget.expertId != null) {
                                        final storage = SharedPreferenceData.getInstance();
                                        final clientName = await storage.getItem(SharedPreferenceData.userNameKey);

                                        if (clientName != "") {
                                          await PushService()
                                              .sendPush("Клиент $clientName отказался от назначенного события", widget.expertId.toString());
                                        }
                                      }

                                      GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.deleteEventClient);
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
                                });
                              },
                              color: AppColors.lightGreenColor,
                              child: Text(
                                'удалить'.toUpperCase(),
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

                                if (widget.expertName != null) {
                                  context.router.maybePop();
                                }
                                else {
                                  if (!isChanged()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(seconds: 3),
                                        content: Text(
                                          'Данные не изменились',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (selectedStartDate != null &&
                                      controllerName.text.isNotEmpty &&
                                      (selectedEndDate != null || fullDay)) {
                                    if (!fullDay && selectedEndDate != null) {
                                      Duration difference = selectedEndDate!.difference(selectedStartDate!);

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

                                    if (fullDay) {
                                      newStartDate = DateFormatting().dateISOFormatWithTime.format(selectedStartDate!);
                                    } else {
                                      newStartDate = DateFormatting().dateISOFormatWithTime.format(selectedStartDate!);
                                    }

                                    if (controllerEndTime.text.isNotEmpty && !fullDay) {
                                      newEndDate = DateFormatting().dateISOFormatWithTime.format(selectedEndDate!);
                                    }

                                    final request = await CalendarController().addEventToCalendar(EventRequest(
                                      eventStatusId: 1,
                                      eventName: controllerName.text,
                                      description: controllerTitle.text.isNotEmpty ? controllerTitle.text : null,
                                      eventDate: newStartDate,
                                      eventFinish: newEndDate != "" ? newEndDate : null,
                                      fullDay: fullDay,
                                      eventId: widget.id,
                                    ));

                                    if (request) {
                                      GetIt.I.get<ServiceAnalytics>().setEvent(AnalyticsEvents.changeEventClient);

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
                                }
                              },
                              color: AppColors.darkGreenColor,
                              boxShadow: true,
                              child: Text(
                                widget.expertName != null ? "назад".toUpperCase() : 'изменить'.toUpperCase(),
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
                  color: AppColors.basicwhiteColor,
                  child: Container(
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
                            'Просмотр события',
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
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  check() {
    if (widget.title != null) {
      setState(() {
        controllerName = TextEditingController(text: widget.title);
      });
    }

    if (widget.description != null) {
      setState(() {
        controllerTitle = TextEditingController(text: widget.description);
      });
    }

    if (widget.startTime != null) {
      setState(() {
        selectedDate = DateTime.parse(widget.startTime!);
        selectedStartDate = selectedDate;
        String newDate = DateFormat("dd.MM.yy").format(selectedDate!);
        String newTime = DateFormat("HH:mm").format(selectedDate!);
        controllerStartTime = TextEditingController(text: "$newDate $newTime");
      });
    }

    if (widget.endTime != null) {
      setState(() {
        selectedEndDate = DateTime.parse(widget.endTime!);
        DateTime tempDate = DateTime.parse(widget.endTime!);
        String newDate = DateFormat("dd.MM.yy").format(tempDate);
        String newTime = DateFormat("HH:mm").format(tempDate);
        controllerEndTime = TextEditingController(text: "$newDate $newTime");
      });
    }

    if (widget.fullDay != null) {
      if (selectedDate != null && selectedEndDate != null) {
        String newTime = DateFormat("HH:mm").format(selectedDate!);
        String newTimeEnd = DateFormat("HH:mm").format(selectedEndDate!);

        if (newTime == "00:00" && newTimeEnd == "23:59") {
          setState(() {
            fullDay = true;
            controllerStartTime = TextEditingController(text: DateFormat("dd.MM.yyyy").format(selectedDate!));
          });
        }
      }
    }
  }

  bool isChanged() {
    if (widget.title != controllerName.text)
      return true;
    else if (widget.description != controllerTitle.text)
      return true;
    else if (widget.startTime != controllerStartTime.text)
      return true;
    else if (widget.endTime != controllerEndTime.text)
      return true;
    else if (widget.fullDay != fullDay)
      return true;
    else
      return false;
  }
}
