// ignore_for_file: must_be_immutable

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garnetbook/bloc/client/trackers/trackers_cubit.dart';
import 'package:garnetbook/data/models/client/trackers/slot_view.dart';
import 'package:garnetbook/data/models/client/trackers/tracker_request.dart';
import 'package:garnetbook/data/models/item/item_model.dart';
import 'package:garnetbook/domain/services/client/trackers/trackers_service.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/widget_button.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ClientMyDayTrackerSlots extends StatefulWidget {
  ClientMyDayTrackerSlots({super.key, required this.id, required this.slots, this.name, this.statusName});

  final String? name;
  final int id;
  String? statusName;
  List<ClientTrackerSlotsView> slots;

  @override
  State<ClientMyDayTrackerSlots> createState() => _ClientMyDayTrackerSlotsState();
}

class _ClientMyDayTrackerSlotsState extends State<ClientMyDayTrackerSlots> {
  List<SlotItem> slotList = [];
  List<SlotItem> initialSlotList = [];

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.basicwhiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 4.h),
            Container(
              height: 4,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.grey20Color,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    List<SlotItem> newList = [];
                    slotList.forEach((element) {
                      initialSlotList.forEach((item) {
                        if (element.id == item.id && element.iChecked != item.iChecked) {
                          newList.add(element);
                        }
                      });
                    });

                    if (newList.isNotEmpty) {
                      validate(context, newList);
                    } else {
                      context.router.maybePop();
                    }
                  },
                  icon: Image.asset(
                    AppImeges.arrow_back_png,
                    color: AppColors.darkGreenColor,
                    height: 25.h,
                    width: 25.w,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: SizedBox(
                    child: Text(
                      widget.name ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        fontFamily: 'Inter',
                        color: AppColors.darkGreenColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
            ),
            SizedBox(height: 5.h),
            Container(
              height: 1,
              width: double.infinity,
              color: AppColors.lightGreenColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    '(Нажмите на гранат, чтобы отметить выполнение трекера)',
                    style: TextStyle(
                      fontSize: 10.w,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey50Color,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GridView.builder(
                      itemCount: slotList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.7,
                        crossAxisCount: 5, // number of items in each row
                        mainAxisSpacing: 16.h, // spacing between rows
                        crossAxisSpacing: 16.w, // spacing between columns
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            DateTime date = slotList[index].date;
                            DateTime today = DateTime.now();

                            if (date.day == today.day && date.month == today.month && date.year == today.year) {
                              setState(() {
                                slotList[index].iChecked = !slotList[index].iChecked;
                              });
                            } else if (today.difference(date).inDays > 0) {
                              setState(() {
                                slotList[index].iChecked = !slotList[index].iChecked;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text(
                                    'Нельзя выбрать будущий день',
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
                          child: Column(
                            children: [
                              SizedBox(
                                child: slotList[index].iChecked
                                    ? Image.asset(
                                        'assets/images/logoo.webp',
                                        width: 32.w,
                                        height: 40.h,
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/logo_grey_null.svg',
                                        width: 32.w,
                                        height: 40.h,
                                      ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                DateFormat("dd.MM").format(slotList[index].date),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: slotList[index].iChecked ? AppColors.tints4Color : AppColors.grey40Color,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                height: 1,
                                color: slotList[index].iChecked ? AppColors.tints2Color : AppColors.grey10Color,
                                width: 40.w,
                              ),
                              Text(
                                '${slotList[index].dayNumber} день',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: slotList[index].iChecked ? AppColors.tints4Color : AppColors.grey40Color,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(height: 30.h),
                  Row(
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
                            List<SlotItem> newList = [];

                            slotList.forEach((element) {
                              initialSlotList.forEach((item) {
                                if (element.id == item.id && element.iChecked != item.iChecked) {
                                  newList.add(element);
                                }
                              });
                            });

                            if (newList.isNotEmpty) {
                              validate(context, newList);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text(
                                    'Выберите значение',
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
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getList() {
    for (int index = 0; index < widget.slots.length; index++) {
      final element = widget.slots[index];

      if (element.needChecked != null && element.checked != null && element.trackerSlotId != null) {
        DateTime date = DateTime.parse(element.needChecked!);

        slotList
            .add(SlotItem(date: date, iChecked: element.checked!, dayNumber: index, id: element.trackerSlotId!, currentMonth: date.month));

        initialSlotList
            .add(SlotItem(date: date, iChecked: element.checked!, dayNumber: index, id: element.trackerSlotId!, currentMonth: date.month));
      }
    }

    if (slotList.isNotEmpty && slotList.length > 32) {
      int currentMonth = DateTime.now().month;
      slotList.removeWhere((element) => element.currentMonth != currentMonth);
    }
  }

  validate(BuildContext context, List<SlotItem> list) async {
    final service = TrackersService();

    FocusScope.of(context).unfocus();
    context.loaderOverlay.show();

    bool isResponseError = false;
    bool isLastDay = false;

    for (var element in list) {
      final response = await service.getTrackersSlot(element.id, element.iChecked);

      if (!response.result) {
        isResponseError = true;
        break;
      } else {
        if (widget.slots.last.needChecked != null) {
          DateTime lastDate = DateTime.parse(widget.slots.last.needChecked!);
          if (lastDate == element.date) {
            isLastDay = true;
          }
        }
      }
    }

    if (isResponseError) {
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
    } else {
      if (widget.statusName == "Новое") {
        await service.setTracker(ClientTrackerRequest(trackerStatusId: 2, clientTrackerId: widget.id));
      }

      if (isLastDay) {
        bool isAllChecked = true;

        for (var element in slotList) {
          if (!element.iChecked) {
            isAllChecked = false;
            break;
          }
        }

        if (isAllChecked) {
          await service.setTracker(ClientTrackerRequest(trackerStatusId: 5, clientTrackerId: widget.id));
        } else {
          await service.setTracker(ClientTrackerRequest(trackerStatusId: 3, clientTrackerId: widget.id));
        }

        context.loaderOverlay.hide();
        context.read<TrackersCubit>().check();
        context.router.maybePop("last");
      } else {
        context.loaderOverlay.hide();
        context.read<TrackersCubit>().check();
        context.router.maybePop(true);
      }
    }
  }
}
