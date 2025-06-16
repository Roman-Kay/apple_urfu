import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/client/calendar/calendar_cubit.dart';
import 'package:garnetbook/bloc/client/calendar/calendar_for_day/calendar_for_day_bloc.dart';
import 'package:garnetbook/data/models/client/calendar/calendar_view_model.dart';
import 'package:garnetbook/domain/services/client/calendar/calendar_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/data/repository/calendar_storage.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/extension/string_externsions.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/dialogs/delete_dialog.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';


class ClientCalendarTabBarEvents extends StatefulWidget {
  ClientCalendarTabBarEvents({
    super.key,
    required this.chosenDate,
    required this.list,
  });


  final DateTime chosenDate;
  final List<EventView> list;


  @override
  State<ClientCalendarTabBarEvents> createState() => _ClientCalendarTabBarEventsState();
}

class _ClientCalendarTabBarEventsState extends State<ClientCalendarTabBarEvents> {
  @override
  Widget build(BuildContext context) {
    if (widget.list.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    DateTime.now().year == widget.chosenDate.year && DateTime.now().month == widget.chosenDate.month && DateTime.now().day == widget.chosenDate.day
                        ? 'Запланировано\nна сегодня:'
                        : 'Запланировано на\n${widget.chosenDate.day} ${CalendarStorage.nameMonthByNumber[widget.chosenDate.month]} ${widget.chosenDate.year}:',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                ),
                Container(
                  width: 160.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: AppColors.darkGreenColor,
                  ),
                  child: FormForButton(
                    borderRadius: BorderRadius.circular(4.r),
                    onPressed: () {
                      context.router.push(ClientCalendarAddNewEventRoute(selectedDate: widget.chosenDate)).then((value) {
                        if (value == true) {
                          String newDate = DateFormat("yyyy-MM-dd").format(widget.chosenDate);
                          context.read<CalendarForDayBloc>().add(CalendarForDayGetEvent(newDate));
                          context.read<CalendarCubit>().check();
                        }
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                      child: Text(
                        'добавить'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          color: AppColors.basicwhiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: widget.list.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final itemEventOfDay = widget.list[index];

                  return Column(
                    children: [
                      FormForButton(
                        borderRadius: BorderRadius.circular(8.r),
                        onPressed: () {
                          if (itemEventOfDay.id != null) {
                            context.router.push(ClientCalendarCheckEventRoute(
                              id: itemEventOfDay.additionally == "Принять добавку" ? -1 : itemEventOfDay.id!,
                              title: itemEventOfDay.eventName,
                              description: itemEventOfDay.description,
                              fullDay: itemEventOfDay.fullDay,
                              expertName: itemEventOfDay.expertFirstName,
                              expertId: itemEventOfDay.expertId,
                              startTime: itemEventOfDay.eventDate,
                              endTime: itemEventOfDay.eventFinish,
                            )).then((value) {
                              if (value == true) {
                                String newDate = DateFormat("yyyy-MM-dd").format(widget.chosenDate);
                                context.read<CalendarForDayBloc>().add(CalendarForDayGetEvent(newDate));
                                context.read<CalendarCubit>().check();
                              }
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.vivaMagentaColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: itemEventOfDay.id != -1 ? Slidable(
                            startActionPane: ActionPane(
                              motion: BehindMotion(),
                              children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.vivaMagentaColor,
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(7.r),
                                      ),
                                    ),
                                    child:  FormForButton(
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(7.r),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteDialog();
                                          },
                                        ).then((value) async {
                                          if (value == true && itemEventOfDay.id != null) {
                                            FocusScope.of(context).unfocus();
                                            context.loaderOverlay.show();
                                            final service = CalendarNetworkService();

                                            final response = await service.deleteCalendarEvent(itemEventOfDay.id!);
                                            if (response.result) {
                                              context.loaderOverlay.hide();
                                              String newDate = DateFormat("yyyy-MM-dd").format(widget.chosenDate);
                                              context.read<CalendarForDayBloc>().add(CalendarForDayGetEvent(newDate));
                                              context.read<CalendarCubit>().check();
                                            }

                                            else {
                                              context.loaderOverlay.hide();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  duration: Duration(seconds: 3),
                                                  content: Text(
                                                    "Произошла ошибка. Попробуйте повторить позже",
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
                                      child: SizedBox(
                                        height: double.infinity,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 15.w),
                                            SvgPicture.asset(
                                              'assets/images/trash.svg',
                                              width: 32.w,
                                              color: AppColors.basicwhiteColor,
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              'Удалить\nсобытие',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.basicwhiteColor,
                                              ),
                                            ),
                                            SizedBox(width: 50.w),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.basicblackColor.withOpacity(0.1),
                                    blurRadius: 10.r,
                                  ),
                                ],
                                border: itemEventOfDay.eventStatus?.name == "Просрочено" ? Border.all(color: AppColors.redColor, width: 1) : null,
                                borderRadius: BorderRadius.circular(8.r),
                                color: itemEventOfDay.eventStatus?.name == "Просрочено"
                                    ? AppColors.tintsColor
                                    : (index + 1) % 3 == 1
                                        ? AppColors.lightGreenColor
                                        : (index + 1) % 3 == 2
                                            ? AppColors.limeColor
                                            : AppColors.seaColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (getEventDate(itemEventOfDay.eventDate) != "")
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.r),
                                              color: AppColors.basicwhiteColor,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                              child: Text(
                                                getEventDate(itemEventOfDay.eventDate),
                                                style: TextStyle(
                                                  fontSize: 14.w,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.darkGreenColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          itemEventOfDay.eventStatus?.name == "Просрочено" ? SizedBox(height: 8.h) : const SizedBox(),
                                          itemEventOfDay.eventStatus?.name == "Просрочено"
                                              ? Text(
                                                  'просрочено',
                                                  style: TextStyle(
                                                    fontSize: 10.w,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.redColor,
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    SizedBox(
                                      width: getEventDate(itemEventOfDay.eventDate) == "" ? 0 : 23.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            itemEventOfDay.eventName != null ? itemEventOfDay.eventName!.capitalize() : "",
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.darkGreenColor,
                                            ),
                                          ),
                                          itemEventOfDay.expertFirstName != null ? SizedBox(height: 4.h) : const SizedBox(),
                                          itemEventOfDay.expertFirstName != null
                                              ? Text(
                                            itemEventOfDay.expertFirstName!.capitalize(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF4D5358),
                                            ),
                                          )
                                              : const SizedBox(),

                                          itemEventOfDay.description != null ? SizedBox(height: 4.h) : const SizedBox(),
                                          itemEventOfDay.description != null
                                              ? Text(
                                                  itemEventOfDay.description!.capitalize(),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.grey70Color,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          itemEventOfDay.additionally != null ? SizedBox(height: 4.h) : const SizedBox(),
                                          itemEventOfDay.additionally != null
                                              ? Text(
                                            itemEventOfDay.additionally!.capitalize(),
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.grey50Color,
                                            ),
                                          )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ) : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.basicblackColor.withOpacity(0.1),
                                  blurRadius: 10.r,
                                ),
                              ],
                              border: itemEventOfDay.eventStatus?.name == "Просрочено" ? Border.all(color: AppColors.redColor, width: 1) : null,
                              borderRadius: BorderRadius.circular(8.r),
                              color: itemEventOfDay.eventStatus?.name == "Просрочено"
                                  ? AppColors.tintsColor
                                  : (index + 1) % 3 == 1
                                  ? AppColors.lightGreenColor
                                  : (index + 1) % 3 == 2
                                  ? AppColors.limeColor
                                  : AppColors.seaColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (getEventDate(itemEventOfDay.eventDate) != "")
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.r),
                                            color: AppColors.basicwhiteColor,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                            child: Text(
                                              getEventDate(itemEventOfDay.eventDate),
                                              style: TextStyle(
                                                fontSize: 14.w,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.darkGreenColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        itemEventOfDay.eventStatus?.name == "Просрочено" ? SizedBox(height: 8.h) : const SizedBox(),
                                        itemEventOfDay.eventStatus?.name == "Просрочено"
                                            ? Text(
                                          'просрочено',
                                          style: TextStyle(
                                            fontSize: 10.w,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.redColor,
                                          ),
                                        )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  SizedBox(
                                    width: getEventDate(itemEventOfDay.eventDate) == "" ? 0 : 23.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          itemEventOfDay.eventName != null ? itemEventOfDay.eventName!.capitalize() : "",
                                          style: TextStyle(
                                            fontSize: 20.w,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.darkGreenColor,
                                          ),
                                        ),
                                        itemEventOfDay.description != null ? SizedBox(height: 8.h) : const SizedBox(),
                                        itemEventOfDay.description != null
                                            ? Text(
                                          itemEventOfDay.description!.capitalize(),
                                          style: TextStyle(
                                            fontSize: 14.w,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.grey70Color,
                                          ),
                                        )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  );
                }),
          ],
        ),
      );
    }
    else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 22.h),
            Text(
              DateTime.now().year == widget.chosenDate.year && DateTime.now().month == widget.chosenDate.month && DateTime.now().day == widget.chosenDate.day
                  ? 'Запланировано на сегодня:'
                  : 'Запланировано на ${widget.chosenDate.day} ${CalendarStorage.nameMonthByNumber[widget.chosenDate.month]} ${widget.chosenDate.year}:',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: AppColors.darkGreenColor,
              ),
            ),
            SizedBox(height: 44.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Нет событий',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreenColor,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: AppColors.darkGreenColor,
                  ),
                  child: FormForButton(
                    borderRadius: BorderRadius.circular(4.r),
                    onPressed: () {
                      context.router.push(ClientCalendarAddNewEventRoute(selectedDate: widget.chosenDate)).then((value) {
                        if (value == true) {
                          String newDate = DateFormat("yyyy-MM-dd").format(widget.chosenDate);
                          context.read<CalendarForDayBloc>().add(CalendarForDayGetEvent(newDate));
                          context.read<CalendarCubit>().check();
                        }
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 16.w,
                      ),
                      child: Text(
                        'добавить'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          color: AppColors.basicwhiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 44.h),
          ],
        ),
      );
    }
  }



  String getEventDate(String? eventDate) {
    if (eventDate != null) {
      String newDate = DateFormatting().formatTime(eventDate);
      if (newDate == "00:00") {
        return "";
      } else {
        return newDate;
      }
    } else {
      return "";
    }
  }

  Widget slideRightBackground() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.rubinColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.basicwhiteColor),
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 15),
            SvgPicture.asset("assets/images/trash.svg"),
            SizedBox(width: 10),
            Text(
              "Удалить событие",
              style: TextStyle(
                fontFamily: "Inter",
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

